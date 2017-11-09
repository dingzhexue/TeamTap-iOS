//
//  TTTeamViewController.m
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTTeamViewController.h"
#import "TTGameViewController.h"
#import "TTAPIClient.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "NSDictionary+Additions.h"

@interface TTTeamViewController()

- (void)getGame;
- (void)checkGameStart;
- (UIImage *)convertImageToGrayScale:(UIImage *)image;
@end

@implementation TTTeamViewController

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
    
       self.selectteamLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.selectteamLabel.font.pointSize];
         self.donationLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.donationLabel.font.pointSize];
    self.donationvalueLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:self.donationvalueLabel.font.pointSize];
          self.sponsorLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.sponsorLabel.font.pointSize];
          self.charityLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.charityLabel.font.pointSize];
         self.startsinLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.startsinLabel.font.pointSize];
            self.teamaLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.teamaLabel.font.pointSize];
            self.teambLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.teambLabel.font.pointSize];
    self.timerLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:self.timerLabel.font.pointSize];
    self.donationBanner.backgroundColor = [[TTAPIClient sharedClient] primaryColour];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        bool _didLoadImages = NO;
        
        while (!_didLoadImages) {
            if (self.teamaButton.currentImage != nil && self.teambButton.currentImage != nil) {
                self.originalTeamaImage = self.teamaButton.currentImage;
                self.originalTeambImage = self.teambButton.currentImage;
                _didLoadImages = YES;
            }
        }
    });
    
    UIAlertView *instructionView = [[UIAlertView alloc]
                              initWithTitle: @"How to play"
                              message: @"Select your team and wait for the game to start, once the game has started find team mates and tap to support your charity."
                              delegate: self
                              cancelButtonTitle: @"Got it" otherButtonTitles: nil];
    
    [instructionView show];

}

