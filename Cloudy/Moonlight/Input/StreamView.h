//
//  StreamView.h
//  Moonlight
//
//  Created by Cameron Gutman on 10/19/14.
//  Copyright (c) 2014 Moonlight Stream. All rights reserved.
//

#import "ControllerSupport.h"
#import "OnScreenControls.h"
#import "StreamConfiguration.h"

@protocol UserInteractionDelegate <NSObject>

    - (void)userInteractionBegan;

    - (void)userInteractionEnded;

@end

@protocol X1KitMouseDelegate;

#if TARGET_OS_TV
@interface StreamView : UIView <X1KitMouseDelegate, UITextFieldDelegate>
#else

@interface StreamView : UIView <X1KitMouseDelegate, UITextFieldDelegate, UIPointerInteractionDelegate>

#endif

    - (void)setupStreamView:(ControllerSupport *)controllerSupport
            interactionDelegate:(id <UserInteractionDelegate>)interactionDelegate
            config:(StreamConfiguration *)streamConfig;

    - (void)showOnScreenControls;

    - (void)updateOnScreenControls;

    - (OnScreenControlsLevel)getCurrentOscState;

#if !TARGET_OS_TV

    - (void)updateCursorLocation:(CGPoint)location isMouse:(BOOL)isMouse;

#endif

@end
