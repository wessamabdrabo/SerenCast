//
//  SerenCastConfirmProfileViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 2/2/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerenCastUser.h"

@interface SerenCastConfirmProfileViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ageSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property(strong, nonatomic) SerenCastUser *user;
@property (weak, nonatomic) IBOutlet UITextField *occupationTextField;
- (id) initWithUser:(SerenCastUser*)user;
@end
