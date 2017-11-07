//
//  TTAPIClient.m
//  TeamTap
//
//  Created by Jason Cox on 15/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTAPIClient.h"
#import "AFJSONResponseSerializer+Data.h"
#import "EDColor.h"
#import "SVProgressHUD.h"

@implementation TTAPIClient

+ (instancetype)sharedClient
{
    static TTAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TTAPIClient alloc] initWithBaseURL:[NSURL URLWithString:oClientBaseURLString]];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer_Data serializer];
        [_sharedClient getUIAttributes];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAccessToken"];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"kRefreshToken"];
        
        [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
    }
    return self;
}

- (void)authenticateUsingOAuthWithEmail:(NSString *)email
                               password:(NSString *)password
                                success:(void (^)(NSString *accessToken, NSString *refreshToken))success
                                failure:(void (^)(NSError *))failure
{
    NSDictionary *params = @{ @"email"         : email,
                              @"password"      : password,
                              @"grant_type"    : @"password",
                              @"client_id"     : oClientID,
                              @"client_secret" : oClientSecret };
    
    [self POST:@"oauth/token.json"
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSString *accessToken = responseObject[@"access_token"];
           NSString *refreshToken = responseObject[@"refresh_token"];
           
           [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
           
           if (success) success(accessToken, refreshToken);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           if (failure) failure(error);
       }];
}

- (void)registerUserUsingWithEmail:(NSString *)email
                          Username:(NSString *)username
                          password:(NSString *)password
                           success:(void (^)(NSDictionary *response))success
                           failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"[user]email"                 : email,
                              @"[user]username"              : username,
                              @"[user]password"              : password,
                              @"[user]password_confirmation" : password,
                              @"client_id"                   : oClientID,
                              @"client_secret"               : oClientSecret };
    
    [self POST:@"/api/v1/registrations/create.json"
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSDictionary *response = responseObject;
           if (success) success(response);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           if (failure) failure(error);
       }];

    
}

- (void)logout
{
    [self setIsAuthenticated:NO];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kAccessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kRefreshToken"];
    
    [[self requestSerializer] setValue:nil forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"User logged out");
}

#pragma mark - Private

- (void)setAuthorizationWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken
{
    if (accessToken != nil && ![accessToken isEqualToString:@""]) {
        [self setIsAuthenticated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"kAccessToken"];
        [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"kRefreshToken"];
        
        [[self requestSerializer] setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    }
}

#pragma mark - UI Attributes

- (void)getUIAttributes
{
    NSDictionary *params = @{ @"device"        : @"ios",
                              @"client_id"     : oClientID,
                              @"client_secret" : oClientSecret
                           };
    
    [self GET:@"/api/v1/ui.json"
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject) {
           
           NSDictionary *response = responseObject;
           
           [self setPrimaryColour:[UIColor colorWithHexString:response[@"primaryColour"]]];
           [self setLogoURL:[NSURL URLWithString:response[@"logoURL"]]];
           [self setLandingBgURL:[NSURL URLWithString:response[@"landingBgURL"]]];
           [self setSigninBgURL:[NSURL URLWithString:response[@"signinBgURL"]]];
           [self setSigninBgURL:[NSURL URLWithString:response[@"signupBgURL"]]];
           
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           
           UIAlertView *errorView;
           
           errorView = [[UIAlertView alloc]
                        initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                        message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to gather the data required.", @"Network error")
                        delegate: self
                        cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
           
           [errorView show];
           
           NSLog(@"Failed to get ui");
       }];
    

}

@end
