//
//  SerenCastUser.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/23/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerenCastUser : NSObject
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *age;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, strong) NSString *occupation;
@property(nonatomic, strong) NSMutableDictionary *interests;

-(id) initWithEmail:(NSString*) email;

@end
