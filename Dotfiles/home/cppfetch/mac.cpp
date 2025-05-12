#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include <unordered_map>
#include <cstdio>
#include <cstdlib>
#include <sys/utsname.h>
#include <unistd.h>
#include <pwd.h>

using namespace std;

class MacInfo {
public:
    string getShell() {
        const char* s = getenv("SHELL");
        return s ? s : "Unknown";
    }
    
    string getKernel() {
        utsname u;
        return uname(&u) == 0 ? string(u.sysname) + " " + string(u.release) : "Unknown";
    }
    
    string getOSVersion() {
        FILE* sw_vers = popen("sw_vers -productVersion", "r");
        if (sw_vers) {
            char buffer[256];
            if (fgets(buffer, sizeof(buffer), sw_vers)) {
                pclose(sw_vers);
                string version = buffer;
                // Trim newline
                if (!version.empty() && version[version.length()-1] == '\n')
                    version.erase(version.length()-1);
                return "macOS " + version;
            }
            pclose(sw_vers);
        }
        return "macOS Unknown";
    }
    
    string getUsername() {
        if (char* l = getlogin()) return l;
        if (char* u = getenv("USER")) return u;
        passwd* p = getpwuid(geteuid());
        return p ? p->pw_name : "Unknown";
    }
    
    string getHostname() {
        char hostname[256];
        if (gethostname(hostname, sizeof(hostname)) == 0) {
            return hostname;
        }
        return "Unknown";
    }
    
    string getCPU() {
        FILE* sysctl = popen("sysctl -n machdep.cpu.brand_string", "r");
        if (sysctl) {
            char buffer[256];
            if (fgets(buffer, sizeof(buffer), sysctl)) {
                pclose(sysctl);
                string cpu = buffer;
                // Trim newline
                if (!cpu.empty() && cpu[cpu.length()-1] == '\n')
                    cpu.erase(cpu.length()-1);
                
                // Replace common verbose parts
                cpu = regex_replace(cpu, regex("(Intel\\(R\\) Core\\(TM\\) |AMD )"), "");
                
                // Get core count
                FILE* core_count = popen("sysctl -n hw.physicalcpu", "r");
                int cores = 0;
                if (core_count) {
                    char c_buffer[32];
                    if (fgets(c_buffer, sizeof(c_buffer), core_count)) {
                        cores = atoi(c_buffer);
                    }
                    pclose(core_count);
                }
                
                // Get thread count
                FILE* thread_count = popen("sysctl -n hw.logicalcpu", "r");
                int threads = 0;
                if (thread_count) {
                    char t_buffer[32];
                    if (fgets(t_buffer, sizeof(t_buffer), thread_count)) {
                        threads = atoi(t_buffer);
                    }
                    pclose(thread_count);
                }
                
                return cpu + " (" + to_string(cores) + "c/" + to_string(threads) + "t)";
            }
            pclose(sysctl);
        }
        return "Unknown";
    }
    
    string getGPU() {
        FILE* system_profiler = popen("system_profiler SPDisplaysDataType | grep 'Chipset Model:' | sed 's/Chipset Model: //'", "r");
        if (system_profiler) {
            char buffer[256];
            if (fgets(buffer, sizeof(buffer), system_profiler)) {
                pclose(system_profiler);
                string gpu = buffer;
                // Trim newline and spaces
                if (!gpu.empty() && gpu[gpu.length()-1] == '\n')
                    gpu.erase(gpu.length()-1);
                
                // Trim leading whitespace
                gpu = regex_replace(gpu, regex("^\\s+"), "");
                
                return gpu;
            }
            pclose(system_profiler);
        }
        return "Unknown";
    }
    
    string getBrewPKG() {
        int pkgCount = 0;
        int caskCount = 0;
        
        // Count Homebrew packages
        FILE* brew = popen("command -v brew >/dev/null && brew list --formula | wc -l 2>/dev/null", "r");
        if (brew) {
            char buffer[32];
            if (fgets(buffer, sizeof(buffer), brew)) {
                pkgCount = atoi(buffer);
            }
            pclose(brew);
        }
        
        // Count Homebrew casks
        FILE* cask = popen("command -v brew >/dev/null && brew list --cask | wc -l 2>/dev/null", "r");
        if (cask) {
            char buffer[32];
            if (fgets(buffer, sizeof(buffer), cask)) {
                caskCount = atoi(buffer);
            }
            pclose(cask);
        }
        
        if (pkgCount == 0 && caskCount == 0) {
            return "Homebrew not found";
        } else if (caskCount > 0) {
            return to_string(pkgCount) + " (formula), " + to_string(caskCount) + " (cask)";
        } else {
            return to_string(pkgCount) + " (formula)";
        }
    }
    
    string getRAM() {
        // Get total memory
        FILE* total_mem = popen("sysctl -n hw.memsize", "r");
        long total = 0;
        if (total_mem) {
            char buffer[64];
            if (fgets(buffer, sizeof(buffer), total_mem)) {
                total = stol(buffer);
            }
            pclose(total_mem);
        }
        
        // Get used memory using vm_stat
        FILE* vm_stat = popen("vm_stat | grep 'Pages active\\|Pages wired down' | awk '{print $NF}' | tr -d '.'", "r");
        long active = 0, wired = 0;
        if (vm_stat) {
            char buffer[64];
            if (fgets(buffer, sizeof(buffer), vm_stat)) {
                active = stol(buffer) * 4096; // Convert pages to bytes (4KB pages)
                if (fgets(buffer, sizeof(buffer), vm_stat)) {
                    wired = stol(buffer) * 4096;
                }
            }
            pclose(vm_stat);
        }
        
        long used = active + wired;
        
        // Convert to MB
        long used_mb = used / (1024 * 1024);
        long total_mb = total / (1024 * 1024);
        
        return to_string(used_mb) + "МБ / " + to_string(total_mb) + "МБ";
    }
};

int main() {
    MacInfo info;
    string username = info.getUsername();
    string hostname = info.getHostname();
    
    cout << "       /\\"         << "         " << username << "@" << hostname << "\n"
         << "      /  \\"        << "        OS: " << info.getOSVersion() << "\n"
         << "     /    \\"       << "       SH: " << info.getShell() << "\n"
         << "    /      \\"      << "      CPU: " << info.getCPU() << "\n"
         << "   / > w <  \\"     << "     GPU: " << info.getGPU() << "\n"
         << "  /  **--**  \\"    << "    PKG: " << info.getBrewPKG() << "\n"
         << " / *-      -* \\"   << "   RAM: " << info.getRAM() << "\n"
         << "/_-          -_\\"  << "  KERNEL: " << info.getKernel() << "\n";
    
    return 0;
}