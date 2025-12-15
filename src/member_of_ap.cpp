#include "member_of_ap.hpp"
#include <stdexcept>

long long choose_member_of_ap(long long first, long long step, long long n) {
    if (n < 0)
        throw std::invalid_argument("n must be non-negative");

    if (n == 0)
        return 0;

    return first + (n - 1) * step;
}