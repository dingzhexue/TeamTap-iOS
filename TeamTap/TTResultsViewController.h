//
//  TTResultsViewController.h
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTResultsViewController : UIViewController

@property (nonatomic, assign) NSInteger gameID;
@property (weak, nonatomic) IBOutlet UILabel *tapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *raisedvalueLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultPanel;
@property (weak, nonatomic) IBOutlet UILabel *resultBanner;
@property (weak, nonatomic) IBOutlet UIImageView *winningteamImage;
@property (weak, nonatomic) IBOutlet UILabel *resulttitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsortitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *charitytitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *winningtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorImage;
@property (weak, nonatomic) IBOutlet UIImageView *charityImage;
@property (nonatomic, strong) NSString *shareMessage;



@end
