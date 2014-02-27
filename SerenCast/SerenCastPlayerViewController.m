//
//  SerenCastPlayerViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/11/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastPlayerViewController.h"
#import "SerenCastReviewViewController.h"
#import "SerenCastTutorial3ViewController.h"
#import "SerenCastNotificationsManager.h"

#define PLAYER_MODE_FREE 0
#define PLAYER_MODE_ORDER 1
//#define CAST_DEFAULT_DATE @"Jan 25, 2011, 12:00:00 PM"

@interface SerenCastPlayerViewController ()

@end

@implementation SerenCastPlayerViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString * castTitle;
    int mode;
    NSString* playListTrackID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id) initWithAudio:(NSString*) audioFileID
{
    self = [super init];
    
    if(self){
        self.currentTrackID = audioFileID;
        locationManager = [[CLLocationManager alloc] init];
        geocoder = [[CLGeocoder alloc] init];
        castTitle = [[NSString alloc]init];
        mode = PLAYER_MODE_ORDER;
        playListTrackID = [[NSString alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.navigationItem.title = @"Discover";
    self.subtitleLabel.text = [NSString stringWithFormat:@"%@ of 20", self.currentTrackID];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    /* help button */
    /* UIImage *notificationImg = [UIImage imageNamed:@"helpfull"];
     UIButton *notificationsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [notificationsBtn setBackgroundImage:notificationImg forState:UIControlStateNormal];
     [notificationsBtn setTitle:@"" forState:UIControlStateNormal];
     [notificationsBtn addTarget:self action:@selector(openHelp:) forControlEvents:UIControlEventTouchDown];
     UIBarButtonItem *notificationsBtnItem =[[UIBarButtonItem alloc] initWithCustomView:notificationsBtn];
     notificationsBtn.frame = (CGRect) {
     .size.width = 30,
     .size.height = 30,
     };
     self.navigationItem.rightBarButtonItem = notificationsBtnItem;*/
    
    /* Navigation styling */
    UIColor * navBarTintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:navBarTintColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GillSans-Light" size:24], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    //set location manager
    locationManager.delegate = self;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.currentTrackID withExtension:@"mp3"];
    NSLog(@"url = %@", url);
    NSError *error;
    
    // Set AVAudioSession
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    // Change the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:url error:&error];
    if(error)
        NSLog(@"error initializing player");
    
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    
    self.currentTimeSlider.minimumValue = 0.0f;
    self.currentTimeSlider.maximumValue = self.audioPlayer.duration;
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
    NSArray *plist = [[NSArray alloc] initWithContentsOfFile:filePath];
    NSDictionary *plistItem = [plist objectAtIndex:[self.currentTrackID intValue]-1];
    NSString *currentTrackTitle = [plistItem objectForKey:@"title"];
    
    self.titleLabel.text = currentTrackTitle;
    castTitle = currentTrackTitle;
    
    /* set fav icon */
    if([[plistItem objectForKey:@"isFav"] boolValue])
        [self.toggleFavsBtn setImage:[UIImage imageNamed:@"favicon-selected"] forState:UIControlStateNormal];
    else [self.toggleFavsBtn setImage:[UIImage imageNamed:@"favicon"] forState:UIControlStateNormal];
    //[self.toggleFavsBtn setImage:[UIImage imageNamed:@"favicon-selected"] forState:UIControlStateNormal];
    
    [self updateDisplay];
}

-(void) resetPlayer:(NSString*)trackID playerMode:(int)playerMode{
    
    NSLog(@"[resetPlayer] trackID = %@, mode = %d", trackID,playerMode);
    
    mode = playerMode;
    
    if(mode == PLAYER_MODE_FREE){
        playListTrackID = trackID;
        [self.discoverBtn setHidden:NO];
        [self.discoverBtnView setHidden:NO];
    }
    else if(mode == PLAYER_MODE_ORDER){
        self.currentTrackID = trackID;
        [self.discoverBtn setHidden:YES];
        [self.discoverBtnView setHidden:YES];
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:trackID withExtension:@"mp3"];
    NSLog(@"Played file url = %@", url);
    NSError *error;
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:url error:&error];
    self.audioPlayer.delegate = self;
    
    if(error)
        NSLog(@"error initializing player");
    
    self.currentTimeSlider.minimumValue = 0.0f;
    self.currentTimeSlider.maximumValue = self.audioPlayer.duration;
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
    NSArray *plist = [[NSArray alloc] initWithContentsOfFile:filePath];
    NSDictionary *plistItem = [plist objectAtIndex:[trackID intValue]-1];
    NSString *currentTrackTitle = [plistItem objectForKey:@"title"];
    
    self.titleLabel.text = currentTrackTitle;
    castTitle = currentTrackTitle;
    /* set fav icon */
    if([[plistItem objectForKey:@"isFav"] boolValue])
        [self.toggleFavsBtn setImage:[UIImage imageNamed:@"favicon-selected"] forState:UIControlStateNormal];
    else [self.toggleFavsBtn setImage:[UIImage imageNamed:@"favicon"] forState:UIControlStateNormal];
    
    /* set title according to mode */
    if(playerMode == PLAYER_MODE_ORDER) {
        self.navigationItem.title = @"Discover";
        self.subtitleLabel.text = [NSString stringWithFormat:@"%@ of 20", trackID];
    }else if (playerMode == PLAYER_MODE_FREE){
        self.navigationItem.title = currentTrackTitle;
        self.subtitleLabel.text = @"";
    }
    
    //self.navigationItem.title = [NSString stringWithFormat:@"%@ of 20", trackID];
    
    if(playerMode ==PLAYER_MODE_FREE){
        //[self stopBtnAction:self.playBtn];
        //[self playBtnAction:self.playBtn];
        [self stop];
        //[self.togglePlayBtn setTitle:@"Pause" forState:UIControlStateNormal];
        [self.togglePlayBtn setImage:[UIImage imageNamed:@"pause-icon"] forState:UIControlStateNormal];
        [self play];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) checkTodayCasts{
    NSLog(@"#######[Check Today's Casts]");
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [dateFormat stringFromDate:today];
    
    NSLog(@"today's date: %@", today);
    NSLog(@"today str only date = %@", todayStr);
    if(plist && [plist count] > 0){
        NSDate* lastCastDate = [plist objectForKey:@"lastPlayedDate"];
        //NSString* lastCastDateAllStr = [NSString stringWithFormat:@"%@", lastCastDateStr];
        NSString* lastCastDateStr = [dateFormat stringFromDate:lastCastDate];
        NSInteger numberOfCastsPlayed = [[plist objectForKey:@"numCastsPlayedToday"]integerValue];
        NSLog(@"Last cast played at %@", [lastCastDate description]);
        NSLog(@"last cast date str only date = %@", lastCastDateStr);
        NSLog(@"Number of casts played today: %d", numberOfCastsPlayed);
        /* first time to set */
        /*if([lastCastDateAllStr isEqualToString:CAST_DEFAULT_DATE]) {
         NSLog(@"first time to set date to %@", today);
         [plist setValue:today forKey:@"lastPlayedDate"];
         [plist writeToFile:filePath atomically:NO];
         return YES;
         }
         else*/ if([todayStr isEqualToString:lastCastDateStr]){
             NSString * lastCastPlayed = [plist objectForKey:@"lastCastPlayedToday"];
             if(numberOfCastsPlayed >= 2 && ![lastCastPlayed isEqualToString:self.currentTrackID]){ /* if today and number of casts exceeded*/
                 NSLog(@"Number of casts exceeded!!!!!");
                 return NO;
             }
         }else{ /* if no today, reset everything*/
             NSLog(@"resetting date to today");
             [plist setValue:today forKey:@"lastPlayedDate"];
             [plist setValue:0 forKey:@"numCastsPlayedToday"];
             [plist setValue:@"0" forKey:@"lastCastPlayedToday"];
             [plist writeToFile:filePath atomically:NO];
             return YES;
         }
    }
    return YES;
}
#pragma mark - Player Control actions
- (IBAction)playBtnAction:(id)sender {
    NSLog(@"playBtnClicked...");
    
    if([self.audioPlayer isPlaying]){  /* pause */
        NSLog(@"pausing");
        //[self.togglePlayBtn setTitle:@"Play" forState:UIControlStateNormal];
        [self.togglePlayBtn setImage:[UIImage imageNamed:@"play-icon"] forState:UIControlStateNormal];

        [self.audioPlayer pause];
        [self stopTimer];
        [self updateDisplay];
    }
    else{ /*play */
        [self play];
    }
}
-(void) play{
    BOOL doPlay = [self checkTodayCasts];
    if(doPlay){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        //[self.togglePlayBtn setTitle:@"Pause" forState:UIControlStateNormal];
        [self.togglePlayBtn setImage:[UIImage imageNamed:@"pause-icon"] forState:UIControlStateNormal];
        [self.audioPlayer play];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Podcasts Per Day Exceeded!"
                                                        message: @"You have reached the limit of 2 podcasts per day. Please resume listening to casts tomorrow."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void) stop{
    [self.audioPlayer stop];
    [self stopTimer];
    self.audioPlayer.currentTime = 0;
    [self.audioPlayer prepareToPlay];
    [self updateDisplay];
}
- (IBAction)stopBtnAction:(id)sender {
    //[self.togglePlayBtn setTitle:@"Play" forState:UIControlStateNormal];
    [self.togglePlayBtn setImage:[UIImage imageNamed:@"play-icon"] forState:UIControlStateNormal];
    [self stop];
}

-(void)switchModeToDiscover
{
    [self resetPlayer:self.currentTrackID playerMode:1];
    //[self.togglePlayBtn setTitle:@"Play" forState:UIControlStateNormal];
    [self.togglePlayBtn setImage:[UIImage imageNamed:@"play-icon"] forState:UIControlStateNormal];
    [self.discoverBtn setHidden:YES];
    [self.discoverBtnView setHidden:YES];
    //[self.view setNeedsDisplay];
}
- (IBAction)pauseBtnAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Switch Mode"
                                                    message: @"You are about to switch back to Discover mode."
                                                   delegate: nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 2;
    alert.delegate = self;
    [alert show];
    
    /*[self.audioPlayer pause];
     [self stopTimer];
     [self updateDisplay];*/
}

#pragma mark - Current time slider Update
- (IBAction)currentTimeSliderValueChanged:(id)sender {
    if(self.timer)
        [self stopTimer];
    [self updateSliderLabels];
}

- (IBAction)currentTimeSliderTouchupInside:(id)sender {
    [self.audioPlayer stop];
    self.audioPlayer.currentTime = self.currentTimeSlider.value;
    [self.audioPlayer prepareToPlay];
    [self playBtnAction:self];
}

#pragma mark - Display Update
- (void)updateDisplay
{
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
    
    NSString* currentTimeString = [NSString stringWithFormat:@"%.02f", currentTime];
    
    self.currentTimeSlider.value = currentTime;
    [self updateSliderLabels];
}

- (void)updateSliderLabels
{
    NSTimeInterval currentTime = self.currentTimeSlider.value;
    CGFloat currentTimeInMins = currentTime / 60;
    NSString* currentTimeString = [NSString stringWithFormat:@"%.02f", currentTimeInMins];
    self.elapsedTimeLabel.text =  currentTimeString;
    CGFloat timeInMins = (self.audioPlayer.duration - currentTime) / 60;
    self.remainingTimeLabel.text = [NSString stringWithFormat:@"- %.02f", timeInMins];
}

#pragma mark - Timer
- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self updateDisplay];
}

