//
//  SerenCastStatusViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerenCastStatus.h"

@interface SerenCastStatusViewController : UIViewController
- (IBAction)proceedBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (strong, nonatomic) NSString* trackID;
@property (strong, nonatomic) SerenCastStatus *status;
@property (weak, nonatomic) IBOutlet UIButton *proceedBtn;

-(id)initWithTrackID:(NSString*)trackID;
@end
