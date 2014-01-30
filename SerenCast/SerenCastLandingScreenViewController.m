//
//  SerenCastLandingScreenViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/20/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastLandingScreenViewController.h"
//#import "SerenCastProfileViewController.h"
//#import "SerenCastUser.h"
#import "SerenCastTutorial1ViewController.h"

@interface SerenCastLandingScreenViewController ()

@end

@implementation SerenCastLandingScreenViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createProfileAction:(id)sender {
    //Validate
    NSString *email = self.emailTextField.text;
    if(!email.length || [email isEqualToString:@""] || ![self isValidEmail:email]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert"
                                                        message: @"Please enter a valid email."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        /*SerenCastUser *user = [[SerenCastUser alloc]initWithEmail:email];
        SerenCastProfileViewController *profileController = [[SerenCastProfileViewController alloc]initWithUser:user];
        [self.navigationController pushViewController:profileController animated:YES];*/
        SerenCastTutorial1ViewController *tut1 = [[SerenCastTutorial1ViewController alloc]initWithEmail:email];
        [self.navigationController pushViewController:tut1 animated:YES];
    }
}

#pragma Validate email
-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
