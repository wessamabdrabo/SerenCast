//
//  SerenCastStatusViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastStatusViewController.h"
#import "SerenCastPlayerViewController.h"

/* Blocks */
typedef void (^OnSuccess)(void);
typedef void (^OnFailure)(NSString*);

@interface SerenCastStatusViewController (){
    UIActivityIndicatorView* activityView;
}

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
-(id) init{
    self = [super init];
    if(self){
        self.trackID = nil;
        self.status = [[SerenCastStatus alloc]init];
        self.status.userID = @"N/A";
        self.status.text = @"N/A";
        self.status.lastTrackID = @"N/A";
        self.status.time = @"N/A";
        self.status.mode = @"N/A";
    }
    return self;
}
-(id)initWithTrackID:(NSString*)trackID{
    self = [super init];
    if(self){
        self.trackID = trackID;
        self.status = [[SerenCastStatus alloc]init];
        self.status.userID = @"N/A";
        self.status.text = @"N/A";
        self.status.lastTrackID = @"N/A";
        self.status.time = @"N/A";
        self.status.mode = @"N/A";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
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
}

- (IBAction)proceedBtnAction:(id)sender {
    [self.statusTextField resignFirstResponder];
    [self startActivityIndicator];
    [self performSelectorInBackground:@selector(startProcessing) withObject:self];
}
//###############################
# pragma activity indicator
//###############################
-(void)startActivityIndicator{
    activityView.hidden = NO;
    [activityView startAnimating];
}
-(void)stopActivityIndicator{
    activityView.hidden = YES;
    [activityView stopAnimating];
}

//=======================
#pragma  data processing
//=======================
-(void) startProcessing{
    [self prepareData];
    [self.proceedBtn setEnabled:NO];
    [self save:^{
        [self performSelectorOnMainThread:@selector(stopActivityIndicator) withObject:self waitUntilDone:false];
        if(self.trackID){ /* coming from in player status update */
            [self.navigationController popToRootViewControllerAnimated:YES];
            if([[self.navigationController topViewController]isKindOfClass:[SerenCastPlayerViewController class]]){
                NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *docStorePath = [searchPaths objectAtIndex:0];
                NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
                NSMutableDictionary *dataList = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
                /* next track is the last in order list */
                NSString * nextTrack = [dataList objectForKey:@"CurrentAudioFileID"];
                SerenCastPlayerViewController *player =(SerenCastPlayerViewController*) [self.navigationController topViewController];
                if(player){
                    [player resetPlayer:nextTrack playerMode:1];
                    NSLog(@"go to player. don't create a new one. just use the old");
                    [player.navigationController setNavigationBarHidden:NO];
                    [player.view setNeedsDisplay];
                }
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success"
                                                            message: @"Your status is submitted successfully."
                                                           delegate: nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        self.statusTextField.text = @"";
        [self.proceedBtn setEnabled:YES];
    } failure:^(NSString* error){
        [self.proceedBtn setEnabled:YES];
        [self performSelectorOnMainThread:@selector(stopActivityIndicator) withObject:self waitUntilDone:false];
        NSLog(@"save failure!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Problem"
                                                        message: error
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}
-(void) prepareData{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *datafilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:datafilePath];
    self.status.userID = [dataDict objectForKey:@"userID"];
    self.status.lastTrackID = [dataDict objectForKey:@"CurrentAudioFileID"];
    
    self.status.text = self.statusTextField.text;
    self.status.time = [NSString stringWithFormat:@"%@",[NSDate date]];
    /* set mode: from player (0), from tab (1), from notification (2) */
    if (self.trackID)  /* from player */
        self.status.mode = @"0";
    else /* for now just tab */ //TODO: notifications
        self.status.mode = @"1";
}
-(void) save:(OnSuccess)saveSuccess failure:(OnFailure)saveFailure
{
    NSData *__jsonData;
    NSString *__jsonString;
    
    NSArray *keys = [NSArray arrayWithObjects:@"user_id",@"text",@"last_track_id",@"time",@"mode", nil];
    
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    [objects addObject:self.status.userID];
    [objects addObject:self.status.text];
    [objects addObject:self.status.lastTrackID];
    [objects addObject:self.status.time];
    [objects addObject:self.status.mode];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:jsonDictionary forKey:@"status"];
    
    if([NSJSONSerialization isValidJSONObject:params])
    {
        __jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        __jsonString = [[NSString alloc]initWithData:__jsonData encoding:NSUTF8StringEncoding];
    }
    
    // Be sure to properly escape your url string.
    NSURL * url = [NSURL URLWithString:@"http://shrouded-tor-1742.herokuapp.com/statuses"];
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
        saveFailure(@"Status submission failed. Check connection and try again.");
    }
    else
    {
        NSError *jsonParsingError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&jsonParsingError];
        saveSuccess();
    }
}
@end
