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
}
@end

@implementation SerenCastPlayerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        podcastsList = [[NSMutableArray alloc]init];
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
    NSMutableDictionary* item = [podcastsList objectAtIndex:row];
    cell.titleLabel.text = [item objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
