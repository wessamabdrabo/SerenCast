//
//  SerenCastConfirmProfileViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 2/2/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastConfirmProfileViewController.h"
#import "SerenCastTutorial2ViewController.h"

/* Blocks */
typedef void (^OnSuccess)(void);
typedef void (^OnFailure)(NSString*);

@interface SerenCastConfirmProfileViewController (){
    bool submitSuccess;
    UIActivityIndicatorView *activityView;
}
@end

@implementation SerenCastConfirmProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) initWithUser:(SerenCastUser*)user{
    self = [super init];
    if(self){
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Confirm";
    
    //self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = nextBtnItem;
    
    self.emailTextField.text = self.user.email;
    if(self.user.age){
        NSLog(@"age = %@", self.user.age);
        NSLog(@"intval = %d", [self.user.age intValue]);
        [self.ageSegmentedControl setSelectedSegmentIndex:[self.user.age intValue]];
    }
    if(self.user.gender)
        [self.genderSegmentedControl setSelectedSegmentIndex:[self.user.gender intValue]];
    self.occupationTextField.text = self.user.occupation;
    
    submitSuccess = false;
    
    /* activity indicator */
    activityView = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [activityView hidesWhenStopped];
    [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)done:(id)sender{
    [self startActivityIndicator];
    [self performSelectorInBackground:@selector(startProcessing) withObject:self];
}

//###############################
# pragma activity indicator
//###############################
-(void)startActivityIndicator{
    [self.occupationTextField resignFirstResponder];
    activityView.hidden = NO;
    [activityView startAnimating];
}
-(void)stopActivityIndicator{
    activityView.hidden = YES;
    [activityView stopAnimating];
}
//#######################################
#pragma data processing
//#######################################
-(void) save:(OnSuccess)saveSuccess failure:(OnFailure)saveFailure
{
    submitSuccess = false;
    
    NSData *__jsonData;
    NSString *__jsonString;
    
    NSArray *keys = [NSArray arrayWithObjects:@"email",@"age",@"gender",@"occupation",@"interest1_rate",@"interest2_rate",@"interest3_rate",@"interest4_rate",@"interest5_rate",@"interest6_rate",@"interest7_rate",@"interest8_rate",@"interest9_rate",@"interest10_rate",@"interest11_rate",@"interest12_rate",@"interest13_rate",@"interest14_rate",@"interest15_rate", nil];
    
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    [objects addObject:self.user.email];
    [objects addObject:self.user.age];
    [objects addObject:self.user.gender];
    [objects addObject:self.user.occupation];
    [objects addObject:[self.user.interests objectForKey:@"0"]];
    [objects addObject:[self.user.interests objectForKey:@"1"]];
    [objects addObject:[self.user.interests objectForKey:@"2"]];
    [objects addObject:[self.user.interests objectForKey:@"3"]];
    [objects addObject:[self.user.interests objectForKey:@"4"]];
    [objects addObject:[self.user.interests objectForKey:@"5"]];
    [objects addObject:[self.user.interests objectForKey:@"6"]];
    [objects addObject:[self.user.interests objectForKey:@"7"]];
    [objects addObject:[self.user.interests objectForKey:@"8"]];
    [objects addObject:[self.user.interests objectForKey:@"9"]];
    [objects addObject:[self.user.interests objectForKey:@"10"]];
    [objects addObject:[self.user.interests objectForKey:@"11"]];
    [objects addObject:[self.user.interests objectForKey:@"12"]];
    [objects addObject:[self.user.interests objectForKey:@"13"]];
    [objects addObject:[self.user.interests objectForKey:@"14"]];
    
    
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:jsonDictionary forKey:@"user"];
    if([NSJSONSerialization isValidJSONObject:params])
    {
        NSLog(@"isValid!!");
        __jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        __jsonString = [[NSString alloc]initWithData:__jsonData encoding:NSUTF8StringEncoding];
    }
    
    // Be sure to properly escape your url string.
    NSURL * url = [NSURL URLWithString:@"http://shrouded-tor-1742.herokuapp.com/users"];
    //NSURL * url = [NSURL URLWithString:@"http://localhost:3000/users"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: __jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[__jsonData length]] forHTTPHeaderField:@"Content-Length"];
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    NSError *errorReturned = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
    if (errorReturned) {
        // Handle error.
        NSLog(@"error %@", errorReturned);
        saveFailure(@"Profile submission failed. Please check conneciton and try again.");
    }
    else
    {
        NSError *jsonParsingError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&jsonParsingError];
        saveSuccess();
    }
}
-(void) startProcessing
{
    self.user.email = self.emailTextField.text;
    self.user.age = [NSString  stringWithFormat:@"%ld", (long)self.ageSegmentedControl.selectedSegmentIndex];
    self.user.gender = [NSString stringWithFormat:@"%ld", (long)self.genderSegmentedControl.selectedSegmentIndex];
    self.user.occupation = self.occupationTextField.text;
    [self save: ^(void){
        NSLog(@"save success!");
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docStorePath = [searchPaths objectAtIndex:0];
        NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [plistDict setValue:@"0" forKey:@"firstTimeUser"];
        [plistDict setValue:self.user.email forKey:@"userID"];
        [plistDict writeToFile:filePath atomically:NO];
        
        submitSuccess = true;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Thank You"
                                                        message: @"Your profile is created and your data is sent to us."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.delegate = self;
        
        [alert show];
    }
       failure:^(NSString* error){
           NSLog(@"save failure!");
           
           submitSuccess = false;
           
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Problem"
                                                           message: error
                                                          delegate: nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
           alert.delegate = self;
           
           [alert show];
       }];
}

//######################################
#pragma mark - Alert Delegate
//######################################
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(submitSuccess){
        SerenCastTutorial2ViewController *tutotrialController = [[SerenCastTutorial2ViewController alloc] init];
        [self.navigationController pushViewController:tutotrialController animated:YES];
    }
}
@end
