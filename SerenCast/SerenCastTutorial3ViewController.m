//
//  SerenCastTutorial3ViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastTutorial3ViewController.h"
#import "SerenCastReviewViewController.h"

@interface SerenCastTutorial3ViewController (){
    int playerMode;
}
@end

@implementation SerenCastTutorial3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithTrackIDAndMode:(NSString*) trackID trackTitle:(NSString*)trackTitle mode:(int)mode{
    self = [super init];
    if(self){
        self.trackID = trackID;
        self.trackTitle = trackTitle;
        playerMode = mode;
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

- (IBAction)proceedAction:(id)sender {
    SerenCastReviewViewController * reviewViewController = [[SerenCastReviewViewController alloc]initWithReviewedTrackAndMode:self.trackID trackTitle:self.trackTitle mode:playerMode]; /* always order mode */
    [self.navigationController pushViewController:reviewViewController animated:YES];
}
@end
