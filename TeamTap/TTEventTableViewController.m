//
//  TTEventTableViewController.m
//  TeamTap
//
//  Created by Jason Cox on 16/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "TTEventTableViewController.h"
#import "TTEventTableViewCell.h"
#import "TTTeamViewController.h"
#import "TTAPIClient.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+Additions.h"

@interface TTEventTableViewController()
- (void)getEvents;
- (void)nextGameWithEventID: (NSNumber *) eventID;
@end

@implementation TTEventTableViewController

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
    
    self.expandedCells = [[NSMutableArray alloc] init];
    
    // Scroll beyond taller tab bar
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 16, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 400;
    
}

- (void)viewWillAppear:(BOOL)animated
{
     [self getEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.tapsLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:cell.tapsLabel.font.pointSize];
    cell.matchTapsTitle.font = [UIFont fontWithName:@"OpenSans-Semibold" size:cell.matchTapsTitle.font.pointSize];
    cell.sponsorLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:cell.sponsorLabel.font.pointSize];
    cell.charityLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:cell.charityLabel.font.pointSize];
    cell.labelTitle.font = [UIFont fontWithName:@"OpenSans-Semibold" size:cell.labelTitle.font.pointSize];
    
    
    // Configure the cell...
    
    NSDictionary *event = self.events[indexPath.row];
    
    cell.eventID = event[@"eventID"];
    cell.labelTitle.text = [[NSString stringWithString:event[@"name"]] uppercaseString];
    cell.sponsorLabel.text = [[NSString stringWithString:event[@"sponsor"]] uppercaseString];
    cell.charityLabel.text = [[NSString stringWithString:event[@"charity"]] uppercaseString];
    cell.tapsLabel.text = [NSString stringWithFormat:@"%@", event[@"taps"]];
    cell.eventBanner.backgroundColor = [[TTAPIClient sharedClient] primaryColour];
    cell.infoLabel.text = event[@"info"];
    cell.infoLabel.font = [UIFont fontWithName:@"OpenSans" size:cell.infoLabel.font.pointSize];
    
    if ([cell.contentView viewWithTag:12346]) {
        [[cell.contentView viewWithTag:12346] removeFromSuperview];
    }
    
    cell.eventImage.image = nil;
    [cell.eventImage cancelImageRequestOperation];
    
    NSURL *imageURL = [NSURL URLWithString:[event objectForKeyNotNull:@"imageURL"]];
    
    if (imageURL) {
        cell.eventImage.hidden = false;
        [cell.eventImage setImageWithURL:imageURL];
    } else {
        cell.eventImage.hidden = true;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType =  UITableViewCellAccessoryNone;
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.clipsToBounds = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTEventTableViewCell *cell =(TTEventTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    [self nextGameWithEventID:cell.eventID];
}


- (IBAction)expandInfo:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
    //expandedCells is a mutable set declared in your interface section or private class extension
    if ([self.expandedCells containsObject:indexPath]) {
        [self.expandedCells removeObject:indexPath];
    } else {
        [self.expandedCells removeAllObjects];
        [self.expandedCells addObject:indexPath];
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self.expandedCells containsObject:indexPath]) {
//        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 326, 277, 30)];
//        tempLabel.text = self.events[indexPath.row][@"info"];
//        tempLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
//        tempLabel.numberOfLines = 0;
//        [tempLabel sizeToFit];
//        return 200 + tempLabel.frame.size.height;
//    } else {
//        return 400;
//    }
//}

#pragma mark - Private

- (void)getEvents
{
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
        NSLog(@"== Using OAuth credentials to retrieve event data");
    
        [[TTAPIClient sharedClient] GET:@"/api/v1/events.json"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    self.events = responseObject;
                                    [self.tableView reloadData];
                                    [SVProgressHUD dismiss];
                                    NSLog(@"== GET Events Success");
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                                }];
    }
}

- (void)nextGameWithEventID:(NSNumber *) eventID
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No scheduled games"
                                                    message:@"Sorry, there are no scheduled games available to play at this time."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    if ([[TTAPIClient sharedClient] isAuthenticated]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        NSLog(@"== Using OAuth credentials to check for next game");
        
        // Query with the event id
        NSDictionary *params = @{ @"event_id" : eventID };
        
        [[TTAPIClient sharedClient] GET:@"/api/v1/events/next_game.json"
                             parameters:params
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    // Go to next view if game
                                    if ([responseObject objectForKeyNotNull:@"gameID"]) {
                                        [TTAPIClient sharedClient].selectedGameId = [responseObject[@"gameID"] intValue];
                                        self.navigationController.tabBarController.selectedIndex = 2;
                                    } else {
                                        [SVProgressHUD dismiss];
                                        [alert show];
                                    }
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                                }];
    }
}

-(NSIndexPath*)GetIndexPathFromSender:(id)sender{
    
    if(!sender) { return nil; }
    
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = sender;
        return [self.tableView indexPathForCell:cell];
    }
    
    return [self GetIndexPathFromSender:((UIView*)[sender superview])];
}

@end
