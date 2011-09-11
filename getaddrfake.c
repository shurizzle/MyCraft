#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>

#ifndef __USE_POSIX
# define __USE_POSIX
#   include <netdb.h>
# undef  __USE_POSIX
#else
# include <netdb.h>
#endif

#ifndef __USE_GNU
# define __USE_GNU
#   include <dlfcn.h>
# undef  __USE_GNU
#else
# include <dlfcn.h>
#endif

#include <errno.h>

typedef int (*func)(const char *, const char *, const struct addrinfo *, struct addrinfo **);

func __getaddrinfo;

void
_init (void) {
  const char *err;

  fprintf(stderr, "getaddrfake: initializing...");

  __getaddrinfo = (func) dlsym(RTLD_NEXT, "getaddrinfo");
  if ((err = dlerror())) {
    fprintf(stderr, "dlsym(getaddrinfo): %s\n", err);
  } else {
    fprintf(stderr, "DONE.\n");
  }
}

int
getaddrinfo (const char *node,
    const char *service,
    const struct addrinfo *hints,
    struct addrinfo **res) {
  char *l = (char *) ((unsigned long) node + (unsigned long) (strlen(node) - 13));

  if (!strcmp(node, "s3.amazonaws.com") || !strcmp(l, "minecraft.net")) {
    return __getaddrinfo(HOST, service, hints, res);
  } else {
    return __getaddrinfo(node, service, hints, res);
  }
}
