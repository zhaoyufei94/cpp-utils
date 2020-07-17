/*
 *Copyright © 2020 Moran . All rights reserved.
 *
 *Author: Yufei Zhao
 *Date: 2020-05-15
 */

#ifndef TIMER_HPP
#define TIMER_HPP

#include <vector>
#include <thread>
#include <atomic>
#include <mutex>
#include <functional>
#include <boost/timer/timer.hpp>
#include <boost/asio.hpp>

typedef boost::posix_time::milliseconds mor_milliseconds;
typedef boost::posix_time::seconds      mor_seconds;

template<typename Duration = mor_milliseconds>
class MorTimer
{
public:
    MorTimer() : timer_(asio_, Duration(0)), single_shot_(true), active_(false) {}

    ~MorTimer() { stop(); }

    void start(unsigned int duration) {
        reset();

        {
        std::lock_guard<std::mutex> lck(mtx);
        if (active_)
            return;
        active_ = true;
        }
        duration_ = duration;
        timer_.expires_from_now(Duration(duration_));
        m_func = [this] {
            timer_.async_wait([this](const boost::system::error_code&) {
                {
                    std::lock_guard<std::mutex> lck(mtx);
                    if (!active_)
                        return;
                }

                for (auto& func : func_vec_) {
                    func();
                }

                if (!single_shot_) {
                    timer_.expires_at(timer_.expires_at() + Duration(duration_));
                    m_func();
                }
            });
        };

        m_func();
        thread_ = std::thread([this]{ asio_.run(); });
    }

    void reset() {
        {
        std::lock_guard<std::mutex> lck(mtx);
        if (!active_)
            return;
        active_ = false;
        }
        bool single_shot = single_shot_;
        single_shot_ = true;
        timer_.expires_from_now(Duration(0));
        timer_.cancel();
        if (thread_.joinable())
            thread_.join();
        asio_.reset();
        single_shot_ = single_shot;
    }


    void bind(const std::function<void(void)>& func) {
        func_vec_.emplace_back(func);
    }

    void set_single_shot(bool isSingleShot) {
        single_shot_ = isSingleShot;
    }

    bool is_single_shot() const {
        return single_shot_;
    }

    bool is_active() const {
        return active_;
    }

private:
    void stop() {
        asio_.stop();
        if (thread_.joinable())
        {
            thread_.join();
        }
        active_ = false;
    }

    boost::asio::io_service asio_;
    boost::asio::deadline_timer timer_;
    std::function<void()> m_func = nullptr;
    std::vector<std::function<void(void)>> func_vec_;
    std::thread thread_;
    unsigned int duration_ = 0;
    std::atomic<bool> single_shot_;
    std::atomic_bool active_;
    std::mutex mtx;
};

#endif //TIMER_HPP
