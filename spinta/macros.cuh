#pragma once

#ifdef DEBUG
#define debug(...) printf(__VA_ARGS__);
#else
#define debug(...) ;
#endif