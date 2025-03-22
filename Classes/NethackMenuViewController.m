//
//  NethackMenuViewController.m
//  iNetHack
//
//  Created by dirk on 6/30/09.
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

#import "NethackMenuViewController.h"
#import "Window.h"
#import "NethackMenuItem.h"
#import "MainViewController.h"
#import "TileSet.h"
#import "NSString+Regexp.h"
#import "NSString+NetHack.h"
#import "ItemAmountViewController.h"

extern short glyph2tile[];

@implementation NethackMenuViewController

@synthesize menuWindow;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void) selectAllItems:(NSArray *)items select:(BOOL)s {
	for (NethackMenuItem *i in items) {
		if (i.isTitle) {
			[self selectAllItems:i.children select:s];
		} else {
			i.selected = s;
		}
	}
}

- (void) selectAll:(id)sender {
	UIBarButtonItem *bi = sender;
	if (selectAll) {
		bi.title = @"None";
	} else {
		bi.title = @"All";
	}
	[self selectAllItems:menuWindow.menuItems select:selectAll];
	selectAll = !selectAll;
	[self.tableView reloadData];
}

- (void) setMenuWindow:(Window *)w {
	menuWindow = w;
	menuWindow.menuResult = kMenuCancelled;
	self.title = (w.menuPrompt && w.menuPrompt.length > 0) ? menuWindow.menuPrompt : @"Menu";

	// extend menu items
	if (menuWindow.acceptBareHanded || menuWindow.acceptMoney || menuWindow.acceptMore) {
		anything any;
		any.a_int = 0;
		NethackMenuItem *miParent = [[NethackMenuItem alloc] initWithId:&any title:"Meta" glyph:kNoGlyph preselected:NO];
		[menuWindow addMenuItem:miParent];
		[miParent release];
		if (menuWindow.acceptBareHanded) {
			any.a_int = '-';
			NethackMenuItem *mi = [[NethackMenuItem alloc] initWithId:&any title:"Hands (-)"
																glyph:kNoGlyph isMeta:YES preselected:NO];
			[menuWindow addMenuItem:mi];
			[mi release];
		}
		if (menuWindow.acceptMore) {
			any.a_int = '*';
			NethackMenuItem *mi = [[NethackMenuItem alloc] initWithId:&any title:"More (*)"
																glyph:kNoGlyph isMeta:YES preselected:NO];
			[menuWindow addMenuItem:mi];
			[mi release];
		}
		if (menuWindow.acceptMoney) {
			any.a_int = '$';
            NSString *title = [NSString stringWithFormat:@"%d %s ($)", (int) money_cnt(invent), currency(u.umoney0)];

			NethackMenuItem *mi = [[NethackMenuItem alloc] initWithId:&any title:[title cStringUsingEncoding:NSASCIIStringEncoding]
																glyph:kNoGlyph isMeta:YES preselected:NO];
			mi.gold = YES;
			[menuWindow addMenuItem:mi];
			[mi release];
		}
	}

	selectAll = YES;
	if (w.menuHow == PICK_ANY) {
		UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain
															  target:self action:@selector(selectAll:)];
		self.navigationItem.rightBarButtonItem = bi;
		[bi release];
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
	[self.tableView reloadData];
}

- (void) collectSelectedItems:(NSArray *)menuItems into:(NSMutableArray *)items {
	for (NethackMenuItem *i in menuItems) {
		if (i.isTitle) {
			[self collectSelectedItems:i.children into:items];
		} else {
			if (i.isSelected) {
				[items addObject:i];
			}
		}
	}
}

