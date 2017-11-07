//
//  TTProfileTableViewController.m
//  TeamTap
//
//  Created by Jason Cox on 16/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTProfileTableViewController.h"
#import "TTProfileTableViewCell.h"
#import "TTAPIClient.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+Additions.h"

@interface TTProfileTableViewController()
    // Private
@end

@implementation TTProfileTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getProfile];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getProfile];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    
    cell.gameLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:cell.gameLabel.font.pointSize];
    cell.subtitleLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:cell.subtitleLabel.font.pointSize];
    cell.messageLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:cell.messageLabel.font.pointSize];
    cell.secondmessageLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:cell.secondmessageLabel.font.pointSize];
    
    // Configure the cell...
    
    NSDictionary *game = self.profile[indexPath.row];
    
    cell.gameLabel.text = game[@"gameName"];
    cell.messageLabel.text = game[@"gameMessage"];
    cell.secondmessageLabel.text = game[@"gameSecondMessage"];
    cell.subtitleLabel.text = game[@"gameSubtitle"];
    
    cell.eventImage.image = nil;
    [cell.eventImage cancelImageRequestOperation];
    
    NSURL *imageURL = [NSURL URLWithString:[game objectForKeyNotNull:@"gameEventImageUrl"]];
    
    if (imageURL) {
        [cell.eventImage setImageWithURL:imageURL];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType =  UITableViewCellAccessoryNone;
    cell.clipsToBounds = YES;
    
    return cell;
}


- (IBAction)logoutButton:(id)sender {
    [[TTAPIClient sharedClient] logout];
    // Present login modal
    UIStoryboard *storyBoard = [self storyboard];
    UINavigationController *loginModal  = [storyBoard instantiateViewControllerWithIdentifier:@"security"];
    [self presentViewController:loginModal animated:YES completion:nil];
}
- (IBAction)shareButton:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(TTProfileTableViewCell *)[[[sender superview] superview] superview]];
    NSDictionary *game = self.profile[indexPath.row];
    
    NSLog(@"%ld", (long)indexPath.row);
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[game[@"shareMessage"]]
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.profile.count;
}

- (void)getProfile
{
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        NSLog(@"== Using OAuth credentials to retrieve event data");
        
        [[TTAPIClient sharedClient] GET:@"/api/v1/registrations/show.json"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    self.profile = responseObject;
                                    [self.tableView reloadData];
                                    [SVProgressHUD dismiss];
                                    NSLog(@"== GET Events Success");
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                                }];
    }
}


@end
