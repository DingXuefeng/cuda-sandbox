#include "Foo.hpp"
#include "Bar.hpp"
void Bar::inviteFoo() {
  Foo foo;
  foo.say();
}
int main() {
  Bar bar;
  bar.inviteFoo();
  return 0;
}
