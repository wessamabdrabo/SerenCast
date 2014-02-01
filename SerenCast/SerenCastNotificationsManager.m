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
@end
