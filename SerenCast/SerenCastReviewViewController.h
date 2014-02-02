//
//  SerenCastReviewViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/11/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerenCastReview.h"

@interface SerenCastReviewViewController : UIViewController
@property (strong, nonatomic) NSString *reviewedTrackID;
@property (weak, nonatomic) IBOutlet UISlider *q1Slider;
@property (weak, nonatomic) IBOutlet UISlider *q2Slider;
@property (weak, nonatomic) IBOutlet UISlider *q3Slider;
@property (weak, nonatomic) IBOutlet UISlider *q4Slider;
@property (strong, nonatomic) SerenCastReview *review;
-(id) initWithReviewedTrackID:(NSString *) trackID;

@property (weak, nonatomic) IBOutlet UILabel *q1Label;
@property (weak, nonatomic) IBOutlet UILabel *q2Label;
@property (weak, nonatomic) IBOutlet UILabel *q4Label;
@property (weak, nonatomic) IBOutlet UILabel *q3Label;

@end
