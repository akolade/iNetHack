//
//  MainView.h
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

#import "hack.h"

#define kKeyTileSize (@"tileSize")

@class MainViewController, TilePosition, Window, TileSet, ShortcutView;

@interface MainView : UIView {

	MainViewController *mainViewController;
	UIFont *statusFont;
	CGSize maxTileSize;
	CGSize minTileSize;
	IBOutlet UITextField *dummyTextField;

	BOOL tiled;
	TileSet *tileSet;
    TileSet *tileSetAnim;
	TileSet *tileSets[3];
	
	CGPoint offset;
	ShortcutView *shortcutView;
	
	UIImage *petMark;
	
	CGSize tilesetTileSize;
	BOOL asciiTileset;
    BOOL ibmTileset;
    BOOL colorInvert; // Textmode: White background, black becomes white.
    BOOL animatedTileset;
	UIButton *moreButton;
	
	NSString *bundleVersionString;
    
    NSCache * cache; //iNethack2: glyph cache for faster rendering
    NSCache * cache2; //iNethack2: second glyph cache for animated tilsets.
    
}

@property (nonatomic, readonly) CGPoint start;
@property (nonatomic, readonly) CGSize tileSize;
@property (nonatomic, readonly) BOOL colorInvert;
@property (nonatomic, readonly) IBOutlet UITextField *dummyTextField;
@property (nonatomic, readonly, getter=isMoved) BOOL moved;
@property (nonatomic, readonly, retain) TileSet *tileSet;
@property (nonatomic, retain) Window *map;
@property (nonatomic, retain) Window *status;
@property (nonatomic, retain) Window *message;
@property (nonatomic, readonly) CGPoint subViewedCenter;
@property (nonatomic, readonly, retain) NSCache *cache; //iNethack2: glyph cache
@property (nonatomic, readonly, retain) NSCache *cache2; //iNethack2: animated glyph cache

- (void) drawTiledMap:(Window *)m clipRect:(CGRect)clipRect;
- (void) checkForRogueLevel;
- (UIFont *) fontAndSize:(CGSize *)size forStrings:(NSArray *)strings withFont:(UIFont *)font;
- (UIFont *) fontAndSize:(CGSize *)size forString:(NSString *)s withFont:(UIFont *)font;
- (TilePosition *) tilePositionFromPoint:(CGPoint)p;
- (void) moveAlongVector:(CGPoint)d;
- (void) resetOffset;
- (void) zoom:(CGFloat)d;
- (void) resetGlyphCache; //iNethack2: reset cache each time level change to ensure walls are correct set
@end
