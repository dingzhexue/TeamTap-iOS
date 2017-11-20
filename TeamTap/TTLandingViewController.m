//
//  TTLandingViewController.m
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTLandingViewController.h"
#import "TTAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+Additions.h"
#import <SafariServices/SafariServices.h>


@interface TTLandingViewController()

@end

@implementation TTLandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    self.signupButton.titleLabel.font   = [UIFont fontWithName:@"OpenSans-Semibold" size:self.signupButton.titleLabel.font.pointSize];
    self.loginButton.titleLabel.font    = [UIFont fontWithName:@"OpenSans-Semibold" size:self.loginButton.titleLabel.font.pointSize];
    self.signupButton.layer.borderWidth = 1.5f;
    self.signupButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.loginButton.layer.borderWidth = 1.5f;
    self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)loadUI
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        bool _didLoadImage = NO;

        while (!_didLoadImage) {
            if ([[TTAPIClient sharedClient] logoURL]) {
                [self.logoImage setImageWithURL:[[TTAPIClient sharedClient] logoURL]];
                _didLoadImage = YES;
            }
        }
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)privacyPolicy:(id)sender {
    
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.teamtap.com.au/privacy.html"]];
    [self presentViewController:safariVC animated:true completion:nil];
}

- (IBAction)howToPlay:(id)sender {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.teamtap.com.au/the-game.html"]];
    [self presentViewController:safariVC animated:true completion:nil];
}

@end
