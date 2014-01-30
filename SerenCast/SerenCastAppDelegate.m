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
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SerenCast-Data" ofType:@"plist"] toPath:filePath error:nil];
        NSLog(@"**Copying data plist to documents directory");
        
    }
    /*NSString *reviewFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Reviews.plist"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:reviewFilePath]){
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SerenCast-Reviews" ofType:@"plist"] toPath:reviewFilePath error:nil];
        NSLog(@"**Copying reviews plist to documents directory");
        
    }*/
    NSString *locTimeFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-LocTime.plist"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:locTimeFilePath]){
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SerenCast-LocTime" ofType:@"plist"] toPath:locTimeFilePath error:nil];
        NSLog(@"**Copying loctime plist to documents directory");
    }
    /* get current audio track from data plist */
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSString *currentTrack = [plistDict objectForKey:@"CurrentAudioFileID"];
    NSString *reviewIsSent = [plistDict objectForKey:@"ReviewIsSent"];
    NSString *expDone = [plistDict objectForKey:@"ExpDone"];
    NSString *firstTimeUser = [plistDict objectForKey:@"firstTimeUser"];

    
    
    /*if([reviewIsSent isEqualToString:@"1"]){
        SerenCastReviewSentViewController *reviewSentController = [[SerenCastReviewSentViewController alloc]init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reviewSentController];
        self.window.rootViewController = navController;
    }else*/ if([expDone isEqualToString:@"1"]){
        /*SerenCastFinalViewController *finalController = [[SerenCastFinalViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:finalController];
        self.window.rootViewController = navController;*/
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
    }
    else{
        SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc] initWithAudio:currentTrack];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:playerController];
        [navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [navController.navigationBar setShadowImage:[UIImage new]];
        [navController.navigationBar setTranslucent:YES];
        /* Navigation styling */
        UIColor * navBarTintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setBarTintColor:navBarTintColor];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GillSans-Light" size:24], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        self.window.rootViewController = navController;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
