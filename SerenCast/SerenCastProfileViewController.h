//
//  SerenCastProfileViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/20/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerenCastUser.h"
@interface SerenCastProfileViewController : UIViewController/*<UITextFieldDelegate>*/
@property (strong, nonatomic) SerenCastUser *user;
-(id) initWithUser:(SerenCastUser*) user;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ageSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelector;
@property (weak, nonatomic) IBOutlet UITextField *occupationTextField;

@end
