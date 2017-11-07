//
//  TTSignInViewController.m
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTSignInViewController.h"
#import "TTAPIClient.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+Additions.h"

@interface TTSignInViewController()
- (NSString *)createErrorMessage:(NSError *)error;
- (void)checkUsernamePasswordPresence:(id)sender;
@end

@implementation TTSignInViewController

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

    // Force element attributes
//    [self.userNameField becomeFirstResponder];
    self.userNameField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.userNameField.font.pointSize];
    self.passwordField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.passwordField.font.pointSize];
    self.backButton.titleLabel.font = [UIFont fontWithName:@"Entypo" size:self.backButton.titleLabel.font.pointSize];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.loginButton.titleLabel.font.pointSize];
    self.loginButton.layer.cornerRadius = 8;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.backgroundColor = [[TTAPIClient sharedClient] primaryColour];
    [[self loginButton] setEnabled:NO];
    
    
    [self.logoImage setImageWithURL:[[TTAPIClient sharedClient] logoURL]];
    
    // May want to change this style
    [[SVProgressHUD appearance] setHudBackgroundColor:[UIColor clearColor]];
    
    [self.passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // if username and password fields are present allow the user to submit them
    [[self userNameField] addTarget:self
                        action:@selector(checkUsernamePasswordPresence:)
              forControlEvents:UIControlEventEditingChanged];
    
    [[self passwordField] addTarget:self
                             action:@selector(checkUsernamePasswordPresence:)
                   forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    
    if (textField == self.passwordField) {
        // This is a workaround because secure text fields don't play well with custom fonts
        if (textField.text.length == 0) {
            textField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:textField.font.pointSize];
        }
        else {
            textField.font = [UIFont systemFontOfSize:textField.font.pointSize];
        }
    }
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)loginTouch:(id)sender
{
    [self authenticate];
}

- (IBAction)passwordEnd:(id)sender
{
    [self authenticate];
}

- (IBAction)privacyPolicy:(id)sender
{
    
}

- (IBAction)termsOfUse:(id)sender
{
    
}

- (void)checkUsernamePasswordPresence:(id)sender
{
    NSString *username = [[self userNameField] text];
    NSString *password = [[self passwordField] text];
    
    if (![username isEqualToString:@""] && ![password isEqualToString:@""]) {
        [[self loginButton] setEnabled:YES];
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)authenticate
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSLog(@"== Authenticating username and password from server");
    
    NSString *username = [[self userNameField] text];
    NSString *password = [[self passwordField] text];
    
    [[TTAPIClient sharedClient] authenticateUsingOAuthWithEmail:username
                                                       password:password
                                                        success:^(NSString *accessToken, NSString *refreshToken) {
                                                            NSLog(@"== Auth success: %@", accessToken);
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                            [SVProgressHUD dismiss];
                                                        } failure:^(NSError *error) {
                                                            [SVProgressHUD showErrorWithStatus: [self createErrorMessage:error]];
                                                            NSLog(@"== Auth failure: %@", [error localizedDescription]);
                                                        }];
}

- (NSString *)createErrorMessage:(NSError *)error;
{
    NSString *errorMessage = [error localizedDescription];
    NSInteger errorCode = [[[error userInfo] objectForKey:@"AFNetworkingOperationFailingURLResponseErrorKey"] statusCode ];
    
    if (errorCode == 401) {
        errorMessage = @"Incorrect email or password.";
    }
    return errorMessage;
}

@end