//iNethack2: screenSize that works with both iOS7 + 8
+ (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    //Check for insets in case we need to adjust safe screen size
    BOOL hasInsets = NO;
    if (@available(iOS 11.0, *)) {
        if ([[[[UIApplication sharedApplication] delegate] window] safeAreaInsets].top > 0.0) {
            hasInsets = YES;
        }
        if (hasInsets) {
            UIEdgeInsets safeRect = [[[[UIApplication sharedApplication] delegate] window] safeAreaInsets];
            screenSize.height-=safeRect.top;
            screenSize.height-=safeRect.bottom;
            screenSize.width-=safeRect.left;
            screenSize.width-=safeRect.right;
        }
    }
    
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    colorInvert = [[NSUserDefaults standardUserDefaults] floatForKey:@"colorInvert"];
	tv = (UITableView *) self.view;
    tv.backgroundColor = colorInvert?[UIColor whiteColor]:[UIColor blackColor];
    tv.allowsSelection=TRUE; //iNethack2: to help fix bugginess with amount selection transition
    tv.separatorStyle = UITableViewCellSeparatorStyleNone; //iNethack2: prevent line separator
    self.navigationController.navigationBar.backgroundColor = colorInvert?[UIColor whiteColor]:[UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : colorInvert?[UIColor blackColor]:[UIColor whiteColor]};
}

//--iNethack2 added to set the background color of headers in inventory
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Background color
    view.tintColor = [UIColor lightGrayColor];
    view.tintColor = [UIColor darkGrayColor];
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setShadowColor:[UIColor blackColor]];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if (self.navigationController.topViewController != itemAmountViewController) {
		if (menuWindow.menuHow == PICK_ANY) {
			NSMutableArray *items = [NSMutableArray array];
			[self collectSelectedItems:menuWindow.menuItems into:items];
			menuWindow.menuResult = (int) items.count;
			menuWindow.menuList = malloc(sizeof(menu_item) * items.count);
			for (int i = 0; i < items.count; ++i) {
				NethackMenuItem *item = [items objectAtIndex:i];
				menuWindow.menuList[i].count = item.amount;
				menuWindow.menuList[i].item = item.identifier;
			}
		}
		[[MainViewController instance] broadcastUIEvent];
	}
}



#pragma mark UITableView delegate

- (NethackMenuItem *) nethackMenuItemAtIndexPath:(NSIndexPath *)indexPath {
	int row = (int) [indexPath row];
	int section = (int) [indexPath section];
	NethackMenuItem *i = nil;
	if (menuWindow.isShallowMenu) {
		if (section != 0) {
			NSLog(@"error in %s: section number in shallow menu!", __FUNCTION__);
		}
		i = [menuWindow.menuItems objectAtIndex:row];
	} else {
		i = [menuWindow.menuItems objectAtIndex:section];
		i = [i.children objectAtIndex:row];
	}
	return i;
}

