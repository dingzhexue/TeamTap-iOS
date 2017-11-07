//
//  TTSignUpViewController.h
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSignUpViewController : UIViewController

- (void) registerUser;
- (void) authenticate;

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;
@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end
