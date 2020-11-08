//
// This header exposes the public streaming API for client usage
//

#include <Foundation/Foundation.h>
#include "Limelight.h"
#include "Log.h"
#include "Cloudy-Swift.h"

// This function queues a relative mouse move event to be sent to the remote server.
int LiSendMouseMoveEvent(short deltaX, short deltaY)
{
    LogI(@"LiSendMouseMoveEvent");
    return 0;
}

// This function queues a mouse position update event to be sent to the remote server.
// This functionality is only reliably supported on GFE 3.20 or later. Earlier versions
// may not position the mouse correctly.
//
// Absolute mouse motion doesn't work in many games, so this mode should not be the default
// for mice when streaming. It may be desirable as the default touchscreen behavior if the
// touchscreen is not the primary input method.
//
// The x and y values are transformed to host coordinates as if they are from a plane which
// is referenceWidth by referenceHeight in size. This allows you to provide coordinates that
// are relative to an arbitrary plane, such as a window, screen, or scaled video view.
//
// For example, if you wanted to directly pass window coordinates as x and y, you would set
// referenceWidth and referenceHeight to your window width and height.
int LiSendMousePositionEvent(short x, short y, short referenceWidth, short referenceHeight)
{
    LogI(@"LiSendMousePositionEvent");
    return 0;
}

int LiSendMouseButtonEvent(char action, int button)
{
    LogI(@"LiSendMouseButtonEvent");
    return 0;
}

int LiSendKeyboardEvent(short keyCode, char keyAction, char modifiers)
{
    LogI(@"LiSendKeyboardEvent");
    return 0;
}

// This function queues a controller event to be sent to the remote server. It will
// be seen by the computer as the first controller.
int LiSendControllerEvent(short buttonFlags, unsigned char leftTrigger, unsigned char rightTrigger,
                          short leftStickX, short leftStickY, short rightStickX, short rightStickY)
{
    LogI(@"LiSendControllerEvent");
    return 0;
}

// This function queues a controller event to be sent to the remote server. The controllerNumber
// parameter is a zero-based index of which controller this event corresponds to. The largest legal
// controller number is 3 (for a total of 4 controllers, the Xinput maximum). On generation 3 servers (GFE 2.1.x),
// these will be sent as controller 0 regardless of the controllerNumber parameter. The activeGamepadMask
// parameter is a bitfield with bits set for each controller present up to a maximum of 4 (0xF).
int LiSendMultiControllerEvent(short controllerNumber, short activeGamepadMask,
                               short buttonFlags, unsigned char leftTrigger, unsigned char rightTrigger,
                               short leftStickX, short leftStickY, short rightStickX, short rightStickY)
{
    LogI([NSString stringWithFormat:@"LiSendMultiControllerEvent: %i, %i, %i, %i, %i, %i, %i, %i, %i",
                                    controllerNumber, activeGamepadMask, buttonFlags, leftTrigger, rightTrigger,
                                    leftStickX, leftStickY, rightStickX, rightStickY]);
    [WebViewControllerBridge submitWithControllerNumber:controllerNumber
                             activeGamepadMask:activeGamepadMask
                             buttonFlags:buttonFlags
                             leftTrigger:leftTrigger
                             rightTrigger:rightTrigger
                             leftStickX:leftStickX
                             leftStickY:leftStickY
                             rightStickX:rightStickX
                             rightStickY:rightStickY];
    return 0;
}

// This function queues a vertical scroll event to the remote server.
// The number of "clicks" is multiplied by WHEEL_DELTA (120) before
// being sent to the PC.
int LiSendScrollEvent(signed char scrollClicks)
{
    LogI(@"LiSendScrollEvent");
    return 0;
}

// This function queues a vertical scroll event to the remote server.
// Unlike LiSendScrollEvent(), this function can send wheel events
// smaller than 120 units for devices that support "high resolution"
// scrolling (Apple Trackpads, Microsoft Precision Touchpads, etc.).
int LiSendHighResScrollEvent(short scrollAmount)
{
    LogI(@"LiSendHighResScrollEvent");
    return 0;
}
