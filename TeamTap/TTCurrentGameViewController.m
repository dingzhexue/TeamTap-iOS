//
//  TTCurrentGameViewController.m
//  TeamTap
//
//  Created by Jason Cox on 3/05/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTCurrentGameViewController.h"
#import "TTTeamViewController.h"
#import "TTAPIClient.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+Additions.h"

@interface TTCurrentGameViewController ()

@end

@implementation TTCurrentGameViewController

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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([TTAPIClient sharedClient].selectedGameId) {
        [self performSegueWithIdentifier:@"gotoGame" sender:self];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TTTeamViewController *controller = [segue destinationViewController];
    controller.gameID = [TTAPIClient sharedClient].selectedGameId;
}

@end
