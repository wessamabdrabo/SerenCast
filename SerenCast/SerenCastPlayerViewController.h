//
//  SerenCastPlayerViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/11/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SerenCastPlayerViewController : UIViewController <AVAudioPlayerDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *discoverBtnView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *discoverBtn;
@property (weak, nonatomic) IBOutlet UIButton *togglePlayBtn;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property(nonatomic,strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, strong) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (strong, nonatomic) NSString* currentTrackID;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)toggleFavsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;



- (id) initWithAudio:(NSString*) audioFileID;
- (IBAction)playBtnAction:(id)sender;
- (IBAction)stopBtnAction:(id)sender;
- (IBAction)pauseBtnAction:(id)sender;
- (IBAction)currentTimeSliderValueChanged:(id)sender;
- (IBAction)currentTimeSliderTouchupInside:(id)sender;
-(void) resetPlayer:(NSString*)trackID playerMode:(int)playerMode;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UIButton *toggleFavsBtn;


@end
