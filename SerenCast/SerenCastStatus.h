//
//  SerenCastStatus.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 2/3/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerenCastStatus : NSObject
@property(nonatomic, strong) NSString* userID;
@property(nonatomic, strong) NSString* text;
@property(nonatomic, strong) NSString* lastTrackID;
@property(nonatomic, strong) NSString* time;
@property(nonatomic, strong) NSString* mode;
@end
