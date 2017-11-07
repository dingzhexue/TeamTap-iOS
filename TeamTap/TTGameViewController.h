//
//  TTGameViewController.h
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface TTGameViewController : UIViewController

@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, assign) NSTimer *pollTimer;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;


@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *currentTeam;
@property (nonatomic, strong) NSString *currentGame;
@property (nonatomic, assign) NSInteger gameID;
@property (nonatomic, assign) NSInteger selectedTeamID;
@property (nonatomic, assign) bool tapEnabled;
@property (nonatomic, assign) NSNumber *gameTapValue;

@property (nonatomic, weak) IBOutlet UILabel *tapCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *raisedvalueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameBanner;
@property (weak, nonatomic) IBOutlet UILabel *tapstitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *raisedtitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamImage;
@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;
@property (weak, nonatomic) IBOutlet UILabel *charityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorImage;
@property (weak, nonatomic) IBOutlet UIImageView *charityImage;
@property (weak, nonatomic) IBOutlet UILabel *matchtimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gamebgImage;



@end
