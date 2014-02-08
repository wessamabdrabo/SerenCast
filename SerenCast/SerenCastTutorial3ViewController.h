//
//  SerenCastTutorial3ViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerenCastTutorial3ViewController : UIViewController
@property(nonatomic, strong)NSString* trackID;
- (IBAction)proceedAction:(id)sender;
-(id) initWithTrackIDAndMode:(NSString*) trackID :(int)playerMode;
@end
