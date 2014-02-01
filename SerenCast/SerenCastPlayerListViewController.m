//
//  SerenCastPlayerListViewController.m
//  SerenCast
//
//  Created by Wessam Abdrabo on 1/31/14.
//  Copyright (c) 2014 tum. All rights reserved.
//

#import "SerenCastPlayerListViewController.h"
#import "SerenCastPlayerListCell.h"

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
    NSLog(@"favs list count = %d", podcastsFavsList.count);
    if(podcastsFavsList.count){
        for(int i=podcastsFavsList.count-1; i>=0; i--){
            NSLog(@"remove object at index %d",i);
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

    cell.titleLabel.text = [item objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
