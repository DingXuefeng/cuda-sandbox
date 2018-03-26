#include "Bar.hpp"
#include "Foo.hpp"
#include "Boo.hpp"
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
