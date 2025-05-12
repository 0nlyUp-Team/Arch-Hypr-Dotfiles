#include "includes.h"
using namespace std;
namespace fs = std::filesystem;
class Info {
public:
    string getShell(){const char* s=getenv("SHELL");return s?s:"Unknown";}
    string getKernel(){utsname u;return uname(&u)==0?u.release:"Unknown";}
    string getDistro(){
        ifstream f("/etc/os-release");string l;
        while(getline(f,l))if(l.find("PRETTY_NAME=")==0)
            return l.substr(13,l.size()-14);
        ifstream lsb("/etc/lsb-release");
        while(getline(lsb,l))if(l.find("DISTRIB_DESCRIPTION=")==0)
            return l.substr(20,l.size()-21);
        return "Unknown Linux Distro :<";
    }
    string getUsername(){
        if(char* l=getlogin())return l;if(char* u=getenv("USER"))return u;passwd* p=getpwuid(geteuid());return p?p->pw_name:"Unknown";
    }
    string getCPU(){
        ifstream f("/proc/cpuinfo");string l,m;int c=0,t=0;
        while(getline(f,l)){
            if(l.find("model name")==0)m=l.substr(l.find(": ")+2);
            if(l.find("cpu cores")==0)c=stoi(l.substr(l.find(": ")+2));
            if(l.find("processor")==0)t++;}
        m=regex_replace(m,regex("(Intel\\(R\\) Core\\(TM\\) |AMD )"),"");
        return m+" ("+to_string(c)+"c/"+to_string(t)+"t)";
    }
    string getGPU() {
        // Try to get NVIDIA GPU info first
        FILE* nvidia = popen("nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null", "r");
        if (nvidia) {
            char buffer[256];
            if (fgets(buffer, sizeof(buffer), nvidia)) {
                pclose(nvidia);
                string gpu = buffer;
                // Trim newline character
                if (!gpu.empty() && gpu[gpu.length()-1] == '\n')
                    gpu.erase(gpu.length()-1);
                return gpu + " (NVIDIA)";
            }
            pclose(nvidia);
        }
        
        // Try AMD GPU
        ifstream amd("/sys/class/drm/card0/device/vendor");
        if (amd) {
            string vendor;getline(amd, vendor);
            if (vendor == "0x1002") { // AMD vendor ID
                ifstream name("/sys/class/drm/card0/device/product");
                if (name) {string product;getline(name, product);return product + " (AMD)";}
            }
        }
        
        // Try Intel or integrated GPU
        FILE* lspci = popen("lspci | grep -i 'vga\\|3d\\|display' | head -n1", "r");
        if (lspci) {
            char buffer[256];
            if (fgets(buffer, sizeof(buffer), lspci)) {
                pclose(lspci);
                string gpu = buffer;
                // Extract the part after ": "
                size_t pos = gpu.find(": ");
                if (pos != string::npos)
                    gpu = gpu.substr(pos + 2);
                // Trim newline
                if (!gpu.empty() && gpu[gpu.length()-1] == '\n')
                    gpu.erase(gpu.length()-1);
                return gpu;
            }
            pclose(lspci);
        }
        
        return "Unknown";
    }
    string getPKG() {
        int pkgCount = 0;
        int aurCount = 0;
        
        // Count official pacman packages
        FILE* pacman = popen("pacman -Q | wc -l 2>/dev/null", "r");
        if (pacman) {
            char buffer[32];
            if (fgets(buffer, sizeof(buffer), pacman)) {
                pkgCount = atoi(buffer);
            }
            pclose(pacman);
        }
        
        // Check if yay is installed for AUR packages
        FILE* yay = popen("command -v yay >/dev/null && yay -Qm | wc -l 2>/dev/null", "r");
        if (yay) {
            char buffer[32];
            if (fgets(buffer, sizeof(buffer), yay)) {
                aurCount = atoi(buffer);
            }
            pclose(yay);
        } else {
            // Try with pacaur instead
            FILE* pacaur = popen("command -v pacaur >/dev/null && pacaur -Qm | wc -l 2>/dev/null", "r");
            if (pacaur) {
                char buffer[32];
                if (fgets(buffer, sizeof(buffer), pacaur)) {
                    aurCount = atoi(buffer);
                }
                pclose(pacaur);
            } else {
                // Or try with paru
                FILE* paru = popen("command -v paru >/dev/null && paru -Qm | wc -l 2>/dev/null", "r");
                if (paru) {
                    char buffer[32];
                    if (fgets(buffer, sizeof(buffer), paru)) {
                        aurCount = atoi(buffer);
                    }
                    pclose(paru);
                }
            }
        }
        
        if (aurCount > 0) {
            return to_string(pkgCount) + " (pacman), " + to_string(aurCount) + " (AUR)";
        } else {
            return to_string(pkgCount) + " (pacman)";
        }
    }
    string getRAM() {
        ifstream f("/proc/meminfo");
        unordered_map<string, long> m;string k;long v;string unit;
        while(f >> k >> v >> unit) { m[k.substr(0, k.size()-1)] = v;}
        long used = m["MemTotal"] - m["MemFree"] - m["Buffers"] - m["Cached"];   
        return to_string(used / 1024) + "МБ / " + to_string(m["MemTotal"] / 1024) + "МБ";
    }
    string getBAT() {
        for (int i = 0; i < 10; ++i) {
            string p = "/sys/class/power_supply/BAT" + to_string(i);
            if (filesystem::exists(p)) {
                ifstream f(p + "/capacity"), s(p + "/status");string cap, stat;
                getline(f, cap); getline(s, stat);return "BAT" + to_string(i) + ": " + cap + "% (" + stat + ")";}}
                    return "No Battery";
    }
};
int main(){Info f;string u=f.getUsername(),h="ARCHLINUX";
    //cout<<"       /\\"<<"         "<<u<<"@"<<h<<"\n"
    cout<<"       /\\"<<"         "<<u<<"@"<<f.getDistro()<<"\n"
       <<"      /  \\"<<"        OS: "<<f.getDistro()<<"\n"
       <<"     /    \\"<<"       SH: "<<f.getShell()<<"\n"
       <<"    /      \\"<<"      CPU: "<<f.getCPU()<<"\n"
       <<"   / > w <  \\"<<"     GPU: "<<f.getGPU()<<"\n"
       <<"  /  **--**  \\"<<"    PKG: "<<f.getPKG()<<"\n"
       <<" / *-      -* \\"<<"   RAM: "<<f.getRAM()<<"\n"
       <<"/_-          -_\\"<<"  BAT: "<<f.getBAT()<<"\n"
       <<"               "<<"   KERNEL: "<<f.getKernel()<<"\n";}
