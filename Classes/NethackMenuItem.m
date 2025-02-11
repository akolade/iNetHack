//
//  NethackMenuItem.m
//  iNetHack
//
//  Created by dirk on 6/29/09.
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

#import "NethackMenuItem.h"

@implementation NethackMenuItem

@synthesize identifier, title, isTitle, children, selected = isSelected, glyph, meta = isMeta, amount, gold = isGold, accelerator;

- (id) initWithId:(const anything *)i title:(const char *)t glyph:(int)g isMeta:(BOOL)m preselected:(BOOL)p accelerator:(int) a {
	if (self = [super init]) {
		identifier = *i;
		if (!i->a_int) {
			isTitle = YES;
			children = [[NSMutableArray alloc] init];
		}
        title =	[[NSString alloc] initWithCString:t encoding:NSASCIIStringEncoding];
		isSelected = p;
		glyph = g;
        accelerator = a;
		self.meta = m;
		amount = -1;
	}
	return self;
}

- (id) initWithId:(const anything *)i title:(const char *)t glyph:(int)g preselected:(BOOL)p {
    return [self initWithId:i title:t glyph:g isMeta:NO preselected:p accelerator:0];
}

- (id) initWithId:(const anything *)i title:(const char *)t glyph:(int)g isMeta:(BOOL)m preselected:(BOOL)p {
    return [self initWithId:i title:t glyph:g isMeta:m preselected:p accelerator:0];
}

- (id) initWithId:(const anything *)i title:(const char *)t glyph:(int)g preselected:(BOOL)p accelerator:(int) a {
    return [self initWithId:i title:t glyph:g isMeta:NO preselected:p accelerator:a];
}

- (void) dealloc {
	[title release];
	[children release];
	[super dealloc];
}

@end
