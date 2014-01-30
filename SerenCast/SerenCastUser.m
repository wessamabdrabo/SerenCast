//
//  SerenCastUser.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/23/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastUser.h"

@implementation SerenCastUser

-(id) initWithEmail:(NSString*) email
{
    self = [super init];
    if(self){
        self.email = email;
    }
    return self;
}
@end
