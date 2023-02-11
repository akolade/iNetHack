//
//  AsciiTileSet.m
//  iNetHack
//
//  Created by dirk on 8/24/09.
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

#import "AsciiTileSet.h"

#include "hack.h"
#include "display.h"

/*
static float _colorTable[][4] = {
{0,0,0,1}, // CLR_BLACK
{1,0,0,1}, // CLR_RED
{0,1,0,1}, // CLR_GREEN
{0.6f,0.3f,0.2f,1}, // CLR_BROWN
{0,0,1,1}, // CLR_BLUE
{1,0,1,1}, // CLR_MAGENTA
{0,0.3f,0.3f,1}, // CLR_CYAN
{0.7f,0.7f,0.7f,1}, // CLR_GRAY
{1,0,0,1}, // CLR_RED / NO_COLOR
{1,0.6f,0,1}, // CLR_ORANGE
{0.5f,1,0,1}, // CLR_BRIGHT_GREEN
{1,1,0,1}, // CLR_YELLOW
{0.4f,0.6f,0.9f,1}, // CLR_BRIGHT_BLUE
{0.2f,0,0.2f,1}, // CLR_BRIGHT_MAGENTA
{0,1,1,1}, // CLR_BRIGHT_CYAN
{1,1,1,1}, // CLR_WHITE
};
 */

@implementation AsciiTileSet

- (id) initWithTileSize:(CGSize)ts {
	if (self = [super initWithImage:nil tileSize:ts]) {
		numImages = MAX_GLYPH;
		size_t size = numImages * sizeof(CGImageRef);
		images = malloc(size);
		memset(images, 0, size);
		UIColor *brightGreenColor = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1];
		UIColor *brightBlueColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:1];
		UIColor *brightMagentaColor = [[UIColor alloc] initWithRed:0.2f green:0 blue:0.2f alpha:1];
		UIColor *brightCyanColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        UIColor *blackColor = [[UIColor alloc] initWithRed:0.2f green:0.2f blue:0.2f alpha:1];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *theTileset = [defaults objectForKey:@"tileset"];
        ibmTileset = NO;
        if ([theTileset isEqualToString:@"ibmgraphics"]) {
            ibmTileset = YES;
        }
        if ([theTileset isEqualToString:@"asciimono"]) {
            colorTable = [[NSArray alloc] initWithObjects:
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor], // NO_COLOR
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          [UIColor lightGrayColor],
                          nil];
        } else {
            colorTable = [[NSArray alloc] initWithObjects:
					  blackColor, //[UIColor blackColor], //iNethack2: use dark grey so you can see black monsters/items
					  [UIColor redColor],
					  [UIColor greenColor],
					  [UIColor brownColor],
					  [UIColor blueColor],
					  [UIColor magentaColor],
					  [UIColor cyanColor],
					  [UIColor grayColor],
					  [UIColor whiteColor], // NO_COLOR
					  [UIColor orangeColor],
					  brightGreenColor,
					  [UIColor yellowColor],
					  brightBlueColor,
					  brightMagentaColor,
					  brightCyanColor,
					  [UIColor whiteColor],
					  nil];
        }
		[brightGreenColor release];
		[brightBlueColor release];
		[brightMagentaColor release];
		[brightCyanColor release];
	}
	return self;
}

- (id) initWithImage:(UIImage *)image tileSize:(CGSize)ts {
	return [self initWithTileSize:ts];
}

- (CGImageRef) imageForGlyph:(int)g atX:(int)x y:(int)y {
	iflags.use_color = TRUE;
	int tile = [TileSet glyphToTileIndex:g];
    if (!images[tile]) {
        UIFont *font = [UIFont systemFontOfSize:28];
        int ochar, ocolor;
        unsigned special;
        mapglyph(g, &ochar, &ocolor, &special, x, y, 0);

        if (ibmTileset) {
            font = [UIFont fontWithName:@"Px437_IBM_VGA_8x16" size:64];
            NSLog(@"glyph %d, spcl %d, tile %d %c", g, special, tile, ochar);
            int baseTile = tile;

            // Adjust for special wall tiles (see tile.c)
            if (tile >= 1038 && tile <= 1048) {
                //In_mines
                baseTile -= 187;
            } else if (tile >= 1049 && tile <= 1059) {
                //In_hell
                baseTile -= 198;
            } else if (tile >= 1060 && tile <= 1070) {
                //Is_knox
                baseTile -= 209;
            } else if (tile >= 1071 && tile <= 1081) {
                //In_sokoban
                baseTile -= 220;
            }
            if (Is_rogue_level(&u.uz)) {
                ochar = [self adjustTilesRogueLevel:baseTile withOchar:ochar withGlyph:g];
            } else {
                ochar = [self adjustTiles:baseTile withOchar:ochar];
            }
        }

        NSLog(@"glyph %d, tile %d %C", g, tile, (unichar) ochar);

        NSString *s = [NSString stringWithFormat:@"%C", (unichar)ochar];
        CGSize size = [s sizeWithAttributes:@{NSFontAttributeName:font}];
		CGPoint p = CGPointMake((tileSize.width-size.width)/2, (tileSize.height-size.height)/2);
        UIGraphicsBeginImageContextWithOptions(tileSize, YES , 1);
		CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetShouldAntialias(ctx, false);
        CGContextSetAllowsAntialiasing(ctx, 0);
		UIColor *color = [self mapNetHackColor:ocolor];
        if (Is_rogue_level(&u.uz) && !ibmTileset) {
            color = [UIColor lightGrayColor];
        }
		CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
		CGRect r = CGRectZero;
		r.size = tileSize;
		CGContextFillRect(ctx, r);
		CGContextSetFillColorWithColor(ctx, color.CGColor);
        [s drawAtPoint:p withAttributes:@ { NSFontAttributeName: font, NSBackgroundColorAttributeName: [UIColor clearColor],
                NSForegroundColorAttributeName: color }];
		UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
		images[tile] = CGImageRetain(img.CGImage);
		UIGraphicsEndImageContext();
	}
	return images[tile];
}

