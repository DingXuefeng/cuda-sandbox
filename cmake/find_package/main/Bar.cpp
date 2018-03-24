#include "Foo.hpp"
#include "Bar.hpp"
#inlcude "Boo.hpp"
void Bar::inviteFoo() {
  Foo foo;
  foo.say();
  Boo boo;
  boo.say();
}
int main() {
  Bar bar;
  bar.inviteFoo();
  return 0;
}
