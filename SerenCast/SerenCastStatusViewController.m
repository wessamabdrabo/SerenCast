//
//  SerenCastStatusViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastStatusViewController.h"
#import "SerenCastPlayerViewController.h"

@interface SerenCastStatusViewController ()

@end

@implementation SerenCastStatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithTrackID:(NSString*)trackID{
    self = [super init];
    if(self){
        self.trackID = trackID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)proceedBtnAction:(id)sender {
    SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc]initWithAudio:self.trackID];
    [self.navigationController pushViewController:playerController animated:YES];
}
@end
