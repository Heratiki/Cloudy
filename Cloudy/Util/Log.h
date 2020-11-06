// Copyright (c) 2020 Nomad5. All rights reserved.

#import <Foundation/Foundation.h>
#import "Cloudy-Swift.h"

#define LogD(...) [Log d:[NSString stringWithFormat:__VA_ARGS__] :[NSString stringWithUTF8String:(char*)__FILE__] :__LINE__]

#define LogI(...) [Log i:[NSString stringWithFormat:__VA_ARGS__] :[NSString stringWithUTF8String:(char*)__FILE__] :__LINE__]

#define LogE(...) [Log e:[NSString stringWithFormat:__VA_ARGS__] :[NSString stringWithUTF8String:(char*)__FILE__] :__LINE__]