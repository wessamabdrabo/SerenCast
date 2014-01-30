//
//  SerenCastTutorial2ViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastTutorial2ViewController.h"
#import "SerenCastPlayerViewController.h"

@interface SerenCastTutorial2ViewController ()

@end

@implementation SerenCastTutorial2ViewController

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
    [self.navigationController setNavigationBarHidden:YES];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startBtnAction:(id)sender {
    SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc] initWithAudio:@"1"];
    [self.navigationController pushViewController:playerController animated:YES];
}
@end
