//
//  TTTabBarViewController.m
//  TeamTap
//
//  Created by Jason Cox on 22/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTTabBarViewController.h"
#import "TTAPIClient.h"

@interface TTTabBarViewController ()
- (void)presentEventsIfAuthenticated;
@end

@implementation TTTabBarViewController

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
    
    // Delegate UITabBarControllerDelegate
    self.delegate = self;
    
    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    
    self.selectedIndex = 1;

}

- (void)viewDidAppear:(BOOL)animated
{
    [self presentEventsIfAuthenticated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(TTTabBarViewController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    
    if (fromView == toView) {
        return false;
    }
    
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    return true;
}

- (void)presentEventsIfAuthenticated
{
    if (![[TTAPIClient sharedClient] isAuthenticated]) {
       // Present login modal
        UIStoryboard *storyBoard = [self storyboard];
        UINavigationController *loginModal  = [storyBoard instantiateViewControllerWithIdentifier:@"security"];

        [self presentViewController:loginModal animated:YES completion:nil];
    }
}

@end
