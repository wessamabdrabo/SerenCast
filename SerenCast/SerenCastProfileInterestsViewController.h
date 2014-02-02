//
//  SerenCastProfileInterestsViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/20/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerenCastUser.h"

@interface SerenCastProfileInterestsViewController : UIViewController </*UIAlertViewDelegate,*/UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) SerenCastUser *user;
@property (nonatomic, strong) NSArray* Interests;
-(id) initWithUser:(SerenCastUser*)user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
