//
//  SerenCastProfileInterestsViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/20/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastProfileInterestsViewController.h"
//#import "SerenCastPlayerViewController.h"
#import "SerenCastInterestTableCell.h"
#import "SerenCastTutorial2ViewController.h"

@interface SerenCastProfileInterestsViewController ()

@end

@implementation SerenCastProfileInterestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithUser:(SerenCastUser*)user{
    self = [super init];
    if(self){
        self.user = user;
        self.user.interests = [[NSMutableDictionary alloc]init];
        for(int i = 0 ; i < 15; i++){
            [self.user.interests setValue:@"-1" forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.Interests = [NSArray arrayWithObjects:@"Science",@"Diet & Fitness", @"Politics", @"Technology",@"Theology",@"Sports",@"News",@"Business", @"Arts",@"Entertainment",@"Environment",@"Psychology", @"Literature", @"Cars",@"Shopping", nil];
    self.navigationItem.title = @"Interests";
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = nextBtnItem;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) save
{
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
    }
    else
    {
        NSError *jsonParsingError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&jsonParsingError];
    }
}
-(bool)validate{
    bool showAlert = false;
    for(int i = 0 ; i < self.user.interests.count; i++){
        if([[self.user.interests objectForKey:[NSString stringWithFormat:@"%d",i]] isEqualToString:@"-1"]){
            showAlert = true;
            break;
        }
    }
    if(showAlert){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert"
                                                        message: @"Please fill-in fields."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    return showAlert;
}
-(void)done:(id)sender{
    if(![self validate]){
        [self save];
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docStorePath = [searchPaths objectAtIndex:0];
        NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [plistDict setValue:@"0" forKey:@"firstTimeUser"];
        [plistDict setValue:self.user.email forKey:@"userID"]; /*save user id*/
        [plistDict writeToFile:filePath atomically:NO];
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Thank You"
                                                    message: @"Your profile is created and your data is sent to us."
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
}
//######################################
#pragma mark - Alert Delegate
//######################################

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    SerenCastTutorial2ViewController *tutotrialController = [[SerenCastTutorial2ViewController alloc] init];
    [self.navigationController pushViewController:tutotrialController animated:YES];
    /*SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc] initWithAudio:@"1"];
    [self.navigationController pushViewController:playerController animated:YES];*/
}


//######################################
#pragma mark - Table view data source
//######################################

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Interests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"SerenCastInterestTableCell";
    SerenCastInterestTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SerenCastInterestTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSInteger row = [indexPath row];
    cell.label.text = [self.Interests objectAtIndex:row];
    NSString* rating = [self.user.interests objectForKey:[NSString stringWithFormat:@"%d",row]];
    if(![rating isEqualToString:@"-1"])
        cell.segmentedControl.selectedSegmentIndex = [rating integerValue];
    else
        cell.segmentedControl.selectedSegmentIndex = -1;
    cell.segmentedControl.tag = row;
    [cell.segmentedControl addTarget:self action:@selector(sliderUpdate:) forControlEvents:UIControlEventValueChanged];
    return cell;
}
-(void)sliderUpdate:(UISegmentedControl *)sender {
    int value = sender.selectedSegmentIndex;
    int tag = sender.tag;
    [self.user.interests setValue:[NSString stringWithFormat:@"%d",value] forKey:[NSString stringWithFormat:@"%d",tag]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
