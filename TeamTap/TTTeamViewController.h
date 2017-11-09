//
//  TTTeamViewController.h
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTeamViewController : UIViewController{
 
}

@property (nonatomic, strong) NSDictionary *game;

@property (nonatomic, assign) NSInteger gameID;
@property (nonatomic, assign) NSInteger selectedTeamID;
@property (nonatomic, assign) NSString *selectedTeam;

@property (weak, nonatomic) IBOutlet UILabel *startsinLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, assign) NSTimer *pollTimer;
@property (weak, nonatomic) IBOutlet UIButton *teamaButton;
@property (weak, nonatomic) IBOutlet UIButton *teambButton;
@property (nonatomic, retain) UIImage *originalTeamaImage;
@property (nonatomic, retain) UIImage *originalTeambImage;


@property (weak, nonatomic) IBOutlet UILabel *selectteamLabel;
@property (weak, nonatomic) IBOutlet UILabel *donationLabel;
@property (weak, nonatomic) IBOutlet UILabel *donationvalueLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;
@property (weak, nonatomic) IBOutlet UILabel *charityLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamaLabel;
@property (weak, nonatomic) IBOutlet UILabel *teambLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorImage;
@property (weak, nonatomic) IBOutlet UIImageView *charityImage;
@property (weak, nonatomic) IBOutlet UILabel *donationBanner;
@property (weak, nonatomic) IBOutlet UIImageView *gamebgImage;



@end
