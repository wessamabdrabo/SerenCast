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


@interface SerenCastPlayerViewController ()

@end

@implementation SerenCastPlayerViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
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
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ of 20", self.currentTrackID];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    /* Navigation styling */
    UIColor * navBarTintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:navBarTintColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GillSans-Light" size:24], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.currentTrackID withExtension:@"mp3"];
    NSLog(@"url = %@", url);
    NSError *error;
   
    //set location manager
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SerenCast-Casts" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSString *currentTrackTitle = [plistDict objectForKey:self.currentTrackID];
    
    self.titleLabel.text = currentTrackTitle;
    
    [self updateDisplay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Player Control actions

- (IBAction)playBtnAction:(id)sender {
     self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [self.audioPlayer play];
}

- (IBAction)stopBtnAction:(id)sender {
    [self.audioPlayer stop];
    [self stopTimer];
    self.audioPlayer.currentTime = 0;
    [self.audioPlayer prepareToPlay];
    [self updateDisplay];
}
- (IBAction)pauseBtnAction:(id)sender {
    [self.audioPlayer pause];
    [self stopTimer];
    [self updateDisplay];
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

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopTimer];
    [self updateDisplay];
    [self getCurrentLocation]; //update location manager
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Rating"
                                                    message: @"Please take a minute to give us feedback about this cast before proceeding to the next one."
                                                   delegate: nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Rate", nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark - Alert Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) { //review
        self.audioPlayer = nil;
        self.timer = nil;
        
        //rating first track. Show tutorial.
        if([self.currentTrackID isEqualToString:@"1"]){
            SerenCastTutorial3ViewController *tutorialController = [[SerenCastTutorial3ViewController alloc]init];
            [self.navigationController pushViewController:tutorialController animated:YES];
        }else{
            SerenCastReviewViewController * reviewViewController = [[SerenCastReviewViewController alloc]initWithReviewedTrackID:self.currentTrackID];
            [self.navigationController pushViewController:reviewViewController animated:YES];
        }
    }
}

#pragma location
-(void) getCurrentLocation{
    if(!locationManager)
        return;
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
            [currentDict setValue:self.currentTrackID forKey:@"Id"];
            [currentDict setValue:currentLocDict forKey:@"Location"];
            [currentDict setValue:currentTime forKey:@"Time"];
            [plistDict addObject:currentDict];
            [plistDict writeToFile:filePath atomically:YES];
            NSLog(@"location data is written to file!!!!!!!!!!!!!!!");
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
  
}

@end
