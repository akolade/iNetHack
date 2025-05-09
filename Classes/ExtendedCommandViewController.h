//
//  ExtendedCommandViewController.h
//  iNetHack
//
//  Created by dirk on 7/6/09.
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


@interface ExtendedCommandViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) int result;
@property (nonatomic, readonly, retain) NSMutableArray *filteredExtCmd; /* visible list of extended commands */
@property (nonatomic, readonly, retain) NSMutableArray *filteredExtCmdIndex; /* index of visible to full list of extended commands */
@property (nonatomic, readonly) BOOL colorInvert; // Textmode: White background, black becomes white.


@end
