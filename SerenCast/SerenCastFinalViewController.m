//
//  SerenCastFinalViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/18/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastFinalViewController.h"
#import "SerenCastReviewSentViewController.h"

@interface SerenCastFinalViewController ()

@end

@implementation SerenCastFinalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Thank You";
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendBtnAction:(id)sender {
    // Email Subject
    NSString *emailTitle = @"SerenCast Review";
    // Email Content
    NSString *messageBody = @"The review is final.";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"wessam.abdrabo@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *reviewsFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Reviews.plist"];
    NSString *locTimeFilePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-LocTime.plist"];

    [mc addAttachmentData:[NSData dataWithContentsOfFile:reviewsFilePath] mimeType:@"plist" fileName:@"SerenCast-Reviews"];
    [mc addAttachmentData:[NSData dataWithContentsOfFile:locTimeFilePath] mimeType:@"plist" fileName:@"SerenCast-LocTime"];

    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if(result == MFMailComposeResultSent){
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docStorePath = [searchPaths objectAtIndex:0];
        NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Data.plist"];
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [plistDict setValue:@"1" forKey:@"ReviewIsSent"];
        [plistDict writeToFile:filePath atomically:NO];
        
        SerenCastReviewSentViewController *reviewCompleteController = [[SerenCastReviewSentViewController alloc] init];
        [self.navigationController pushViewController:reviewCompleteController animated:YES];
    }
}
@end
