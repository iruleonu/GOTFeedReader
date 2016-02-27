//
//  Networking.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#ifndef Networking_h
#define Networking_h

#ifdef USE_DEVELOP_SERVER
#define BASE_URL @"http://.com"
#elif USE_ADHOC_SERVER
#define BASE_URL @"http://.com"
#else
#define BASE_URL @"http://.com"
#endif

#endif /* Networking_h */
