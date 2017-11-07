//
//  TTEventTableViewController.h
//  TeamTap
//
//  Created by Jason Cox on 16/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTEventTableViewController : UITableViewController

@property (nonatomic, strong) NSIndexPath *selectedCellIndexPath;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, assign) CGFloat selectedCellHeight;
@property (strong, nonatomic) NSMutableArray *expandedCells;

@end
