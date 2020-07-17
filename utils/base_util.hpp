#include <string>
#include <sys/time.h>
#include <sstream>

class Util {
public:
    static std::string GetTimestamp() {
        timeval tv;
        gettimeofday(&tv, nullptr);
        uint64_t time = tv.tv_sec * 1000000 + tv.tv_usec;
        return std::to_string(time);                    // us
        // return std::to_string(time).substr(0, 13);   // ms
    }

    static std::string Int2String(int n, int m) {
        std::string res;
        if (std::to_string(n).length() >= m)
            return std::to_string(n);
        res.assign("0", m - std::to_string(n).length());
        return res + std::to_string(n);
    }

    static std::string GetTimeFormat() {
        time_t nowtime = time(nullptr);
        timeval tv;
        gettimeofday(&tv, 0);
        struct tm *time = localtime(&nowtime);

        std::stringstream ss;
        ss << time->tm_year + 1900 << " " << Int2String(time->tm_mon + 1, 2) << "-" << Int2String(time->tm_mday, 2)
           << " " << Int2String(time->tm_hour, 2) << ":" << Int2String(time->tm_min, 2)  << ":" << Int2String(time->tm_sec, 2)
           << "." << Int2String(tv.tv_usec / 1000, 3);
        return ss.str();
    }
};