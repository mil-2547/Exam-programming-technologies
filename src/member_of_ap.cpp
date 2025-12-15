#include "member_of_ap.hpp"

long long int choose_member_of_ap(int first, int step, unsigned int n) {
	if (n == 0) return 0;
  return first + (n-1)*step;
}