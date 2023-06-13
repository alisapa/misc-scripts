/* Amount of days since the UNIX timestamp given as argument */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char **argv) {
  char buf[20];
  char *str;
  if (argc > 1) str = argv[1];
  else {
    str = buf;
    fgets(str, 20, stdin);
  }

  time_t then = strtoll(str, NULL, 10);
  time_t now = time(NULL);
  printf("%lld\n", (long long) (now - then) / (24*60*60));
  return 0;
}
