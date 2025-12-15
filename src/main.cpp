#include <pch.h>
#include "member_of_ap.hpp"

#define FIRST 3
#define STEP 2

int main() {
  crow::SimpleApp app;

  CROW_ROUTE(app, "/")([](){
      return "Mikhail Melik-Kazarian";
  });
  
  CROW_ROUTE(app, "/<int>")
  ([](int n){
    return std::to_string(choose_member_of_ap(FIRST, STEP, n));
  });

  app.port(18080).multithreaded().run();
}