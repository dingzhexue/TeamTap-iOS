//
//  TTGameViewController.m
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTGameViewController.h"
#import "TTResultsViewController.h"
#import "TTAPIClient.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+Additions.h"

@interface TTGameViewController()<CLLocationManagerDelegate>  {
    int hours, minutes, seconds;
    int secondsLeft;
}
- (void)getGame;
- (void)postTapPayloadWithTimestamp:(NSString *)timestamp;
@end

@implementation TTGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameBanner.backgroundColor = [[TTAPIClient sharedClient] primaryColour];
    self.matchtimeLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.matchtimeLabel.font.pointSize];
    self.timerLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:self.timerLabel.font.pointSize];
    self.teamLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.teamLabel.font.pointSize];
    self.tapCountLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:self.tapCountLabel.font.pointSize];
    self.raisedvalueLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:self.raisedvalueLabel.font.pointSize];
    self.tapstitleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.tapstitleLabel.font.pointSize];
    self.raisedtitleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.raisedtitleLabel.font.pointSize];
    self.sponsorLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.sponsorLabel.font.pointSize];
    self.charityLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.charityLabel.font.pointSize];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // Whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [[self locationManager] startUpdatingLocation];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([TTAPIClient sharedClient].selectedGameId == self.gameID) {
        [self getGame];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    __block double previousTapTime;
    __block struct Accel { float accelX, accelY, accelZ; } w_self;
    
    
    if ([self.motionManager isAccelerometerAvailable] == YES && self.tapEnabled) {
        [self.motionManager setAccelerometerUpdateInterval:0.01];
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion *accelerometerData, NSError *error) {
                                                    
                                                    CMAcceleration acceleration = accelerometerData.userAcceleration;
                                                    double time = CACurrentMediaTime() - previousTapTime;
                                                    float kFilteringFactor = 0.1;
                                                    
                                                    // Isolate Instantaneous Motion from Acceleration Data
                                                    // (using a simplified high-pass filter)
                                                    float prevAccelX = w_self.accelX;
                                                    float prevAccelY = w_self.accelY;
                                                    float prevAccelZ = w_self.accelZ;
                                                    
                                                    w_self.accelX = acceleration.x - ( (acceleration.x * kFilteringFactor) + (w_self.accelX * (1.0 - kFilteringFactor)) );
                                                    w_self.accelY = acceleration.y - ( (acceleration.y * kFilteringFactor) + (w_self.accelY * (1.0 - kFilteringFactor)) );
                                                    w_self.accelZ = acceleration.z - ( (acceleration.z * kFilteringFactor) + (w_self.accelZ * (1.0 - kFilteringFactor)) );
                                                    
                                                    // Compute the derivative (which represents change in acceleration).
                                                    float deltaX = ABS((w_self.accelX - prevAccelX));
                                                    float deltaY = ABS((w_self.accelY - prevAccelY));
                                                    float deltaZ = ABS((w_self.accelZ - prevAccelZ));
                                                    
                                                    // Check if the vector length exceeds threshold
                                                    
                                                    float vectorLength = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
                                                    
                                                    if ( vectorLength > 2 && time > 0.3 ) {
                                                        previousTapTime = CACurrentMediaTime();
                                                        NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                                                        
                                                        [self postTapPayloadWithTimestamp:timestamp];
                                                        
                                                        //  Increment tapCount
                                                        
                                                        int tapLabel = [self.tapCountLabel.text intValue] + 1;
                                                        self.tapCountLabel.text = [NSString stringWithFormat:@"%d", tapLabel];
                                                        
                                                        NSLog( @"TAP:  %.3f, %@", vectorLength, timestamp);
                                                    }
                                                    
                                                }];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [[self timer] invalidate];
    self.timer = nil;
    [[self pollTimer] invalidate];
    self.pollTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TTResultsViewController *controller = [segue destinationViewController];
    controller.gameID = self.gameID;
    self.tapEnabled = NO;
    self.motionManager = nil;
}

#pragma mark - Countdown Timer

- (void)updateCounter:(NSTimer *)theTimer
{
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
}

-(void)countdownTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

-(void)APITimer
{
    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(checkGameAndUpdate) userInfo:nil repeats:YES];
}


#pragma mark - API