/* increment number of casts played today by 1 and save to file */
-(void) updateNumberOfCastsPlayed{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSString* lastCastPlayed = [plist objectForKey:@"lastCastPlayedToday"];
    NSString *  trackID = mode == PLAYER_MODE_ORDER ? self.currentTrackID : playListTrackID;
    if(![trackID isEqualToString:lastCastPlayed]){
        NSLog(@"listened to a new track today. Increment!");
        NSNumber *numberOfCastsPlayed = [NSNumber numberWithInteger:[[plist objectForKey:@"numCastsPlayedToday"]integerValue]+1];
        [plist setValue:numberOfCastsPlayed forKey:@"numCastsPlayedToday"];
        [plist setValue:trackID forKey:@"lastCastPlayedToday"];
        [plist writeToFile:filePath atomically:NO];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //[self.togglePlayBtn setTitle:@"Play" forState:UIControlStateNormal];
    [self.togglePlayBtn setImage:[UIImage imageNamed:@"play-icon"] forState:UIControlStateNormal];
    [self stopTimer];
    [self updateDisplay];
    [self updateNumberOfCastsPlayed];
    [self getCurrentLocation]; //update location manager
    
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
        // Schedule the review notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:2.0];
        NSLog(@"Fire date %@", localNotification.fireDate);
        localNotification.alertBody = [NSString stringWithFormat:@"We hope you enjoyed '%@'. Rate it and tell us what you think.", castTitle?castTitle : @""];
        localNotification.alertAction = @"Rating";
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSString* body = [NSString stringWithFormat:@"%@", localNotification.alertBody];
        NSDate* firedDate = localNotification.fireDate;
        
        [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:@"1"];
        /* write notification to plist */
        SerenCastNotificationsManager *notificationsManager = [SerenCastNotificationsManager sharedInstance];
        [notificationsManager addToList:body notificationFiredDate:firedDate];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Rating"
                                                    message: @"Please take a minute to give us feedback about this cast before proceeding to the next one."
                                                   delegate: nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Rate", nil];
    alert.tag = 1;
    alert.delegate = self;
    [alert show];
}

#pragma mark - Alert Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /* clicked ok on either rating alert or switch mode alert*/
    
    if (buttonIndex == 1 && alertView.tag == 1) /* rating alert */
    { //review
        self.audioPlayer = nil;
        self.timer = nil;
        NSString* track = (mode == PLAYER_MODE_FREE) ? playListTrackID :self.currentTrackID;
        
        //rating first track. Show tutorial.
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docStorePath = [searchPaths objectAtIndex:0];
        NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
        NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        if([[plist objectForKey:@"ratedCount"]intValue] == 0 /*&& mode != PLAYER_MODE_FREE*/){
            SerenCastTutorial3ViewController *tutorialController = [[SerenCastTutorial3ViewController alloc]initWithTrackIDAndMode:track trackTitle:castTitle mode:mode];
            [self.navigationController pushViewController:tutorialController animated:YES];
        }else{
            NSLog(@"###reviewing track #: %@", track);
            SerenCastReviewViewController * reviewViewController = [[SerenCastReviewViewController alloc]initWithReviewedTrackAndMode:track trackTitle:castTitle mode:mode];
            [self.navigationController pushViewController:reviewViewController animated:YES];
        }
    }
    else if(buttonIndex == 1 && alertView.tag == 2){ /* switch mode alert */
        [self switchModeToDiscover];
    }
    
    /* do some resetting */
    if(mode == PLAYER_MODE_FREE){
        playListTrackID = nil;
        mode = PLAYER_MODE_ORDER;
    }
}


