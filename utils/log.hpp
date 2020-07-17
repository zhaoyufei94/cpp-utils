#ifdef __ANDROID__
#include <android/log.h>
#define ANDROID_LOG_TAG "MorVoice"
#endif

#include <vector>
#include <base_util.hpp>

template <class>
struct LoggerHelper {
    typedef enum {
        VERBOSE_LOG     = 0,
        DEBUG_LOG,
        INFO_LOG,
        WARNING_LOG,
        ERROR_LOG,
        FATAL_LOG,
    } log_level_t;

protected:
    static FILE *log_target;
    static int log_level;
    static std::vector<std::string> log_level_names;
};

template <class Log>
FILE *LoggerHelper<Log>::log_target = stdout;

template <class Log>
int LoggerHelper<Log>::log_level = LoggerHelper<Log>::INFO_LOG;

template <class Log>
std::vector<std::string> LoggerHelper<Log>::log_level_names = {"VERBOSE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"};


class Logger : public LoggerHelper<void> {
public:

    static void SetLoggerLevel(log_level_t level) {
        log_level = level;
    }

    static void SetLoggerTarget(FILE *target) {
        log_target = target;
    }

    template<typename... Args>
    static void V(const char *text, Args ... args) {
        Write(VERBOSE_LOG, text, args ...);
    }

    template<typename... Args>
    static void D(const char *text, Args ... args) {
        Write(DEBUG_LOG, text, args ...);
    }

    template<typename... Args>
    static void I(const char *text, Args ... args) {
        Write(INFO_LOG, text, args ...);
    }

    template<typename... Args>
    static void W(const char *text, Args ... args) {
        Write(WARNING_LOG, text, args ...);
    }

    template<typename... Args>
    static void E(const char *text, Args ... args) {
        Write(ERROR_LOG, text, args ...);
    }

    template<typename... Args>
    static void Write(log_level_t level, const char *text, Args ... args) {
#ifdef __ANDROID__
        level = std::min(level, ERROR_LOG);
        __android_log_print(GetAndroidLogLevel(level), ANDROID_LOG_TAG, text, args ...);
#endif
        if (level < log_level || level > FATAL_LOG || !log_target)
            return;
        fprintf(log_target, "%s\t%s\t", Util::GetTimeFormat().c_str(), GetLoggerLevelName(level));
        fprintf(log_target, text, args ...);
        fflush(log_target);
    }

private:
    // = {"VERBOSE", "DEBUG", "INFO", "WARNING", "ERROR", "FATAL"};
    static const char *GetLoggerLevelName(log_level_t level) {
        if (level < VERBOSE_LOG || level > FATAL_LOG)
            return nullptr;
        return log_level_names[level].c_str();
    }

#ifdef __ANDROID__
    static android_LogPriority GetAndroidLogLevel(log_level_t level)  {
        switch (level) {
            case ERROR_LOG  :
                return ANDROID_LOG_ERROR;
            case WARNING_LOG  :
                return ANDROID_LOG_WARN;
            case INFO_LOG  :
                return ANDROID_LOG_INFO;
            case DEBUG_LOG  :
                return ANDROID_LOG_DEBUG;
            case VERBOSE_LOG  :
                return ANDROID_LOG_VERBOSE;
            default :
                return ANDROID_LOG_VERBOSE;
        }
    }
#endif
};