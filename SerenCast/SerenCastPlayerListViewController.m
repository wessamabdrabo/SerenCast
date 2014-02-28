//
//  SerenCastPlayerListViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/31/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastPlayerListViewController.h"
#import "SerenCastPlayerListCell.h"
#import "SerenCastPlayerViewController.h"
#import "SerenCastReviewViewController.h"
#import "SerenCastCastDetialsViewController.h"

@interface SerenCastPlayerListViewController (){
    NSMutableArray *podcastsList;
    NSMutableArray *podcastsFavsList;
    NSMutableArray *podcastsPlayedList;
    bool filterFavs;
    bool filterPlayed;
}
@end

@implementation SerenCastPlayerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        podcastsList = [[NSMutableArray alloc]init];
        filterFavs = false;
        filterPlayed = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustHeightOfTableview];
    
    self.navigationItem.title = @"Podcasts";
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
    podcastsList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    podcastsFavsList = [[NSMutableArray alloc]init];
    podcastsPlayedList = [[NSMutableArray alloc]init];
    for(int i=0; i<podcastsList.count; i++){
        NSDictionary *item = [podcastsList objectAtIndex:i];
        if([[item objectForKey:@"isFav"]boolValue]){
            [podcastsFavsList addObject:item];
        }
        if([[item objectForKey:@"isPlayed"]boolValue]){
            [podcastsPlayedList addObject:item];
        }
    }
    filterFavs = false;
    filterPlayed = false;
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.segmentedControl addTarget:self action:@selector(listUpdate:) forControlEvents:UIControlEventValueChanged];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docStorePath = [searchPaths objectAtIndex:0];
    NSString *filePath = [docStorePath stringByAppendingPathComponent:@"SerenCast-Casts.plist"];
    NSMutableArray* newplayerList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    [self resetLists];
    for(int i=0; i<newplayerList.count; i++){
        NSDictionary *item = [newplayerList objectAtIndex:i];
        if([[item objectForKey:@"isFav"]boolValue]){
            //NSLog(@"[ViewWillAppear] Add to favs index %d, item %@", i, item);
            [podcastsFavsList addObject:item];
        }
        if([[item objectForKey:@"isPlayed"]boolValue]){
            //NSLog(@"[ViewWillAppear] add to played %d, item %@", i, item);
            [podcastsPlayedList addObject:item];
        }
    }
}
-(void) resetLists{
    if (podcastsPlayedList.count) {
        for(int i=podcastsPlayedList.count-1; i>=0; i--)
            [podcastsPlayedList removeObjectAtIndex:i];
    }
    if(podcastsFavsList.count){
        for(int i=podcastsFavsList.count-1; i>=0; i--){
            [podcastsFavsList removeObjectAtIndex:i];
        }
    }
}
-(void)listUpdate:(UISegmentedControl *)sender {
    int value = sender.selectedSegmentIndex;
    
    if(value == 1){ /*show favs */
        filterFavs = true;
        filterPlayed = false;
    }
    else if(value == 2){
        filterPlayed = true;
        filterFavs = false;
    }else{
        filterFavs = false;
        filterPlayed = false;
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//######################################
#pragma mark - Table view data source
//######################################

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(filterFavs)
        return podcastsFavsList.count;
    if(filterPlayed)
        return podcastsPlayedList.count;
    return podcastsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"SerenCastPlayerListCell";
    SerenCastPlayerListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SerenCastPlayerListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSInteger row = [indexPath row];
    NSMutableArray *list = [[NSMutableArray alloc]init];
    if(filterFavs)
        list = podcastsFavsList;
    else if(filterPlayed)
        list = podcastsPlayedList;
    else
        list = podcastsList;
    NSMutableDictionary* item = [list objectAtIndex:row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = [item objectForKey:@"title"];
    cell.durationLabel.text = [item objectForKey:@"duration"];
    cell.descriptionLabel.text = [item objectForKey:@"description"];
    [cell.playBtn setTag:row];
    [cell.infoBtn setTag:row];
    [cell.playBtn  addTarget:self action:@selector(playCast:) forControlEvents:UIControlEventTouchDown];
    [cell.infoBtn  addTarget:self action:@selector(openCastDetails:) forControlEvents:UIControlEventTouchDown];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /*[cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"image"]]];*/ /* need thumbnail */
    
    return cell;
}
-(BOOL) checkTodayCasts:(NSString*)selectedCastID{
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
             if(numberOfCastsPlayed >= 2 && ![lastCastPlayed isEqualToString:selectedCastID]){ /* if today and number of casts exceeded*/
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
-(void) playCast:(UIButton*)sender{
    
    /* review needed. don't start player*/
    [self.tabBarController setSelectedIndex:0];
    UINavigationController *navController = (UINavigationController*)[self.tabBarController selectedViewController];
    if([[navController topViewController]isKindOfClass:[SerenCastReviewViewController class]]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Rating Needed"
                                                        message: @"Please rate the current cast first before playing another."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSInteger row = sender.tag;
        int selectedCastID = row + 1;
        if(self.segmentedControl.selectedSegmentIndex == 1) /* favorites */{
            if(podcastsFavsList && [podcastsFavsList count] > 0 && row < [podcastsFavsList count]){
                NSMutableDictionary * item = [podcastsFavsList objectAtIndex:row];
                selectedCastID = [[item objectForKey:@"trackID"]intValue];
            }
        }else if(self.segmentedControl.selectedSegmentIndex == 2) /* played */{
            if(podcastsPlayedList && [podcastsPlayedList count] > 0 && row < [podcastsPlayedList count]){
                NSMutableDictionary * item = [podcastsPlayedList objectAtIndex:row];
                selectedCastID = [[item objectForKey:@"trackID"]intValue];
            }
        }
        bool doPlay = [self checkTodayCasts:[NSString stringWithFormat:@"%d", selectedCastID]];
        if(doPlay)
        {
            SerenCastPlayerViewController *playerController = nil;
            if(navController)
            {
                NSArray *childViewControllers = navController.childViewControllers;
                for(int i=0; i<[childViewControllers count];i++)
                {
                    if([[childViewControllers objectAtIndex:i] isKindOfClass:[SerenCastPlayerViewController class]]){
                        playerController = [childViewControllers objectAtIndex:0];
                        break;
                    }
                }
                if(playerController)
                    [playerController resetPlayer:[NSString stringWithFormat:@"%d", selectedCastID] playerMode:0]; /* free mode */
            }
        }else{ //exceeded play count. display alert.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Podcasts Per Day Exceeded!"
                                                            message: @"You have reached the limit of 2 podcasts per day. Please resume listening to casts tomorrow."
                                                           delegate: nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}
-(void)openCastDetails:(UIButton*) sender{
    NSInteger row = sender.tag;
    int selectedTrackID = 0;
    if(self.segmentedControl.selectedSegmentIndex == 0) /* all list*/
        selectedTrackID = row + 1; /* sending the actual id not the index */
    else if(self.segmentedControl.selectedSegmentIndex == 1) /* favorites */{
        if(podcastsFavsList && [podcastsFavsList count] > 0 && row < [podcastsFavsList count]){
            NSMutableDictionary * item = [podcastsFavsList objectAtIndex:row];
            selectedTrackID = [[item objectForKey:@"trackID"]intValue];
        }
    }else if(self.segmentedControl.selectedSegmentIndex == 2) /* played */{
        if(podcastsPlayedList && [podcastsPlayedList count] > 0 && row < [podcastsPlayedList count]){
            NSMutableDictionary * item = [podcastsPlayedList objectAtIndex:row];
            selectedTrackID = [[item objectForKey:@"trackID"]intValue];
        }
    }
    NSLog(@"[openCastDetails] castID = %d", selectedTrackID);
    SerenCastCastDetialsViewController *detailsViewController = [[SerenCastCastDetialsViewController alloc]initWithCastID:[NSString stringWithFormat:@"%d", selectedTrackID]];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158.0;
}
- (void)adjustHeightOfTableview
{
    CGFloat height = self.tableView.contentSize.height;
    CGFloat maxHeight = [[UIScreen mainScreen]bounds].size.height - self.tableView.frame.origin.y - self.tabBarController.tabBar.frame.size.height;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    // now set the height constraint accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableViewHeightConstraint.constant = maxHeight;
        self.bgViewHeightConstraint.constant = maxHeight;
        [self.view needsUpdateConstraints];
    }];
}

@end
