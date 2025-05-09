//
//  ItemAmountViewController.m
//  iNetHack
//
//  Created by dirk on 8/22/09.
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

#import "ItemAmountViewController.h"
#import "NethackMenuItem.h"
#import "MainViewController.h"
#import "Window.h"
#import "TileSet.h"
#import "NSString+NetHack.h"

extern short glyph2tile[];

@implementation ItemAmountViewController

@synthesize menuWindow;

- (void) awakeFromNib {
	[super awakeFromNib];
	self.title = @"Set Amount";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) sliderValueHasChanged:(id)sender {
	UISlider *slider = (UISlider *) sender;
	int v = round(slider.value);
	amountTextLabel.text = [NSString stringWithFormat:@"%d", v];
    
    int textv = [amountTextField.text intValue];
    if (textv!=v)
        amountTextField.text = [NSString stringWithFormat:@"%d", v];
	menuWindow.nethackMenuItem.amount = v;
}

//iNethack2: amount text box value changed
- (void) textValueHasChanged:(id)sender {
    UITextField *textfield = (UITextField *) sender;
    //UISlider *slider = (UISlider *) sender;
    //int v = round(slider.value);

    int v = [textfield.text intValue];
    int maxminv = min(v, amountSlider.maximumValue);
    maxminv = max(maxminv, amountSlider.minimumValue);
    if (amountSlider.value != maxminv)
        amountSlider.value = maxminv;
    amountTextLabel.text = [NSString stringWithFormat:@"%d", maxminv];
    menuWindow.nethackMenuItem.amount = maxminv;
    
}

- (void) finishPickOne:(id)sender {
	NethackMenuItem *i = menuWindow.nethackMenuItem;
	menuWindow.menuResult = 1;
	menuWindow.menuList = malloc(sizeof(menu_item));
	menuWindow.menuList->count = i.amount;
	menuWindow.menuList->item = i.identifier;
	[self.navigationController popToRootViewControllerAnimated:NO];
	[[MainViewController instance] broadcastUIEvent];
}


- (void)viewWillAppear:(BOOL)animated {
	amountSlider.continuous = YES;

	if (!targetsSet) {
		// things like this should be in awakeFromNib
		// but when called the outlets don't seem to be initialized
		// so we have to do that here
		[amountSlider addTarget:self action:@selector(sliderValueHasChanged:) forControlEvents:UIControlEventValueChanged];
		[dropButton addTarget:self action:@selector(finishPickOne:) forControlEvents:UIControlEventTouchUpInside];
        
        //iNethack2: amount text box setup
        [amountTextField addTarget:self action:@selector(textValueHasChanged:) forControlEvents:
         UIControlEventEditingChanged];
        
		targetsSet = YES;
	}
	if (menuWindow.nethackMenuItem.glyph != NO_GLYPH && menuWindow.nethackMenuItem.glyph != kNoGlyph) {
		UIImage *uiImg = [UIImage imageWithCGImage:[[TileSet instance] imageForGlyph:menuWindow.nethackMenuItem.glyph]];
		imageView.image = uiImg;
        // For large tiles (like IBMGraphics), shrink it down since we are using larger tiles for better clarity.
        if (uiImg.size.width > 32 || uiImg.size.height > 32)
        {
            CGSize itemSize = CGSizeMake(uiImg.size.width / 2, uiImg.size.height / 2);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [imageView.image drawInRect:imageRect];
            imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
	} else {
		imageView.image = nil;
	}
	NSArray *descriptions = [menuWindow.nethackMenuItem.title splitNetHackDetails];
	itemTextLabel.text = [descriptions objectAtIndex:0];
	if (descriptions.count >= 2) {
		itemDetailTextLabel.text = [descriptions objectAtIndex:1];
	} else {
		itemDetailTextLabel.text = nil;
	}
	int amount = [menuWindow.nethackMenuItem.title parseNetHackAmount];
	amountTextLabel.text = [NSString stringWithFormat:@"%d", amount];
	amountSlider.minimumValue = 0;
	amountSlider.maximumValue = amount;
	amountSlider.value = amount;
    

    [amountTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    amountTextField.text = [NSString stringWithFormat:@"%d",amount];
}

- (void)dealloc {
    [super dealloc];
}


@end
