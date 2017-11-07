//
//  TTResultsViewController.m
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTResultsViewController.h"
#import "TTAPIClient.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "NSDictionary+Additions.h"

@interface TTResultsViewController()
    // Private
@end

@implementation TTResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultPanel.backgroundColor = [[TTAPIClient sharedClient] primaryColour];
    self.resultBanner.backgroundColor = [[TTAPIClient sharedClient] primaryColour];
    self.winningtitleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.winningtitleLabel.font.pointSize];
    self.resulttitleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.resulttitleLabel.font.pointSize];
    self.sponsortitleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.sponsortitleLabel.font.pointSize];
    self.charitytitleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.charitytitleLabel.font.pointSize];
    self.tapsLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:self.tapsLabel.font.pointSize];
    self.raisedvalueLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:self.raisedvalueLabel.font.pointSize];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([TTAPIClient sharedClient].selectedGameId == self.gameID) {
        [self getResults];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)shareButton:(id)sender {
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.shareMessage]
                                                                             applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    
    [self presentViewController:controller animated:YES completion:nil];

}

#pragma mark - API

- (void)getResults
{
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        NSLog(@"== Retreiving game results");
        
        // Query with the game id
        NSDictionary *params = @{ @"game_id" : [NSNumber numberWithInt:[TTAPIClient sharedClient].selectedGameId] };
        
        [[TTAPIClient sharedClient] GET:@"/api/v1/games/results.json"
                             parameters:params
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    [SVProgressHUD dismiss];
                                    self.tapsLabel.text = [NSString stringWithFormat:@"%@", responseObject[@"totalTaps"]];
                                    self.raisedvalueLabel.text = responseObject[@"dollarsRaised"];
                                    self.shareMessage = responseObject[@"shareMessage"];
                                    
                                    NSURL *sponsorImageURL = [NSURL URLWithString:[responseObject objectForKeyNotNull:@"sponsorImgURL"]];
                                    
                                    if (sponsorImageURL) {
                                        [self.sponsorImage setImageWithURL:sponsorImageURL];
                                    }
                                    
                                    NSURL *charityImageURL = [NSURL URLWithString:[responseObject objectForKeyNotNull:@"charityImgURL"]];
                                    
                                    if (charityImageURL) {
                                        [self.charityImage setImageWithURL:charityImageURL];
                                    }
                                    
                                    NSURL *winningteamImageURL = [NSURL URLWithString:[responseObject objectForKeyNotNull:@"winningTeamImgURL"]];
                                    
                                    if (winningteamImageURL) {
                                        [self.winningteamImage setImageWithURL:winningteamImageURL];
                                    }
                                    
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                                }];
    }
}


@end