static void extracted(TTTeamViewController *object) {
    [object getGame];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([TTAPIClient sharedClient].selectedGameId == self.gameID) {
        extracted(self);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Countdown Timer

int hours, minutes, seconds;
int secondsLeft;

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
    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(checkGameStart) userInfo:nil repeats:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TTGameViewController *controller = [segue destinationViewController];
    controller.gameID = [TTAPIClient sharedClient].selectedGameId;
    controller.selectedTeamID = self.selectedTeamID;
    controller.currentTeam = self.selectedTeam;
    controller.tapEnabled = YES;
}

- (IBAction)sponsorButton:(id)sender {
//    // Present sponsor modal
//    UIStoryboard *storyBoard = [self storyboard];
//    UINavigationController *loginModal  = [storyBoard instantiateViewControllerWithIdentifier:@"sponsorModal"];
//    
//    [self presentViewController:loginModal animated:YES completion:nil];
}

- (IBAction)charityButton:(id)sender {
//    // Present charity modal
//    UIStoryboard *storyBoard = [self storyboard];
//    UINavigationController *loginModal  = [storyBoard instantiateViewControllerWithIdentifier:@"charityModal"];
//    
//    [self presentViewController:loginModal animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)teamaButton:(id)sender {
    if ([self.selectedTeam compare:@"a"]) {
        [self.teamaButton setImage:self.originalTeamaImage forState:UIControlStateNormal];
    }
    
//    UIImage *newImage = [self convertImageToGrayScale:self.originalTeambImage];
    UIImage *newImage = [UIImage imageNamed:@"grey8.png"];
    [self.teambButton setImage:newImage forState:UIControlStateNormal];
    
    self.selectedTeam = @"a";
    self.selectedTeamID = [self.game[@"teamaID"] intValue];
}

- (IBAction)teambButton:(id)sender {
    if ([self.selectedTeam compare:@"b"]) {
        [self.teambButton setImage:self.originalTeambImage forState:UIControlStateNormal];
    }
    
//    UIImage *newImage = [self convertImageToGrayScale:self.originalTeamaImage];
    UIImage *newImage = [UIImage imageNamed:@"grey7.png"];
    [self.teamaButton setImage:newImage forState:UIControlStateNormal];
    
    self.selectedTeam = @"b";
    self.selectedTeamID = [self.game[@"teambID"] intValue];
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    CGFloat actualWidth = image.size.width;
    CGFloat actualHeight = image.size.height;
    CGSize imageSize = CGSizeMake(actualWidth, actualHeight);
    CGRect imageRect = CGRectMake(0, 0, actualWidth, actualHeight);
    UIColor *fillColor = [UIColor darkGrayColor];

    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGContextFillRect(context, imageRect);
    CGImageRef blackImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, nil, kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef mask = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    UIImage *outlineImage = [UIImage imageWithCGImage:CGImageCreateWithMask(blackImage, mask) scale:1 orientation:image.imageOrientation];
    CGImageRelease(blackImage);
    CGImageRelease(mask);
    
    // Return the new grayscale image
    return outlineImage;
}

#pragma mark - API

- (void)getGame
{
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
        
        NSLog(@"== Using OAuth credentials to retrieve game data");
        
        // Query with the game id
        NSDictionary *params = @{ @"game_id" : [NSNumber numberWithInt:[TTAPIClient sharedClient].selectedGameId] };
        
        [[TTAPIClient sharedClient] GET:@"/api/v1/games/show.json"
                             parameters:params
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    [SVProgressHUD dismiss];
                                    self.game = responseObject;
                                    
                                    self.donationvalueLabel.text = self.game[@"goal"];
                                    self.teamaLabel.text = [[NSString stringWithString:self.game[@"teamaName"]] uppercaseString];
                                    self.teambLabel.text =  [[NSString stringWithString:self.game[@"teambName"]]uppercaseString];
                                    
                                    NSURL *teamaImageURL = [NSURL URLWithString:[self.game objectForKeyNotNull:@"teamaImgURL"]];
                                    
                                    if (teamaImageURL) {
                                        [self.teamaButton setImageForState:UIControlStateNormal withURL:teamaImageURL];
                                    }
                                    
                                    NSURL *teambImageURL = [NSURL URLWithString:[self.game objectForKeyNotNull:@"teambImgURL"]];
                                    
                                    if (teambImageURL) {
                                        [self.teambButton setImageForState:UIControlStateNormal withURL:teambImageURL];
                                        
                                    }
                                    
                                    NSURL *sponsorImageURL = [NSURL URLWithString:[self.game objectForKeyNotNull:@"sponsorImgURL"]];
                                    
                                    if (sponsorImageURL) {
                                        [self.sponsorImage setImageWithURL:sponsorImageURL];
                                    }
                                    
                                    NSURL *charityImageURL = [NSURL URLWithString:[self.game objectForKeyNotNull:@"charityImgURL"]];
                                    
                                    if (charityImageURL) {
                                        [self.charityImage setImageWithURL:charityImageURL];
                                    }
                                    
                                    NSURL *gamebgImageURL = [NSURL URLWithString:[self.game objectForKeyNotNull:@"gamebgImgURL"]];
                                    
                                    if (gamebgImageURL) {
                                        [self.gamebgImage setImageWithURL:gamebgImageURL];
                                    }
                                    
                                    
                                    if ([[responseObject objectForKeyNotNull:@"started"] boolValue] == NO ) {
                                        secondsLeft = hours = minutes = seconds = [responseObject[@"startsIn"] intValue];
                                        [self countdownTimer];
                                    } else {
                                        self.startsinLabel.text = @"GAME STARTED";
                                    }
                                    
                                    [self APITimer];
                                    
                                    NSLog(@"== GET Events Success");
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                                }];
    }
}

- (void)checkGameStart
{
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
        
        NSLog(@"== Checking for game start");
        
        // Query with the game id
        NSDictionary *params = @{ @"game_id" : [NSNumber numberWithInt:[TTAPIClient sharedClient].selectedGameId] };
        
        [[TTAPIClient sharedClient] GET:@"/api/v1/games/show.json"
                             parameters:params
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    // Correct countdown drift
                                    if (secondsLeft - [responseObject[@"startsIn"] intValue] > 5){
                                        secondsLeft = hours = minutes = seconds = [responseObject[@"startsIn"] intValue];
                                    }
                                    
                                    if ([[responseObject objectForKeyNotNull:@"started"] boolValue] == YES && self.selectedTeamID){
                                        [self performSegueWithIdentifier:@"startGame" sender:self];
                                    } else if ([[responseObject objectForKeyNotNull:@"started"] boolValue] == YES) {
                                        self.startsinLabel.text = @"GAME STARTED";
                                    }
                                    
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                                }];
    }
}


@end
