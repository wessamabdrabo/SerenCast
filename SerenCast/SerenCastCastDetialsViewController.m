//
//  SerenCastCastDetialsViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 2/6/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastCastDetialsViewController.h"

@interface SerenCastCastDetialsViewController ()

@end

@implementation SerenCastCastDetialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithCastID:(NSString*)castID{
    self = [super init];
    if (self) {
        self.castID = castID; /* the actual cast id not index in plist/array */
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustViewHeight];
    
    self.navigationItem.title = @"";
    self.navigationItem.hidesBackButton = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    /* set up fields */
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
    NSMutableArray* castsList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    NSInteger castIndex = [self.castID integerValue] - 1; /* -1 to get index in array from actual track id */
    if(castsList && castIndex < [castsList count]){
        NSDictionary * cast = [castsList objectAtIndex:castIndex];
        if(cast && [cast count]){
            self.castTitleLabel.text = [cast objectForKey:@"title"];
            self.castImageView.image = [UIImage imageNamed:[cast objectForKey:@"image"]];
            self.castDescriptionTextView.text = [cast objectForKey:@"description"];
            self.castDurationLabel.text = [cast objectForKey:@"duration"];
            self.castSourceLabel.text = [cast objectForKey:@"provider"];
            if([[cast objectForKey:@"isFav"]boolValue])
                [self.favoriteBtn setImage:[UIImage imageNamed:@"favicon-selected"] forState:UIControlStateNormal];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)favoriteBtnAction:(id)sender {
}
- (void)adjustViewHeight
{
    CGFloat maxHeight = [[UIScreen mainScreen]bounds].size.height - self.bgView.frame.origin.y - self.tabBarController.tabBar.frame.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.textViewHeightConstraint.constant = maxHeight;
        self.bgViewHeightConstraint.constant = maxHeight;
        [self.view needsUpdateConstraints];
    }];
}
@end
