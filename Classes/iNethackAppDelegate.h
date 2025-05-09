//
//  iNethackAppDelegate.h
//  iNetHack
//
//  Created by dirk on 6/16/09.
//  Copyright Dirk Zimmermann 2009. All rights reserved.
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
#define kOptionDoubleTapSensitivity (@"doubleTapSensitivity")

@class MainMenuViewController;

@interface iNethackAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UINavigationController *mainNavigationController;
	IBOutlet MainMenuViewController *mainMenuViewController;
	NSMutableArray *badBones;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (BOOL) checkNetHackDirectories;
- (void) launchNetHack;
- (void) launchHearse;

@end

