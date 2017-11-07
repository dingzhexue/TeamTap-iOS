//
//  TTSignInViewController.h
//  TeamTap
//
//  Created by Jason Cox on 8/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSignInViewController : UIViewController

- (void)authenticate;

@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end
