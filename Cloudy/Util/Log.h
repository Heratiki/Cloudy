// Copyright (c) 2020 Nomad5. All rights reserved.

#import <Foundation/Foundation.h>
#import "Cloudy-Swift.h"

#define LogD(...) [Log dObjc:[NSString stringWithFormat:__VA_ARGS__] :[NSString stringWithUTF8String:(char*)__FILE__] :__LINE__]

#define LogI(...) [Log iObjc:[NSString stringWithFormat:__VA_ARGS__] :[NSString stringWithUTF8String:(char*)__FILE__] :__LINE__]

#define LogE(...) [Log eObjc:[NSString stringWithFormat:__VA_ARGS__] :[NSString stringWithUTF8String:(char*)__FILE__] :__LINE__]