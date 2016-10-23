//
//  LPEnv.h
//  LogPush
//
//  Copyright (c) 2015 pLucky. All rights reserved.
//

#ifndef LogPush_LPEnv_h
#define LogPush_LPEnv_h

typedef enum {
  LPDevelopment = 1,
  LPProduction,
  LPUnknown,
  LPEnvFirst = LPDevelopment,
  LPEnvLast = LPUnknown
} LPEnv;

#ifndef LP_ENV
#ifdef DEBUG
#define LP_ENV LPDevelopment
#else
#define LP_ENV LPProduction
#endif
#endif

#endif