#pragma toggle favs button action
- (IBAction)toggleFavsAction:(id)sender {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *castsFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
    NSMutableArray *castsList = [[NSMutableArray alloc] initWithContentsOfFile:castsFilePath];
    int favTrackID = mode == PLAYER_MODE_ORDER ? [self.currentTrackID intValue] : [playListTrackID intValue];
    NSMutableDictionary *cast = [castsList objectAtIndex:favTrackID-1];
    /* if not already a favorite */
    if(![[cast objectForKey:@"isFav"]boolValue]){
        [cast setValue:[NSNumber numberWithBool:YES] forKey:@"isFav"];
        //TODO: change icon to selected
        [self.toggleFavsBtn setImage:[UIImage imageNamed:@"favicon-selected"] forState:UIControlStateNormal];
        
    }
    else{
        [cast setValue:[NSNumber numberWithBool:NO] forKey:@"isFav"];
        //TODO: set icon to not fav
        [self.toggleFavsBtn setImage:[UIImage imageNamed:@"favicon"] forState:UIControlStateNormal];
        
    }
    
    [castsList writeToFile:castsFilePath atomically:NO];
}

#pragma location
-(void) getCurrentLocation{
    if(!locationManager){
        NSLog(@"getCurrentLocation: no location manager!");
        return;
    }
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-LocTime.plist"];
    
    NSMutableArray *plistDict = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    NSMutableDictionary *currentDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *currentLocDict = [[NSMutableDictionary alloc]init];
    NSString *currentTime = [NSString stringWithFormat:@"%@",[[NSDate alloc] init]];
    
    if (currentLocation != nil) {
        NSString* longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString* latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        [currentLocDict setValue:longitude forKey:@"longitude"];
        [currentLocDict setValue:latitude forKey:@"latitude"];
    }
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            [currentLocDict setValue:placemark.subThoroughfare forKey:@"subThoroughfare"];
            [currentLocDict setValue:placemark.thoroughfare forKey:@"thoroughfare"];
            [currentLocDict setValue:placemark.postalCode forKey:@"postalCode"];
            [currentLocDict setValue:placemark.locality forKey:@"locality"];
            [currentLocDict setValue:placemark.administrativeArea forKey:@"adminArea"];
            [currentLocDict setValue:placemark.country forKey:@"country"];
            [currentLocDict setValue:placemark.name forKey:@"name"];
            [currentLocDict setValue:placemark.region forKey:@"region"];
            
            //write location and time to plist
            [currentDict setValue:self.currentTrackID forKey:@"trackID"];
            [currentDict setValue:currentLocDict forKey:@"Location"];
            [currentDict setValue:currentTime forKey:@"Time"];
            [plistDict addObject:currentDict];
            [plistDict writeToFile:filePath atomically:YES];
            NSLog(@"location data is written to file!");
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    NSLog(@"location update is paused!!");
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location manager failed with error %@", error.debugDescription);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Problem"
                                                    message: @"Your location can not be detected. Please reset your location settings."
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

@end
