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
    [self adjustHeightOfTableview];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    notificationsList = [[NSMutableArray alloc]init];
    notificationsManager = [SerenCastNotificationsManager sharedInstance];
    
    if(notificationsManager){
        notificationsList = notificationsManager.notificationsList;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
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
    return 90.0;
}
- (void)adjustHeightOfTableview
{
    CGFloat height = self.tableView.contentSize.height;
    CGFloat maxHeight = [[UIScreen mainScreen]bounds].size.height - self.tableView.frame.origin.y - self.tabBarController.tabBar.frame.size.height;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    // now set the height constraint accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableViewHeightConstraint.constant = maxHeight;
        [self.view needsUpdateConstraints];
    }];
}
@end
