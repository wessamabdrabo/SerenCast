//
//  SerenCastNotificationsManager.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 2/1/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerenCastNotificationsManager : NSObject
@property(nonatomic, strong) NSMutableArray* notificationsList;
+(id) sharedInstance;
-(void) addToList:(NSString*)body notificationFiredDate:(NSDate*)firedDate;
@end
