//
//  MainViewController.h
//  iNetHack
//
//  Created by dirk on 6/26/09.
//  Copyright 2009 Dirk Zimmermann. All rights reserved.
//

//  This file is part of iNetHack.
//
//  iNetHack is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 2 of the License only.
//
//  iNetHack is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iNetHack.  If not, see <http://www.gnu.org/licenses/>.

#import <UIKit/UIKit.h>
#include "hack.h"

// ctrl-macro
#ifndef C
#define C(c)		(0x1f & (c))
#endif

#define kMinimumPinchDelta (15)
#define kMinimumPanDelta (20)

#define kCenterTapWidth (40)

@class Window, NethackMenuViewController, NethackYnFunction, TextInputViewController, NethackEventQueue;
@class DirectionInputViewController, ExtendedCommandViewController;
@class TouchInfo, TouchInfoStore;
@class TilePosition;
@class DMath;

@interface MainViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate , UIAlertViewDelegate> {
	
	IBOutlet NethackMenuViewController *nethackMenuViewController;
	IBOutlet TextInputViewController *textInputViewController;
	IBOutlet DirectionInputViewController *directionInputViewController;
	IBOutlet ExtendedCommandViewController *extendedCommandViewController;

	//NSMutableArray *windows;
    NSMutableDictionary *windows; //iNethack2 making this a dict
    int windowIdCounter; //iNethack2 for dict
    
	TilePosition *clip;
	
	NethackEventQueue *nethackEventQueue;
	
	NethackYnFunction *currentYnFunction;
	
	NSCondition *textInputCondition;
	NSCondition *uiCondition;
	
	// imaginary rect for bringing up the main menu
	CGRect tapRect;
	
	CGFloat initialDistance;
	
	TouchInfoStore *touchInfoStore;
	
	TilePosition *lastSingleTapDelta;
	
	DMath *dmath;
	
	BOOL gameInProgress;
	BOOL keyboardReturnShouldQueueEscape;
    int animFrame;
	
	NSTimeInterval doubleTapSensitivity;
	
	NSThread *nethackThread;
	
	Window *blockingMap;
}

//@property (nonatomic, readonly) NSArray *windows;
@property (nonatomic, readonly, retain) NSDictionary *windows; //iNethack2: making this a dict
@property (nonatomic, readonly, retain) TilePosition *clip;
@property (nonatomic, readonly) Window *mapWindow;
@property (nonatomic, readonly) Window *messageWindow;
@property (nonatomic, readonly) Window *statusWindow;
@property (nonatomic, retain) NethackEventQueue *nethackEventQueue;
@property (assign) BOOL gameInProgress;
@property (assign) int animFrame;

+ (MainViewController *) instance;
+ (void) message:(NSString *)format, ...;
+ (void) message:(NSString *)message format:(va_list)arg_list;

- (void) launchNetHack;
- (void) mainNethackLoop:(id)arg;
- (void) mainNethackTestLoop:(id)arg;
- (winid) createWindow:(int)type;
- (void) destroyWindow:(winid)wid;
- (Window *) windowWithId:(winid)wid;
- (void) displayWindowId:(winid)wid blocking:(BOOL)blocking;
- (void) displayMessage:(Window *)w;

- (void) displayMenuWindow:(Window *)w;
- (void) displayMenuWindowOnUIThread:(Window *)w;

- (void) displayYnQuestion:(NethackYnFunction *)yn;
- (void) displayYnQuestionOnUIThread:(NethackYnFunction *)yn;

- (void) getLine:(char *)line prompt:(const char *)prompt;
- (void) getLineOnUIThread:(NSString *)s;

- (void) waitForUser;
- (void) broadcastUIEvent;
- (void) broadcastCondition:(NSCondition *)condition;
- (void) waitForCondition:(NSCondition *)condition;

// 0 means cancel, blocking
- (char) getDirectionInput;
- (void) showDirectionInputView:(id)obj;

- (void) nethackKeyboard:(id)i;
- (int) getExtendedCommand;

- (void) resetGlyphCache; //iNethack2: reset cache each time level change to ensure walls are correct set

- (void) doPlayerSelection;

- (void) nethackShowLog:(id)i;
- (void) displayFile:(NSString *)filename mustExist:(BOOL)e;

- (void) updateScreen;
- (void) showKeyboard:(BOOL)d;
- (void) didBecomeActive;

@end
