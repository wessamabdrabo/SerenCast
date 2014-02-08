//
//  SerenCastNotificationsManager.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 2/1/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastNotificationsManager.h"
@interface SerenCastNotificationsManager(){
    NSString* filepath;
    NSMutableArray* fileList;
}
@end

@implementation SerenCastNotificationsManager

+ (id)sharedInstance {
    static SerenCastNotificationsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(id)init{
    self = [super init];
    if(self){
        self.notificationsList = [[NSMutableArray alloc]init];
        filepath = [[NSString alloc]init];
        
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docStorePath = [searchPaths objectAtIndex:0];
        filepath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Notifications.plist"];
        fileList = [[NSMutableArray alloc]initWithContentsOfFile:filepath];
        if(fileList)
            self.notificationsList = fileList;
    }
    return self;
}
-(void) addToList:(NSString*)body notificationFiredDate:(NSDate*)firedDate{
    NSMutableDictionary *notification = [[NSMutableDictionary alloc]init];
    [notification setValue:body?body:@"" forKey:@"body"];
    [notification setValue:[NSString stringWithFormat:@"%@",firedDate?firedDate:@""] forKey:@"firedDate"];
    NSLog(@"adding %@ to list", body);
    if(self.notificationsList){
        [self.notificationsList addObject:notification];
        [self.notificationsList writeToFile:filepath atomically:NO];
    }
}

-(void) scheduleStatusNotification{
   
    NSDate *currentDate = [NSDate date];
    NSLog(@"current date = %@", [currentDate description]);

    /* schedule status daily notification starting today in an hour*/
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:86400]; /* seconds in 1 days */
    NSLog(@"Status firedate %@", localNotification.fireDate);
    localNotification.alertBody = [NSString stringWithFormat:@"Tell us what you feel like listening to today."];
    localNotification.alertAction = @"Status";
    localNotification.repeatInterval = NSDayCalendarUnit;
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
-(void) scheduleActivityReminderNotification{
   
    NSDate *currentDate = [NSDate date];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:604800]; /* seconds in 7 days */
    NSLog(@"Reminder firedate %@", localNotification.fireDate);
    localNotification.alertBody = [NSString stringWithFormat:@"You have not listened to any podcasts in a couple of days. Want to give it a try now?"];
    localNotification.alertAction = @"Reminder";
    localNotification.repeatInterval = NSWeekCalendarUnit; /* every week */
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
-(void) cancelAndRescheduleAll{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if( notifications && [notifications count]){
        for (int i=0; i< [notifications count]; i++)
        {
            UILocalNotification *notification = [notifications objectAtIndex:i];
            if (notification) {
                if([[notification alertAction]isEqualToString:@"Reminder"]){
                    [[UIApplication sharedApplication] cancelLocalNotification:notification];
                    [self scheduleActivityReminderNotification];
                    break;
                }
            }
        }
    }
}

@end
