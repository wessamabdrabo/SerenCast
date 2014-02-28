//
//  SerenCastCastDetialsViewController.h
//  SerenCast
//
//  Created by Wessam Abdrabo on 2/6/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerenCastCastDetialsViewController : UIViewController
@property(nonatomic,strong) NSString* castID;
-(id) initWithCastID:(NSString*)castID;
@property (weak, nonatomic) IBOutlet UIImageView *castImageView;
@property (weak, nonatomic) IBOutlet UILabel *castSourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *castDurationLabel;
@property (weak, nonatomic) IBOutlet UITextView *castDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *castTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
- (IBAction)favoriteBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
