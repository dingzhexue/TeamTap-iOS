//
//  TTAPIClient.h
//  TeamTap
//
//  Created by Jason Cox on 15/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface TTAPIClient : AFHTTPSessionManager

@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, assign) NSInteger selectedGameId;

@property (nonatomic, retain) UIColor *primaryColour;
@property (nonatomic, retain) NSURL *logoURL;
@property (nonatomic, retain) NSURL *landingBgURL;
@property (nonatomic, retain) NSURL *signinBgURL;
@property (nonatomic, retain) NSURL *signupBgURL;

+ (instancetype)sharedClient;

- (void)setAuthorizationWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;

- (void)authenticateUsingOAuthWithEmail:(NSString *)email
                               password:(NSString *)password
                                success:(void (^)(NSString *accessToken, NSString *refreshToken))success
                                failure:(void (^)(NSError *error))failure;

- (void)registerUserUsingWithEmail:(NSString *)email
                          Username:(NSString *)username
                          password:(NSString *)password
                           success:(void (^)(NSDictionary *response))success
                           failure:(void (^)(NSError *error))failure;
- (void)logout;
- (void)getUIAttributes;

// Server credentials
//#define oClientBaseURLString @"http://api.teamtap.co/"
#define oClientBaseURLString @"http://tt-production.herokuapp.com"
#define oClientID            @"016c1c349b2d35a2dff18ca2602fdfcd3da0de1521570e9e26a4f6500bd5574f"
#define oClientSecret        @"3a3377169fa85a47ee2a570a4fede09a3bc4f030463661636ee96d80852e0efc"

@end
