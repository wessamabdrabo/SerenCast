//
//  SerenCastPlayerListViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/31/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerenCastPlayerListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)addToPlayed:(int)index;
-(void)addToFavs:(int)index;
@end
