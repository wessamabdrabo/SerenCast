//
//  SerenCastHelpViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 2/4/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastHelpViewController.h"

@interface SerenCastHelpViewController ()

@end

@implementation SerenCastHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustViewHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)adjustViewHeight
{
    CGFloat maxHeight = [[UIScreen mainScreen]bounds].size.height - self.bgView.frame.origin.y - self.tabBarController.tabBar.frame.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.textViewHeightConstraint.constant = maxHeight;
        self.bgViewHeightConstraint.constant = maxHeight;
        [self.view needsUpdateConstraints];
    }];
}

@end
