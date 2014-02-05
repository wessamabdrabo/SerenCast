//
//  SerenCastTutorial2ViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastTutorial2ViewController.h"
#import "SerenCastPlayerViewController.h"
#import "SerenCastStatusViewController.h"
#import "SerenCastPlayerListViewController.h"
#import "SerenCastNotificationsViewController.h"
#import "SerenCastHelpViewController.h"


@interface SerenCastTutorial2ViewController ()

@end

@implementation SerenCastTutorial2ViewController

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
    [self.navigationController setNavigationBarHidden:YES];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startBtnAction:(id)sender {
    //SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc] initWithAudio:@"1"];
    //[self.navigationController pushViewController:playerController animated:YES];
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    /* bar items */
    UITabBarItem* playerTabItem = [[UITabBarItem alloc]  initWithTitle:@"Home" image:[UIImage imageNamed:@"homefull"] tag:0];
    
    UITabBarItem *listTabItem = [[UITabBarItem alloc] initWithTitle:@"Playlist" image:[UIImage imageNamed:@"playlistfull"] tag:1];
    UITabBarItem *statusTabItem = [[UITabBarItem alloc] initWithTitle:@"Status" image:[UIImage imageNamed:@"statusfull"] tag:2];
    UITabBarItem *notificationsTabItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:[UIImage imageNamed:@"notificationsfull"] tag:3];
    UITabBarItem *helpTabItem = [[UITabBarItem alloc] initWithTitle:@"Help" image:[UIImage imageNamed:@"helpfull"] tag:3];
    
    /* view controllers */
    SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc] initWithAudio:@"1"];
    SerenCastStatusViewController *statusController = [[SerenCastStatusViewController alloc] init];
    SerenCastPlayerListViewController *listController = [[SerenCastPlayerListViewController alloc]init];
    SerenCastNotificationsViewController *notficationsController = [[SerenCastNotificationsViewController alloc]init];
    SerenCastHelpViewController *helpViewController = [[SerenCastHelpViewController alloc]init];

    /*set bar items*/
    [listController setTabBarItem:listTabItem];
    [notficationsController setTabBarItem:notificationsTabItem];
    [statusController setTabBarItem:statusTabItem];
    [helpViewController setTabBarItem:helpTabItem];

    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:playerController];
    [navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:[UIImage new]];
    [navController.navigationBar setTranslucent:YES];
    [navController setTabBarItem:playerTabItem];

    
    tabBarController.viewControllers = [NSArray arrayWithObjects:navController,listController,statusController,notficationsController, helpViewController, nil];
    [self.navigationController pushViewController:tabBarController animated:YES];
}
@end
