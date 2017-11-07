//
//  TTProfileViewController.m
//  TeamTap
//
//  Created by Darren Cox on 20/06/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTProfileViewController.h"
#import "TTAPIClient.h"

@interface TTProfileViewController ()

@end

@implementation TTProfileViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutButton:(id)sender {
    [[TTAPIClient sharedClient] logout];
    // Present login modal
    UIStoryboard *storyBoard = [self storyboard];
    UINavigationController *loginModal  = [storyBoard instantiateViewControllerWithIdentifier:@"security"];
    [self presentViewController:loginModal animated:YES completion:nil];
}

@end
