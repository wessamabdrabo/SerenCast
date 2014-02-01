//
//  SerenCastNotificationsViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/31/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastNotificationsViewController.h"
#import "SerenCastNotificationsManager.h"
#import "SerenCastNotificationCell.h"

@interface SerenCastNotificationsViewController (){
    NSMutableArray *notificationsList;
    SerenCastNotificationsManager *notificationsManager;
}

@end

@implementation SerenCastNotificationsViewController

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

    notificationsList = [[NSMutableArray alloc]init];
    notificationsManager = [SerenCastNotificationsManager sharedInstance];
    
    if(notificationsManager){
        notificationsList = notificationsManager.notificationsList;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(notificationsManager){
        notificationsList = notificationsManager.notificationsList;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

#pragma table view controller
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(notificationsList)
        return [notificationsList count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SerenCastNotificationCell";
    SerenCastNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SerenCastNotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    int row = [indexPath row];
    NSMutableDictionary * notification = [notificationsList objectAtIndex:row];
    NSString *body = [notification objectForKey:@"body"];
    NSString *fireDate = [notification objectForKey:@"firedDate"];
    // Display notification info
    cell.title.text = body;
    cell.date.text = fireDate;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0;
}
@end