- (void) finishPickOne:(NethackMenuItem *)i {
	menuWindow.menuResult = 1;
	menuWindow.menuList = malloc(sizeof(menu_item));
	menuWindow.menuList->count = i.amount;
	menuWindow.menuList->item = i.identifier;
    menuWindow.nethackMenuItem.amount = i.amount;
	[self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NethackMenuItem *i = [self nethackMenuItemAtIndexPath:indexPath];
	if (menuWindow.menuHow == PICK_ANY) {
		i.selected = !i.isSelected;
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = i.isSelected ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
	} else {
		[self finishPickOne:i];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView reloadData]; // cancel delete
	if (menuWindow.menuHow == PICK_ONE && ([self.title containsString:@"throw"] || [self.title containsString:@"drop"])) {
		NethackMenuItem *i = [self nethackMenuItemAtIndexPath:indexPath];
		if (!i.isMeta || i.isGold) {
			menuWindow.nethackMenuItem = i;
			int a = [i.title parseNetHackAmount];
			if (a > 1) {
				itemAmountViewController.menuWindow = menuWindow;
				[self.navigationController pushViewController:itemAmountViewController animated:YES];
			}
		}
	}
}

#pragma mark UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (menuWindow.isShallowMenu) {
		return 1;
	} else {
		return menuWindow.menuItems.count;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (menuWindow.isShallowMenu) {
		if (section != 0) {
			NSLog(@"error in %s: section number in shallow menu!", __FUNCTION__);
		}
		return menuWindow.menuItems.count;
	} else {
		NethackMenuItem *i = [menuWindow.menuItems objectAtIndex:section];
		return i.children.count;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NethackMenuItem *i = [menuWindow.menuItems objectAtIndex:section];
	return i.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellId = @"nethackMenuViewControllerCellId";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId] autorelease];
		cell.textLabel.textColor = colorInvert?[UIColor blackColor]:[UIColor whiteColor];
	}
    cell.backgroundColor = [UIColor clearColor];

	NethackMenuItem *i = [self nethackMenuItemAtIndexPath:indexPath];

	if (i.glyph != NO_GLYPH && i.glyph != kNoGlyph) {
		UIImage *uiImg = [UIImage imageWithCGImage:[[TileSet instance] imageForGlyph:i.glyph]];
		cell.imageView.image = uiImg;

        // For large tiles (like IBMGraphics), shrink it down since we are using larger tiles for better clarity.
        if (uiImg.size.width > 32 || uiImg.size.height > 32)
        {
            CGSize itemSize = CGSizeMake(uiImg.size.width / 2, uiImg.size.height / 2);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
	} else {
		cell.imageView.image = nil;
	}
	
	NSArray *strings = [i.title splitNetHackDetails];
	cell.textLabel.text = [strings objectAtIndex:0];

    BOOL showMenuLetters = [[NSUserDefaults standardUserDefaults] floatForKey:@"showmenuletters"];

    char invletter = i.identifier.a_char;
    if (i.accelerator > 0) {
        invletter = i.accelerator;
    }
    if (showMenuLetters && menuWindow != [[MainViewController instance] windowWithId:WIN_INVEN]) {
        // If its not an inventory screen, we need to check for accelerator values instead, or else just don't show letters.
        if (i.accelerator <= 0) {
            showMenuLetters = false;
        }
    }
    if (showMenuLetters) {
        cell.textLabel.text = [NSString stringWithFormat:@"%c - %@", invletter, [strings objectAtIndex:0]];
    }
	if (strings.count == 2) {
		cell.detailTextLabel.text = [strings objectAtIndex:1];
        cell.detailTextLabel.textColor = [UIColor grayColor];
	} else {
		cell.detailTextLabel.text = nil;
	}
	
	cell.accessoryType = i.isSelected ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    cell.editing = YES;
    cell.textLabel.numberOfLines=0; //iNethack2: word wrap instead of ellipses
    cell.detailTextLabel.numberOfLines=0; //iNethack2: word wrap instead of ellipses
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	// I guess we never land here
	NSLog(@"commitEditingStyle");
}

//iNethack2: fixes swipe-to-left issue for cells and handles itemAmount
//overrides the other code that does itemAmount
//TODO: make THROW non-weapons work with itemAmount (title becomes "Menu" so this code doesn't know the context..need to fix)
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tv.allowsSelection=FALSE; //iNethack2: to help fix bugginess with amount selection transition
    //iNethack2: support for selecting amount to put/take to/from a container.
    if ((menuWindow.menuHow == PICK_ONE && ([self.title containsString:@"throw"] || [self.title containsString:@"drop"]))
        ||
        (menuWindow.menuHow == PICK_ANY && ([self.title containsString:@"Put"] || [self.title containsString:@"Take"]))) {
        NethackMenuItem *i = [self nethackMenuItemAtIndexPath:indexPath];
        if (!i.isMeta || i.isGold) {
            menuWindow.nethackMenuItem = i;
            int a = [i.title parseNetHackAmount];
            if (a > 1) {
                itemAmountViewController.menuWindow = menuWindow;
                [self.navigationController pushViewController:itemAmountViewController animated:YES];
            } else
                tv.allowsSelection=TRUE; //iNethack2: to help fix bugginess with amount selection transition
        }
    } else  {
        tv.allowsSelection=TRUE; //iNethack2: to help fix bugginess with amount selection transition
    }
    return UITableViewCellEditingStyleNone;
}
@end
