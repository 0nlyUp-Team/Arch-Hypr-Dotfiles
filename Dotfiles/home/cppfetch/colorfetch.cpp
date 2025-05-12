#include <ncurses.h>
#include <sys/utsname.h>
#include <pwd.h>
#include <unistd.h>
#include <fstream>
#include <regex>
#include <unordered_map>
#include <filesystem>
#include <vector>
#include <string>

using namespace std;
namespace fs = filesystem;

class Info {
public:
    string getShell(){
        const char* s = getenv("SHELL");
        return s ? s : "Unknown";
    }
    string getKernel(){
        utsname u;
        return uname(&u)==0 ? u.release : "Unknown";
    }
    string getDistro(){
        ifstream f("/etc/os-release"); string l;
        while(getline(f,l)) if(l.rfind("PRETTY_NAME=",0)==0)
            return l.substr(13,l.size()-14);
        ifstream lsb("/etc/lsb-release");
        while(getline(lsb,l)) if(l.rfind("DISTRIB_DESCRIPTION=",0)==0)
            return l.substr(20,l.size()-21);
        return "Unknown";
    }
    string getUsername(){
        if(char* l=getlogin()) return l;
        if(char* u=getenv("USER")) return u;
        passwd* p = getpwuid(geteuid());
        return p ? p->pw_name : "Unknown";
    }
    string getCPU(){
        ifstream f("/proc/cpuinfo"); string L,M; int C=0,T=0;
        while(getline(f,L)){
            if(L.rfind("model name",0)==0) M=L.substr(L.find(": ")+2);
            if(L.rfind("cpu cores",0)==0) C = stoi(L.substr(L.find(": ")+2));
            if(L.rfind("processor",0)==0) T++;
        }
        M = regex_replace(M, regex("(Intel\\(R\\) Core\\(TM\\) |AMD )"), "");
        return M + " (" + to_string(C) + "c/" + to_string(T) + "t)";
    }
    string getGPU(){
        char B[256];
        // NVIDIA
        FILE* G = popen("nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null","r");
        if(G && fgets(B,sizeof(B),G)){
            pclose(G);
            string R = B; R.erase(R.find_last_of('\n'));
            return R + " (NVIDIA)";
        }
        if(G) pclose(G);
        // AMD
        ifstream V("/sys/class/drm/card0/device/vendor");
        string L;
        if(V && getline(V,L) && L=="0x1002"){
            ifstream N("/sys/class/drm/card0/device/product");
            if(N && getline(N,L)) return L + " (AMD)";
        }
        // Intel / other
        FILE* P = popen("lspci | grep -i 'vga\\|3d\\|display' | head -n1","r");
        if(P && fgets(B,sizeof(B),P)){
            pclose(P);
            string R = B;
            auto pos = R.find(": ");
            if(pos!=string::npos) R = R.substr(pos+2);
            R.erase(R.find_last_of('\n'));
            return R;
        }
        if(P) pclose(P);
        return "Unknown";
    }
    string getPKG(){
        char B[32]; int P=0,A=0;
        FILE* M = popen("pacman -Q | wc -l","r");
        if(M && fgets(B,sizeof(B),M)){ P = atoi(B); pclose(M); }
        for(auto& H:{"yay","pacaur","paru"}){
            string C = string("command -v ") + H + " >/dev/null && " + H + " -Qm | wc -l";
            FILE* A_ = popen(C.c_str(),"r");
            if(A_ && fgets(B,sizeof(B),A_)){ A = atoi(B); pclose(A_); break; }
            if(A_) pclose(A_);
        }
        return to_string(P) + " (pacman)" + (A ? ", " + to_string(A) + " (AUR)" : "");
    }
    string getRAM(){
        ifstream f("/proc/meminfo");
        unordered_map<string,long> M; string K,U; long V;
        while(f>>K>>V>>U) M[K.substr(0,K.size()-1)] = V;
        long Usg = M["MemTotal"] - M["MemFree"] - M["Buffers"] - M["Cached"];
        return to_string(Usg/1024) + "MB / " + to_string(M["MemTotal"]/1024) + "MB";
    }
    string getBAT(){
        for(int i=0;i<10;i++){
            string P = "/sys/class/power_supply/BAT"+to_string(i);
            if(!fs::exists(P)) continue;
            ifstream C(P+"/capacity"), S(P+"/status");
            string c,s; getline(C,c); getline(S,s);
            return "BAT"+to_string(i)+": "+c+"% ("+s+")";
        }
        return "No Battery";
    }
};

int main(){
    Info F;
    initscr();
    if(!has_colors()){ endwin(); return 1; }
    start_color();

    // цветовые пары для текста
    init_pair(1, COLOR_RED,    COLOR_BLACK);
    init_pair(2, COLOR_GREEN,  COLOR_BLACK);
    init_pair(3, COLOR_YELLOW, COLOR_BLACK);
    init_pair(4, COLOR_BLUE,   COLOR_BLACK);
    init_pair(5, COLOR_MAGENTA,COLOR_BLACK);
    init_pair(6, COLOR_CYAN,   COLOR_BLACK);
    init_pair(7, COLOR_WHITE,  COLOR_BLACK);

    // ASCII‑арт и информация
    attron(COLOR_PAIR(1));
    printw("       /\\         %s@%s\n", F.getUsername().c_str(), F.getDistro().c_str());
    attroff(COLOR_PAIR(1));

    attron(COLOR_PAIR(2));
    printw("      /  \\        OS: %s\n", F.getDistro().c_str());
    attroff(COLOR_PAIR(2));

    attron(COLOR_PAIR(3));
    printw("     /    \\       SH: %s\n", F.getShell().c_str());
    attroff(COLOR_PAIR(3));

    attron(COLOR_PAIR(4));
    printw("    /      \\      CPU: %s\n", F.getCPU().c_str());
    attroff(COLOR_PAIR(4));

    attron(COLOR_PAIR(5));
    printw("   / > w <  \\     GPU: %s\n", F.getGPU().c_str());
    attroff(COLOR_PAIR(5));

    attron(COLOR_PAIR(6));
    printw("  /  **--**  \\    PKG: %s\n", F.getPKG().c_str());
    attroff(COLOR_PAIR(6));

    attron(COLOR_PAIR(7));
    printw(" / *-      -* \\   RAM: %s\n", F.getRAM().c_str());
    attroff(COLOR_PAIR(7));

    attron(COLOR_PAIR(1));
    printw("/_-          -_\\  BAT: %s\n", F.getBAT().c_str());
    attroff(COLOR_PAIR(1));

    printw("               KERNEL: %s\n", F.getKernel().c_str());

    // --- рисуем цветную полосу ---
      vector<string> palette = {
          "#2e2e3e", "#45455f", "#6b526c", "#8c3f4f",
          "#c63333", "#77536b", "#65536b", "#9a9bb0"
      };

    if(can_change_color() && COLORS >= 16) {
        for(int i=0; i<(int)palette.size(); ++i) {
            int r = stoi(palette[i].substr(1,2), nullptr, 16) * 1000 / 255;
            int g = stoi(palette[i].substr(3,2), nullptr, 16) * 1000 / 255;
            int b = stoi(palette[i].substr(5,2), nullptr, 16) * 1000 / 255;
            int idx = 8 + i;
            init_color(idx, r, g, b);
            init_pair(10 + i, COLOR_BLACK, idx);
            attron(COLOR_PAIR(10 + i));
            addstr("  ");
            attroff(COLOR_PAIR(10 + i));
        }
        addch('\n');
    }

    refresh();
    getch();
    endwin();
    return 0;
}
