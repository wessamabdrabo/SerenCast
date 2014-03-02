//
//  SerenCastAppDelegate.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/11/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastAppDelegate.h"
#import "SerenCastPlayerViewController.h"
#import "SerenCastReviewSentViewController.h"
#import "SerenCastFinalViewController.h"
#import "SerenCastLandingScreenViewController.h"
#import "SerenCastStatusViewController.h"
#import "SerenCastPlayerListViewController.h"
#import "SerenCastNotificationsViewController.h"
#import "SerenCastNotificationsManager.h"
#import "SerenCastHelpViewController.h"


@implementation SerenCastAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
/*#ifdef ANDROID
    [UIScreen mainScreen].currentMode =
    [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
#endif*/
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    /* create  copies of data and casts plists in Documents direcotry if they don't exits */
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *dataFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:dataFilePath]){
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SerenCast-Data" ofType:@"plist"] toPath:dataFilePath error:nil];
        NSLog(@"**Copying data plist to documents directory");
        
    }
    NSString *castsFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:castsFilePath]){
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SerenCast-Casts" ofType:@"plist"] toPath:castsFilePath error:nil];
        NSLog(@"**Copying casts plist to documents directory");
        
    }
    NSString *locTimeFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-LocTime.plist"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:locTimeFilePath]){
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SerenCast-LocTime" ofType:@"plist"] toPath:locTimeFilePath error:nil];
        NSLog(@"**Copying loctime plist to documents directory");
    }
    NSString *notficationsFilepath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Notifications.plist"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:notficationsFilepath]){
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SerenCast-Notifications" ofType:@"plist"] toPath:notficationsFilepath error:nil];
        NSLog(@"**Copying notifications plist to documents directory");
    }
   
    /* get current audio track from data plist */
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
    NSString *currentTrack = [plistDict objectForKey:@"CurrentAudioFileID"];
    NSString *reviewIsSent = [plistDict objectForKey:@"ReviewIsSent"];
    NSString *expDone = [plistDict objectForKey:@"ExpDone"];
    NSString *firstTimeUser = [plistDict objectForKey:@"firstTimeUser"];
    NSString *appAlreadyLaunched = [plistDict objectForKey: @"appAlreadyLaunched"];
    
    /* if first time app launches, cancel all notoificaitons (from prev loads), and schedule daily status notification */
    if ([appAlreadyLaunched isEqualToString:@"0"]) {
        NSLog(@"### First time app launch");
        if([[[UIApplication sharedApplication] scheduledLocalNotifications] count] > 0){
            NSLog(@"cancel all local notificaions");
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
       
        /* schedule notifications for reminder and status */
        [[SerenCastNotificationsManager sharedInstance] scheduleStatusNotification];
        [[SerenCastNotificationsManager sharedInstance] scheduleActivityReminderNotification];
        
        [plistDict setValue:@"1" forKey:@"appAlreadyLaunched"];
        [plistDict writeToFile:dataFilePath atomically:NO];
    }
    
    
    
    /* decide which view to load */
    if([expDone isEqualToString:@"1"]){
        SerenCastReviewSentViewController *reviewSentController = [[SerenCastReviewSentViewController alloc]init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reviewSentController];
        self.window.rootViewController = navController;
    }else if([firstTimeUser isEqualToString:@"1"]){
        SerenCastLandingScreenViewController *landingScreen = [[SerenCastLandingScreenViewController alloc]init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landingScreen];
        [navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [navController.navigationBar setShadowImage:[UIImage new]];
        [navController.navigationBar setTranslucent:YES];
        /* Navigation styling */
        UIColor * navBarTintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setBarTintColor:navBarTintColor];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GillSans-Light" size:24], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        
        self.window.rootViewController = navController;
    }else{
        UITabBarController *tabBarController = [[UITabBarController alloc]init];
        /* bar items */
        UITabBarItem* playerTabItem = [[UITabBarItem alloc]  initWithTitle:@"Home" image:[UIImage imageNamed:@"homefull"] tag:0];
        
        UITabBarItem *listTabItem = [[UITabBarItem alloc] initWithTitle:@"Podcasts" image:[UIImage imageNamed:@"playlistfull"] tag:1];
        UITabBarItem *statusTabItem = [[UITabBarItem alloc] initWithTitle:@"Status" image:[UIImage imageNamed:@"statusfull"] tag:2];
        UITabBarItem *notificationsTabItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:[UIImage imageNamed:@"notificationsfull"] tag:3];
        UITabBarItem *helpTabItem = [[UITabBarItem alloc] initWithTitle:@"Help" image:[UIImage imageNamed:@"helpfull"] tag:3];
        
        /* view controllers */
        SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc] initWithAudio:currentTrack];
        SerenCastStatusViewController *statusController = [[SerenCastStatusViewController alloc] init];
        SerenCastPlayerListViewController *listController = [[SerenCastPlayerListViewController alloc]init];
        SerenCastNotificationsViewController *notficationsController = [[SerenCastNotificationsViewController alloc]init];
        SerenCastHelpViewController *helpViewController = [[SerenCastHelpViewController alloc]init];
        
        
        /*set bar items*/
        //[listController setTabBarItem:listTabItem];
        [notficationsController setTabBarItem:notificationsTabItem];
        [statusController setTabBarItem:statusTabItem];
        [helpViewController setTabBarItem:helpTabItem];
        
        UINavigationController *playerNavController = [[UINavigationController alloc] initWithRootViewController:playerController];
        /*[navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [navController.navigationBar setShadowImage:[UIImage new]];
        [navController.navigationBar setTranslucent:YES];*/
        [playerNavController setTabBarItem:playerTabItem];
        
        UINavigationController *playListNavController = [[UINavigationController alloc]initWithRootViewController: listController];
        [playListNavController setTabBarItem:listTabItem];
        
        /* Navigation styling */
        UIColor * navBarTintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setBarTintColor:navBarTintColor];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GillSans-Light" size:24], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        
       
        
        tabBarController.viewControllers = [NSArray arrayWithObjects:playerNavController,playListNavController,statusController,notficationsController,helpViewController, nil];
        //self.window.rootViewController = navController;
        self.window.rootViewController = tabBarController;
    }
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0; /* reset notifications badge */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // Handle launching from a notification
    NSLog(@"############## Application will enter Foreground ##############");
    if([[[UIApplication sharedApplication] scheduledLocalNotifications] count] > 0){
        NSLog(@"Cancelling and rescheduling all locall notifications");
        [[SerenCastNotificationsManager sharedInstance] cancelAndRescheduleAll];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
