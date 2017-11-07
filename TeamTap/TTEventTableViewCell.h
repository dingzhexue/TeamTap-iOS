//
//  TTEventTableViewCell.h
//  TeamTap
//
//  Created by Jason Cox on 19/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTEventTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIImageView *eventImage;
@property (nonatomic, weak) NSNumber *eventID;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *charityLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventBanner;
@property (weak, nonatomic) IBOutlet UILabel *matchTapsTitle;

@end