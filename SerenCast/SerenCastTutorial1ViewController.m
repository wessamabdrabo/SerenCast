//
//  SerenCastTutorial1ViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastTutorial1ViewController.h"
#import "SerenCastProfileViewController.h"
#import "SerenCastUser.h"

@interface SerenCastTutorial1ViewController ()

@end

@implementation SerenCastTutorial1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithEmail:(NSString*) email{
    self = [super init];
    
    if(self){
        self.email = email;
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

- (IBAction)startProfileBtnAction:(id)sender {
    SerenCastUser *user = [[SerenCastUser alloc]initWithEmail:self.email];
    SerenCastProfileViewController *profileController = [[SerenCastProfileViewController alloc]initWithUser:user];
    [self.navigationController pushViewController:profileController animated:YES];
}
@end
