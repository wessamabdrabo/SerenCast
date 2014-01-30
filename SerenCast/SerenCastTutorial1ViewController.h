//
//  SerenCastTutorial1ViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/29/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerenCastTutorial1ViewController : UIViewController
@property(nonatomic, strong) NSString* email;
- (IBAction)startProfileBtnAction:(id)sender;
-(id)initWithEmail:(NSString*) email;
@end