/**
 Adjust ochar value for tiles when using IBMGraphics.
*/
- (int) adjustTiles:(int) tile withOchar:(int) ochar {
    switch (tile) {
        case 851: // vertical |
            ochar = 0x2502;
            break;
        case 852: //horizontal -
            ochar = 0x2500;
            break;
        case 853: // top-left -
            ochar = 0x250C;
            break;
        case 854: // top-right -
            ochar = 0x2510;
            break;
        case 855: // bottom left -
            ochar = 0x2514;
            break;
        case 856: // bottom right -
            ochar = 0x2518;
            break;
        case 857:
            ochar = 0x253C; // cross wall -
            break;
        case 858:
            ochar = 0x2534; // t-up wall -
            break;
        case 859:
            ochar = 0x252C; // t-down wall -
            break;
        case 860:
            ochar = 0x2524; // t-left wall -
            break;
        case 861:
            ochar = 0x251C; // t-right wall -
            break;
        case 871: // lit corridor #
            ochar = 0x2592;
            break;
        case 872: // dark corridor #
            ochar = 0x2591;
            break;
        case 867: // iron bars #
            ochar = 0x2261;
            break;
        case 868: // tree #
            ochar = 0x00B1;
            break;
        case 881: // fountain {
            ochar = 0x2320;
            break;
        case 884: // lava }
        case 891: // water }
        case 882: // pool }
            ochar = 0x2248;
            break;
        case 869: // floor .
        case 862: // open doorway floor .
        case 870: // dark floor .
        case 883: // ice .
        case 885: // vertical open drawbridge
        case 886: // horizontal open drawbridge
            ochar = 0x00B7;
            break;
        case 863: // open door -
        case 864: // open door |
            ochar = 0x25A0;
            break;
        default:
            break;
    }
    return ochar;
}

/**
 Adjust ochar value for tiles when using IBMGraphics on the Rogue level.
*/
- (int) adjustTilesRogueLevel:(int) tile withOchar:(int) ochar withGlyph:(int) g {
    int newOchar = ochar;

    // Check for objects
    if (glyph_is_object(g)) {
        switch ((unichar) ochar) {
            case '*':
            case '$':
                newOchar = 0x263C; // gold, gems *
                break;
            case '/':
                newOchar = 0x03C4; // wand /
                break;
            case ')':
                newOchar = 0x2191; // weapon )
                break;
            case '[':
                newOchar = 0x005D; // armour ]
                break;
            case '"':
            case ',':
                newOchar = 0x2640; // amulet " or ,
                break;
            case '!':
                newOchar = 0x00A1; // potion !
                break;
            case '?':
                newOchar = 0x266B; // scroll ?
                break;
            case '%':
            case ':':
                newOchar = 0x2663; // food : or %
                break;
        }
    } else {
        // Check for humanoids
        switch ((unichar) ochar) {
            case '@':
                newOchar = 0x263A; // human, elf @
                break;
        }
    }

    if (newOchar != ochar) {
        return newOchar;
    }

    // Dungeon features
    switch (tile) {
        case 851: // vertical |
            ochar = 0x2551;
            break;
        case 852: //horizontal -
            ochar = 0x2550;
            break;
        case 853: // top-left -
            ochar = 0x2554;
            break;
        case 854: // top-right -
            ochar = 0x2557;
            break;
        case 855: // bottom left -
            ochar = 0x255A;
            break;
        case 856: // bottom right -
            ochar = 0x255D;
            break;
        case 857:
        case 862:
            ochar = 0x256C; // cross wall, doors - or +
            break;
        case 858:
            ochar = 0x2569; // t-up wall -
            break;
        case 859:
            ochar = 0x2566; // t-down wall -
            break;
        case 860:
            ochar = 0x2563; // t-left wall -
            break;
        case 861:
            ochar = 0x2560; // t-right wall -
            break;
        case 893:
        case 909:
            ochar = 0x2666; // trap, web ^ or "
            break;
        case 873:
        case 874:
            ochar = 0x2261; // Stairs %
            break;
        case 871: // lit corridor #
            ochar = 0x2593;
            break;
        case 872: // dark corridor #
            ochar = 0x2592;
            break;
        case 869: // floor .
        case 870: // dark floor .
            ochar = 0x00B7;
            break;
        default:
            break;
    }
    return ochar;
}

- (UIColor *) mapNetHackColor:(int)ocolor {
	return [colorTable objectAtIndex:ocolor];
}

- (void) dealloc {
	[colorTable release];
	[super dealloc];
}

@end
