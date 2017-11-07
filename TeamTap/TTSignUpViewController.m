//
//  TTSignUpViewController.m
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTSignUpViewController.h"
#import "TTAPIClient.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+Additions.h"

@interface TTSignUpViewController()
- (void)checkEmailUsernamePasswordPresence:(id)sender;
- (NSString *)createErrorMessage:(NSError *)error;
@end

@implementation TTSignUpViewController

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

    self.userNameField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.userNameField.font.pointSize];
    self.emailField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.emailField.font.pointSize];
    self.passwordField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.passwordField.font.pointSize];
    self.backButton.titleLabel.font = [UIFont fontWithName:@"Entypo" size:self.backButton.titleLabel.font.pointSize];
    self.signupButton.layer.cornerRadius = 8;
    self.signupButton.layer.masksToBounds = YES;
    self.signupButton.backgroundColor = [[TTAPIClient sharedClient] primaryColour];
    
    [self.logoImage setImageWithURL:[[TTAPIClient sharedClient] logoURL]];
    
    [self.passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[self signupButton] setEnabled:NO];
    
    // if email, username and password fields are present allow the user to submit them
    [[self emailField] addTarget:self
                          action:@selector(checkEmailUsernamePasswordPresence:)
                forControlEvents:UIControlEventEditingChanged];
    
    [[self userNameField] addTarget:self
                             action:@selector(checkEmailUsernamePasswordPresence:)
                   forControlEvents:UIControlEventEditingChanged];
    
    [[self passwordField] addTarget:self
                             action:@selector(checkEmailUsernamePasswordPresence:)
                   forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)signupButtonTouch:(id)sender {
    [self registerUser];
}

- (IBAction)passwordEnd:(id)sender {
    [self registerUser];
}

- (void)checkEmailUsernamePasswordPresence:(id)sender
{
    NSString *email = [[self emailField] text];
    NSString *username = [[self userNameField] text];
    NSString *password = [[self passwordField] text];
    
    if (![email isEqualToString:@""] && ![username isEqualToString:@""] && ![password isEqualToString:@""]) {
        [[self signupButton] setEnabled:YES];
    }
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void) registerUser
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSLog(@"== Registering new user");
    
    NSString *email = [[self emailField] text];
    NSString *username = [[self userNameField] text];
    NSString *password = [[self passwordField] text];
    
    [[TTAPIClient sharedClient] registerUserUsingWithEmail:email
                                                 Username:username
                                                 password:password
                                                  success:^(NSDictionary *response) {
                                                      NSLog(@"== Registration success");
                                                      [self authenticate];
                                                  } failure:^(NSError *error) {
                                                      [SVProgressHUD showErrorWithStatus: [self createErrorMessage:error]];
                                                      NSLog(@"==Registration failure: %@", [error localizedDescription]);
                                                  }];
}

- (void) authenticate
{
    NSLog(@"== Authenticating username and password from server");
    
    NSString *email = [[self emailField] text];
    NSString *password = [[self passwordField] text];
    
    [[TTAPIClient sharedClient] authenticateUsingOAuthWithEmail:email
                                                       password:password
                                                        success:^(NSString *accessToken, NSString *refreshToken) {
                                                            NSLog(@"== Auth success: %@", accessToken);
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                            [SVProgressHUD dismiss];
                                                        } failure:^(NSError *error) {
                                                            [SVProgressHUD showErrorWithStatus: [self createErrorMessage:error]];
                                                            NSLog(@"== Auth failure: %@", [self createErrorMessage:error]);
                                                           }];
}

- (NSString *)createErrorMessage:(NSError *)error;
{
    NSDictionary *response = [[error userInfo] objectForKeyedSubscript:@"JSONResponseSerializerWithDataKey"];
    NSString *message = [response objectForKey:@"message"];

    NSInteger errorCode = [[[error userInfo] objectForKey:@"AFNetworkingOperationFailingURLResponseErrorKey"] statusCode ];
    NSString *errorMessage = [error localizedDescription];
    
    if (errorCode == 401) {
        errorMessage = @"Incorrect email or password.";
        return errorMessage;
    } else if (errorCode == 400) {
        return message;
    } else {
        return errorMessage;
    }
    
}

@end
