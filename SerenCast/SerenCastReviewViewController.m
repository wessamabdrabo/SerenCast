//
//  SerenCastReviewViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/11/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastReviewViewController.h"
#import "SerenCastPlayerViewController.h"
#import "SerenCastReviewSentViewController.h"
#import "SerenCastStatusViewController.h"

//#define LAST_TRACK_ID @"20"
#define PLAYER_MODE_FREE 0
#define PLAYER_MODE_ORDER 1
#define MAX_TRACK_COUNT 4 /* count for stopping condition. only 20 reviews needed.*/

/* Blocks */
typedef void (^OnSuccess)(void);
typedef void (^OnFailure)(NSString*);
typedef void (^OnSendSuccess)(void);
typedef void (^OnSendFailure)(NSString*);

@interface SerenCastReviewViewController (){
    bool submitSuccess;
    UIActivityIndicatorView *activityView;
    int playerMode;
    // UIView *activityViewBg;
}
@end

@implementation SerenCastReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithReviewedTrackIdAndMode:(NSString *) trackID mode:(int)mode
{
    self = [super init];
    if(self){
        playerMode = mode;
        self.reviewedTrackID = trackID;
        self.review = [[SerenCastReview alloc]init];
        self.review.cast_id = @"N/A";
        self.review.user_id = @"N/A";
        self.review.criteria1 = @"N/A";
        self.review.criteria2 = @"N/A";
        self.review.criteria3 = @"N/A";
        self.review.criteria4 = @"N/A";
        self.review.time = @"N/A";
        self.review.loc_longitude = @"N/A";
        self.review.loc_latitude = @"N/A";
        self.review.loc_subthroughfare = @"N/A";
        self.review.loc_throughfare = @"N/A";
        self.review.loc_postalcode = @"N/A";
        self.review.loc_adminarea = @"N/A";
        self.review.loc_country = @"N/A";
        self.review.loc_name = @"N/A";
        self.review.loc_region = @"N/A";
        self.review.loc_locality = @"N/A";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Review";
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    UIBarButtonItem *nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = nextBtnItem;
    
    /* Navigation styling */
    UIColor * navBarTintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:navBarTintColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GillSans-Light" size:24], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    submitSuccess = false;
    
    /* activity indicator */
    activityView = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [activityView hidesWhenStopped];
    [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
    //[self createActivityIndicator];
    
    /*sliders selectors */
    [self.q1Slider addTarget:self action:@selector(slider1ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.q2Slider addTarget:self action:@selector(slider2ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.q3Slider addTarget:self action:@selector(slider3ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.q4Slider addTarget:self action:@selector(slider4ValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.q1Label.text = [NSString stringWithFormat:@"%ld",lroundf(self.q1Slider.value)];
    self.q2Label.text = [NSString stringWithFormat:@"%ld",lroundf(self.q2Slider.value)];
    self.q3Label.text = [NSString stringWithFormat:@"%ld",lroundf(self.q3Slider.value)];
    self.q4Label.text = [NSString stringWithFormat:@"%ld",lroundf(self.q4Slider.value)];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)done:(id)sender{
    [self prepareData];
    [self startActivityIndicator];
    [self performSelectorInBackground:@selector(startProcessing) withObject:self];
}

//####################################
#pragma sliders
//####################################

- (void)slider1ValueChanged:(UISlider *)sender {
    self.q1Label.text = [NSString stringWithFormat:@"%ld",lroundf(sender.value)];
}
- (void)slider2ValueChanged:(UISlider *)sender {
    self.q2Label.text = [NSString stringWithFormat:@"%ld",lroundf(sender.value)];
}
- (void)slider3ValueChanged:(UISlider *)sender {
    self.q3Label.text = [NSString stringWithFormat:@"%ld",lroundf(sender.value)];
}
- (void)slider4ValueChanged:(UISlider *)sender {
    self.q4Label.text = [NSString stringWithFormat:@"%ld",lroundf(sender.value)];
}

//###############################
# pragma activity indicator
//###############################
/*-(void) createActivityIndicator{
 activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
 activityViewBg = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, activityView.bounds.size.width + 20, activityView.bounds.size.height + 20)];
 activityViewBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
 activityViewBg.clipsToBounds = YES;
 activityViewBg.layer.cornerRadius = 10.0;
 
 
 activityView.frame = CGRectMake(activityViewBg.center.x, activityViewBg.center.y, activityView.bounds.size.width, activityView.bounds.size.height);
 [activityViewBg addSubview:activityView];
 
 [self.view addSubview:activityViewBg];
 //[self.view bringSubviewToFront:activityViewBg];
 activityViewBg.hidden = YES;
 }*/
-(void)startActivityIndicator{
    // activityViewBg.hidden = NO;
    activityView.hidden = NO;
    [activityView startAnimating];
}
-(void)stopActivityIndicator{
    //activityViewBg.hidden = YES;
    activityView.hidden = YES;
    [activityView stopAnimating];
}


//###############################
# pragma data processing
//###############################
-(void) sendFavorites:(OnSendSuccess)sendSuccess failure:(OnSendFailure)sendFailure
{
    NSData *__jsonData;
    NSString *__jsonString;
    
    NSArray *keys = [NSArray arrayWithObjects:@"user_id",@"fav1_id",@"fav2_id",@"fav3_id",@"fav4_id",@"fav5_id",
                     @"fav6_id",@"fav7_id",@"fav8_id",@"fav9_id",@"fav10_id",@"fav11_id",@"fav12_id",@"fav13_id",@"fav14_id"
                     ,@"fav15_id",@"fav16_id",@"fav17_id",@"fav18_id",@"fav19_id",@"fav20_id",nil];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    NSString *castsFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
    NSMutableDictionary *dataList = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *podcastsList = [[NSArray alloc] initWithContentsOfFile:castsFilePath];
    
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    [objects addObject:[dataList objectForKey:@"userID"]];
    for(int i=0; i < 20/*MAX_TRACK_COUNT*/; i++){
        if(i < [podcastsList count]){
            NSDictionary *item = [podcastsList objectAtIndex:i];
            if([[item objectForKey:@"isFav"]boolValue]){
                [objects addObject:@"1"];
            }else{
                [objects addObject:@"0"];
            }
        }else [objects addObject:@"N/A"];
    }
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:jsonDictionary forKey:@"favorite"];
    
    if([NSJSONSerialization isValidJSONObject:params])
    {
        __jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        __jsonString = [[NSString alloc]initWithData:__jsonData encoding:NSUTF8StringEncoding];
    }
    
    // Be sure to properly escape your url string.
    NSURL * url = [NSURL URLWithString:@"http://shrouded-tor-1742.herokuapp.com/favorites"];
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
        sendFailure(@"Favorites submission failed. Check connection and try again.");
    }
    else
    {
        NSError *jsonParsingError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&jsonParsingError];
        sendSuccess();
    }
}

-(void)terminateExperiment{
    [self sendFavorites:^{
        /* on success */
        NSLog(@"Favorites sent successfully!");
        [self performSelectorOnMainThread:@selector(stopActivityIndicator) withObject:self waitUntilDone:false];
        SerenCastReviewSentViewController *reviewCompleteController = [[SerenCastReviewSentViewController alloc] init];
        [self.navigationController pushViewController:reviewCompleteController animated:YES];
    } failure:^(NSString *error) {
        NSLog(@"Favorites sending failed!!!");
        /* on failure */
        [self performSelectorOnMainThread:@selector(stopActivityIndicator) withObject:self waitUntilDone:false];
        SerenCastReviewSentViewController *reviewCompleteController = [[SerenCastReviewSentViewController alloc] init];
        [self.navigationController pushViewController:reviewCompleteController animated:YES];
    }];
}
-(void)startProcessing{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    NSMutableDictionary *dataList = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    [self save: ^(void){
        [self performSelectorOnMainThread:@selector(stopActivityIndicator) withObject:self waitUntilDone:false];
        
        NSString *castsFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
        NSMutableArray *castsList = [[NSMutableArray alloc] initWithContentsOfFile:castsFilePath];
        int ratedCount = [[dataList objectForKey:@"ratedCount"]intValue];
        
        /* Update rated count, used to check stopping condition (number of rated tracks = max tracks) */
        for(int i = 0; i < [castsList count]; i++){
            NSDictionary* item = [castsList objectAtIndex:i];
            bool isRated = [[item objectForKey:@"isPlayed"]boolValue];
            NSString* itemID = [item objectForKey:@"trackID"];
            /* if currently rated item is not rated before, increment count */
            NSLog(@"===================================");
            NSLog(@"itemID = %@", itemID);
            NSLog(@"reviewedTrackID = %@", self.reviewedTrackID);
            NSLog(@"isRated = %d", isRated);
            NSLog(@"===================================");
            if ([itemID isEqualToString:self.reviewedTrackID]) {
                if(!isRated){
                    /* rating new track, incerment rated count and save */
                    NSLog(@"INCREMENT RATED COUNT");
                    NSLog(@"===================================");
                    [dataList setValue:[NSNumber numberWithInteger:ratedCount+1] forKey:@"ratedCount"];
                    [dataList writeToFile:filePath atomically:NO];
                }
                break;
            }
        }
        /* now mark it as rated/played*/
        NSMutableDictionary *cast = [castsList objectAtIndex:[self.reviewedTrackID intValue]-1];
        [cast setValue:[NSNumber numberWithBool:YES] forKey:@"isPlayed"];
        [castsList writeToFile:castsFilePath atomically:NO];
        
        /* STOPPING CONDITION. VERY IMPORTANT. */
        /* User rated 20 DIFFERENT casts. End Expirement. */
        ratedCount = [[dataList objectForKey:@"ratedCount"]intValue]; /* reread updated value from plist*/
        NSLog(@"!!!ratedCount = %d!!!", ratedCount);
        if (ratedCount == MAX_TRACK_COUNT/*[self.reviewedTrackID isEqualToString:LAST_TRACK_ID] && playerMode != PLAYER_MODE_FREE*/) {
            /* set expdone in data plist to indicate we're going to final step */
            [dataList setValue:@"1" forKey:@"ExpDone"];
            [dataList writeToFile:filePath atomically: NO];
            
            /* cancel all notifications*/
            if([[[UIApplication sharedApplication] scheduledLocalNotifications] count] > 0){
                NSLog(@"cancel all local notificaions");
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
            }
            
            [self performSelectorOnMainThread:@selector(startActivityIndicator) withObject:self waitUntilDone:false];
            [self performSelectorInBackground:@selector(terminateExperiment) withObject:self];
        }
        else{ /* if not last track, save next track to plist and go back to player */
            /* Next track decided by mode*/
            NSString* nextTrackStrID = @"";
            if(playerMode == PLAYER_MODE_FREE){
                int lastPlayed = [[dataList objectForKey:@"CurrentAudioFileID"] integerValue];
                nextTrackStrID = [NSString stringWithFormat:@"%ld",(long)lastPlayed];
            }
            else{
                NSInteger nextTrackID = self.reviewedTrackID.integerValue + 1;
                nextTrackStrID = [NSString stringWithFormat:@"%ld",(long)nextTrackID];
                [dataList setValue:nextTrackStrID forKey:@"CurrentAudioFileID"];
                [dataList writeToFile:filePath atomically: NO];
            }
            /* go to status view before player */
            if([self.reviewedTrackID intValue]+1 == 3 || [self.reviewedTrackID intValue]+1 == 8 || [self.reviewedTrackID intValue]+1 == 13 || [self.reviewedTrackID intValue]+1 == 18){
                SerenCastStatusViewController *statusController = [[SerenCastStatusViewController alloc]initWithTrackID:nextTrackStrID];
                [self.navigationController pushViewController:statusController animated:YES];
            }else{
                /*SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc] initWithAudio:nextTrackStrID];
                 [self.navigationController pushViewController:playerController animated:YES];*/
                [self.navigationController popToRootViewControllerAnimated:YES];
                if([[self.navigationController topViewController]isKindOfClass:[SerenCastPlayerViewController class]]){
                    SerenCastPlayerViewController *player =(SerenCastPlayerViewController*) [self.navigationController topViewController];
                    if(player){
                        [player resetPlayer:nextTrackStrID playerMode:1]; /* always after review we go back to the ordered playlist */
                        NSLog(@"go to player. don't create a new one. just use the old");
                        [player.view setNeedsDisplay];
                    }
                }
            }
        }
    }failure:^(NSString* error){
        [self performSelectorOnMainThread:@selector(stopActivityIndicator) withObject:self waitUntilDone:false];
        
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
-(void) save:(OnSuccess)saveSuccess failure:(OnFailure)saveFailure
{
    NSData *__jsonData;
    NSString *__jsonString;
    
    NSArray *keys = [NSArray arrayWithObjects:@"cast_id",@"user_id",@"criteria1",@"criteria2",@"criteria3",@"criteria4",@"time",@"loc_longitude",@"loc_latitude",@"loc_subthroughfare",@"loc_throughfare",@"loc_postalcode",@"loc_adminarea",@"loc_country",@"loc_name",@"loc_region",@"loc_locality", nil];
    
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    [objects addObject:self.review.cast_id];
    [objects addObject:self.review.user_id];
    [objects addObject:self.review.criteria1];
    [objects addObject:self.review.criteria2];
    [objects addObject:self.review.criteria3];
    [objects addObject:self.review.criteria4];
    [objects addObject:self.review.time];
    [objects addObject:self.review.loc_longitude];
    [objects addObject:self.review.loc_latitude];
    [objects addObject:self.review.loc_subthroughfare];
    [objects addObject:self.review.loc_throughfare];
    [objects addObject:self.review.loc_postalcode];
    [objects addObject:self.review.loc_adminarea];
    [objects addObject:self.review.loc_country];
    [objects addObject:self.review.loc_name];
    [objects addObject:self.review.loc_region];
    [objects addObject:self.review.loc_locality];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:jsonDictionary forKey:@"review"];
    
    if([NSJSONSerialization isValidJSONObject:params])
    {
        __jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        __jsonString = [[NSString alloc]initWithData:__jsonData encoding:NSUTF8StringEncoding];
    }
    
    // Be sure to properly escape your url string.
    NSURL * url = [NSURL URLWithString:@"http://shrouded-tor-1742.herokuapp.com/reviews"];
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
        saveFailure(@"Review submission failed. Check connection and try again.");
    }
    else
    {
        NSError *jsonParsingError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&jsonParsingError];
        saveSuccess();
    }
}
-(NSMutableDictionary*)fetchItemFromList:(NSMutableArray*) list{
    if(!list || ![list count])
        return nil;
    for(int i=0; i<[list count];i++){
        NSMutableDictionary * item = [list objectAtIndex:i];
        if(item && [item count]){
            if([[item objectForKey:@"trackID"]isEqualToString:self.reviewedTrackID])
                return item;
        }
    }
    return nil;
}
-(void) prepareData{
    self.review.cast_id = self.reviewedTrackID;
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *datafilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:datafilePath];
    self.review.user_id = [dataDict objectForKey:@"userID"];
    
    self.review.criteria1 = [NSString stringWithFormat:@"%f", self.q1Slider.value];
    self.review.criteria2 = [NSString stringWithFormat:@"%f", self.q2Slider.value];
    self.review.criteria3 = [NSString stringWithFormat:@"%f", self.q3Slider.value];
    self.review.criteria4 = [NSString stringWithFormat:@"%f", self.q4Slider.value];
    
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-LocTime.plist"];
    
    NSMutableArray *locationsList = [NSMutableArray arrayWithContentsOfFile:filePath];
    //NSInteger item_id = [self.reviewedTrackID integerValue] - 1;
    if(locationsList && [locationsList count] != 0){
        //NSMutableDictionary* currentDict = [plistDict objectAtIndex:item_id];
        NSMutableDictionary* currentDict = [self fetchItemFromList:locationsList];
        if(currentDict){
            NSMutableDictionary* locDict = [currentDict objectForKey:@"Location"];
            if(locDict){
                self.review.loc_subthroughfare = [locDict objectForKey:@"subThoroughfare"]? [locDict objectForKey:@"subThoroughfare"] : @"N/A";
                self.review.loc_throughfare = [locDict objectForKey:@"thoroughfare"]?[locDict objectForKey:@"thoroughfare"]:@"N/A";
                self.review.loc_postalcode = [locDict objectForKey:@"postalCode"]?[locDict objectForKey:@"postalCode"]:@"N/A";
                self.review.loc_locality = [locDict objectForKey:@"locality"]?[locDict objectForKey:@"locality"]:@"N/A";
                self.review.loc_adminarea = [locDict objectForKey:@"adminArea"]? [locDict objectForKey:@"adminArea"]:@"N/A";
                self.review.loc_country = [locDict objectForKey:@"country"]?[locDict objectForKey:@"country"]:@"N/A";
                self.review.loc_name = [locDict objectForKey:@"name"]?[locDict objectForKey:@"name"]:@"N/A";
                self.review.loc_region = [locDict objectForKey:@"region"]?[locDict objectForKey:@"region"]:@"N/A";
                self.review.loc_longitude = [locDict objectForKey:@"longitude"]?[locDict objectForKey:@"longitude"]:@"N/A";
                self.review.loc_latitude = [locDict objectForKey:@"latitude"]?[locDict objectForKey:@"latitude"]:@"N/A";
                self.review.time = [currentDict objectForKey:@"Time"]?[currentDict objectForKey:@"Time"]:@"N/A";
            }else{
                self.review.loc_subthroughfare = @"N/A";
                self.review.loc_throughfare = @"N/A";
                self.review.loc_postalcode = @"N/A";
                self.review.loc_locality = @"N/A";
                self.review.loc_adminarea = @"N/A";
                self.review.loc_country = @"N/A";
                self.review.loc_name = @"N/A";
                self.review.loc_region = @"N/A";
                self.review.loc_longitude = @"N/A";
                self.review.loc_latitude = @"N/A";
                self.review.time = @"N/A";
            }
        }else{
            self.review.loc_subthroughfare = @"N/A";
            self.review.loc_throughfare = @"N/A";
            self.review.loc_postalcode = @"N/A";
            self.review.loc_locality = @"N/A";
            self.review.loc_adminarea = @"N/A";
            self.review.loc_country = @"N/A";
            self.review.loc_name = @"N/A";
            self.review.loc_region = @"N/A";
            self.review.loc_longitude = @"N/A";
            self.review.loc_latitude = @"N/A";
            self.review.time = @"N/A";
        }
    }
}
@end