- (void)getGame
{
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
        
        NSLog(@"== Using OAuth credentials to retrieve game data");
        
        // Query with the game id
        NSDictionary *params = @{ @"game_id" : [NSNumber numberWithInt:self.gameID] };
        
        [[TTAPIClient sharedClient] GET:@"/api/v1/games/check.json"
                             parameters:params
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    [SVProgressHUD dismiss];
                                    
                                    NSString *teamImageKey;
                                    NSString *teamNameKey;
                                    
                                    if ([self.currentTeam isEqualToString:@"a"]) {
                                        teamImageKey = @"teamaImgURL";
                                        teamNameKey = @"teamaName";
                                    } else {
                                        teamImageKey = @"teambImgURL";
                                        teamNameKey = @"teambName";
                                    }
                                    
                                    self.teamLabel.text = [[NSString stringWithString:responseObject[teamNameKey]] uppercaseString];
                                    
                                    NSURL *teamImageURL = [NSURL URLWithString:[responseObject objectForKeyNotNull:teamImageKey]];
                                    
                                    if (teamImageURL) {
                                        [self.teamImage setImageWithURL:teamImageURL];
                                    }
                                    
                                    NSURL *sponsorImageURL = [NSURL URLWithString:[responseObject objectForKeyNotNull:@"sponsorImgURL"]];
                                    
                                    if (sponsorImageURL) {
                                        [self.sponsorImage setImageWithURL:sponsorImageURL];
                                    }
                                    
                                    NSURL *charityImageURL = [NSURL URLWithString:[responseObject objectForKeyNotNull:@"charityImgURL"]];
                                    
                                    if (charityImageURL) {
                                        [self.charityImage setImageWithURL:charityImageURL];
                                    }
                                    
                                    
                                    NSURL *gamebgImageURL = [NSURL URLWithString:[responseObject objectForKeyNotNull:@"gamebgImgURL"]];
                                    
                                    if (gamebgImageURL) {
                                        [self.gamebgImage setImageWithURL:gamebgImageURL];
                                    }
                                    
                                    if ([[responseObject objectForKeyNotNull:@"finished"] boolValue] == NO ) {
                                        secondsLeft = hours = minutes = seconds = [responseObject[@"finishesIn"] intValue];
                                        [self countdownTimer];
                                    }
                                    
                                    self.gameTapValue = responseObject[@"tapValue"];
                                    
                                    [self APITimer];

                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                                }];
    }
}

- (void)postTapPayloadWithTimestamp:(NSString *)timestamp
{
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
    
        NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
        NSDictionary *payload = @{@"[tap]udid": udid,
                             @"[tap]timestamp": timestamp,
                               @"[tap]game_id": [NSNumber numberWithInt:self.gameID],
                               @"[tap]team_id": [NSNumber numberWithInt:self.selectedTeamID],
                                   @"[tap]lat": [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude],
                                  @"[tap]long": [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude]
                                };
    
        [[TTAPIClient sharedClient] POST:@"/api/v1/taps/create.json"
                             parameters:payload
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    NSLog(@"== Sent Tap");
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                              }];
    
        AudioServicesPlaySystemSound(1105);
        NSLog(@"%@", payload);
    }
    
}

- (void)checkGameAndUpdate
{
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
        
        NSLog(@"== Checking for game finish");
        
        // Query with the game id
        NSDictionary *params = @{ @"game_id" : [NSNumber numberWithInt:self.gameID] };
        
        [[TTAPIClient sharedClient] GET:@"/api/v1/games/check.json"
                             parameters:params
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    if ([[responseObject objectForKeyNotNull:@"finished"] boolValue] == YES){
                                        [self performSegueWithIdentifier:@"gameResults" sender:self];
                                    }
                                    
                                    if ([[responseObject objectForKeyNotNull:@"maxReached"] boolValue] == YES){
                                        UIAlertView *maxtapsView = [[UIAlertView alloc]
                                                                        initWithTitle: @"Find another team mate"
                                                                        message: @"You have reached the max taps for this team mate, find another team mate to tap with."
                                                                        delegate: self
                                                                        cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                                        
                                        [maxtapsView show];
                                    }
                                    
                                    // Update tap count from server
                                    self.tapCountLabel.text = [NSString stringWithFormat:@"%@", responseObject[@"matchedTaps"]];
                                    self.raisedvalueLabel.text = responseObject[@"dollarsRaised"];
                                    
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                                }];
    }
}


@end
