#include <gtest/gtest.h>

TEST(ChooseMemberOfAPTest, NormalCases) {
  EXPECT_EQ(choose_member_of_ap(1, 2, 1), 1);  // result: first
  EXPECT_EQ(choose_member_of_ap(1, 2, 2), 3);  // result: 3
  EXPECT_EQ(choose_member_of_ap(1, 2, 5), 9);  // result: 9
}

TEST(ChooseMemberOfAPTest, ZeroStep) {
  EXPECT_EQ(choose_member_of_ap(5, 0, 1), 5);
  EXPECT_EQ(choose_member_of_ap(5, 0, 10), 5);
}

TEST(ChooseMemberOfAPTest, ZeroN) {
  EXPECT_EQ(choose_member_of_ap(10, 3, 0), 0);
}

TEST(ChooseMemberOfAPTest, NegativeNumbers) {
  EXPECT_EQ(choose_member_of_ap(-1, -2, 3), -5); // -1 + (3-1)*(-2) = -5
  EXPECT_EQ(choose_member_of_ap(-5, 3, 4), 4);   // -5 + (4-1)*3 = 4
}