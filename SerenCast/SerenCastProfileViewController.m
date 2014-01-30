//
//  SerenCastProfileViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/20/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastProfileViewController.h"
#import "SerenCastProfileInterestsViewController.h"

@interface SerenCastProfileViewController ()
/*@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property(strong, nonatomic) NSString* occupation;
@property(strong, nonatomic) UITextField* editedField;*/
@end

@implementation SerenCastProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithUser:(SerenCastUser*) user{
    self = [super init];
    if(self){
        self.user = user;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //tap gesture recognizer
    /*self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.tap.enabled = NO;
    [self.view addGestureRecognizer:self.tap];*/
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Basic Info";
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"  style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    self.navigationItem.rightBarButtonItem = nextBtnItem;
    
    /*[self.occupationTextField addTarget:self action:@selector(setOccupation:) forControlEvents:UIControlEventEditingDidEnd];
    self.occupationTextField.delegate = self;*/
}
-(void)next:(id)sender{
    /* dismiss keyboard. Needed otherwise the last edited field value won't be reached */
    //[self.editedField resignFirstResponder];
    [self.occupationTextField endEditing:YES];
    
    if(self.ageSelector.selectedSegmentIndex < 0 || self.genderSelector.selectedSegmentIndex < 0 || [self.occupationTextField.text isEqualToString:@""] || !self.occupationTextField.text.length){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert"
                                                        message: @"Please fill-in fields."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
       self.user.age = [NSString  stringWithFormat:@"%ld", (long)self.ageSelector.selectedSegmentIndex];
       self.user.gender = [NSString stringWithFormat:@"%ld", (long)self.genderSelector.selectedSegmentIndex];
        self.user.occupation = self.occupationTextField.text;
        SerenCastProfileInterestsViewController *interestsController = [[SerenCastProfileInterestsViewController alloc] initWithUser:self.user];
        [self.navigationController pushViewController:interestsController animated:YES];
   }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**************************************/
#pragma mark - TextFields actions
/**************************************/
/*-(void) setOccupation:(UITextField*)textField{
    NSLog(@"setOccupation to %@", textField.text);
    self.occupation = textField.text;
}*/

/**************************************/
#pragma mark - UITextFieldDelegate
/**************************************/
/*- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing %@", textField.text);
    self.tap.enabled = YES;
    self.editedField = textField;
}*/

/* hide keyboard on tap outside of textfield*/
/*-(void)hideKeyboard
{
    NSLog(@"hideKeyBoard!!");
    NSLog(@"editedField: %@", [self.editedField description]);
    //[self.editedField resignFirstResponder];
   [self.view endEditing:YES];
   self.tap.enabled = NO;
}*/

@end
