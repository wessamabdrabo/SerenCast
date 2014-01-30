//
//  SerenCastReview.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/24/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerenCastReview : NSObject
@property(nonatomic, strong)NSString* cast_id;
@property(nonatomic,strong)NSString* user_id;
@property(nonatomic, strong)NSString* criteria1;
@property(nonatomic, strong)NSString*criteria2;
@property(nonatomic, strong)NSString*criteria3;
@property(nonatomic, strong)NSString*criteria4;
@property(nonatomic,strong)NSString*time;
@property(nonatomic, strong)NSString*loc_longitude;
@property(nonatomic, strong)NSString*loc_latitude;
@property(nonatomic,strong)NSString*loc_subthroughfare;
@property(nonatomic, strong)NSString*loc_throughfare;
@property(nonatomic, strong)NSString*loc_postalcode;
@property(nonatomic, strong)NSString*loc_adminarea;
@property(nonatomic, strong)NSString*loc_country;
@property(nonatomic, strong)NSString*loc_name;
@property(nonatomic, strong)NSString*loc_region;
@property(nonatomic, strong)NSString*loc_locality;

@end
