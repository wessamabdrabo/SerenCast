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

#define LAST_TRACK_ID @"20"

@interface SerenCastReviewViewController ()

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
-(id) initWithReviewedTrackID:(NSString *) trackID
{
    self = [super init];
    if(self){
        NSLog(@"initWithTrackID");
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
        }
        else
        {
            NSError *jsonParsingError = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&jsonParsingError];
        }
}
-(void) prepareData{
    self.review.cast_id = self.reviewedTrackID;
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *datafilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:datafilePath];
    self.review.user_id = [dataDict objectForKey:@"userID"]; //TODO: get it from plist
    
    self.review.criteria1 = [NSString stringWithFormat:@"%f", self.q1Slider.value];
    self.review.criteria2 = [NSString stringWithFormat:@"%f", self.q2Slider.value];
    self.review.criteria3 = [NSString stringWithFormat:@"%f", self.q3Slider.value];
    self.review.criteria4 = [NSString stringWithFormat:@"%f", self.q4Slider.value];
    
    
   
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-LocTime.plist"];
    
    NSMutableArray *plistDict = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    NSInteger item_id = [self.reviewedTrackID integerValue] - 1;
    if(plistDict && plistDict.count != 0){
        NSMutableDictionary* currentDict = [plistDict objectAtIndex:item_id];
        NSMutableDictionary* locDict = [currentDict objectForKey:@"Location"];
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
    }
}
-(void)done:(id)sender{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    NSMutableDictionary *dataList = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    //write review to plist
   /* NSString *reviewsFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Reviews.plist"];
    NSString *q1 = [NSString stringWithFormat:@"%@,%f",self.reviewedTrackID, self.q1Slider.value];
    NSString *q2 = [NSString stringWithFormat:@"%@,%f",q1,self.q2Slider.value];
    NSString *q3 = [NSString stringWithFormat:@"%@,%f",q2,self.q3Slider.value];
    NSString *q4 = [NSString stringWithFormat:@"%@,%f",q3,self.q4Slider.value];
    NSMutableDictionary *reviewsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:reviewsFilePath];
    NSLog(@"*******Writing review: %@, to %@", q4, reviewsFilePath);
    [reviewsDict setValue:q4 forKey:self.reviewedTrackID];
    [reviewsDict writeToFile:reviewsFilePath atomically:NO];*/
    [self prepareData];
    [self save];
    
    
    /* if last track go to final step view */
    if ([self.reviewedTrackID isEqualToString:LAST_TRACK_ID]) {
        /* set expdone in data plist to indicate we're going to final step */
        [dataList setValue:@"1" forKey:@"ExpDone"];
        [dataList writeToFile:filePath atomically: NO];
        
        /*SerenCastFinalViewController  *finalController = [[SerenCastFinalViewController alloc] init];
        [self.navigationController pushViewController:finalController animated:NO];*/
        SerenCastReviewSentViewController *reviewCompleteController = [[SerenCastReviewSentViewController alloc] init];
        [self.navigationController pushViewController:reviewCompleteController animated:YES];
        
    }
    
    else{ /* if not last track, save next track to plist and go back to player */
        
        NSInteger nextTrackID = self.reviewedTrackID.integerValue + 1;
        NSString* nextTrackStrID = [NSString stringWithFormat:@"%ld",(long)nextTrackID];
        [dataList setValue:nextTrackStrID forKey:@"CurrentAudioFileID"];
        [dataList writeToFile:filePath atomically: NO];
        
        /* go to status view before player */
        if([self.reviewedTrackID intValue]+1 == 3 || [self.reviewedTrackID intValue]+1 == 8 || [self.reviewedTrackID intValue]+1 == 13 || [self.reviewedTrackID intValue]+1 == 18){
            SerenCastStatusViewController *statusController = [[SerenCastStatusViewController alloc]initWithTrackID:nextTrackStrID];
            [self.navigationController pushViewController:statusController animated:YES];
        }else{
            SerenCastPlayerViewController *playerController = [[SerenCastPlayerViewController alloc] initWithAudio:nextTrackStrID];
            [self.navigationController pushViewController:playerController animated:YES];
        }
    }
}
@end
