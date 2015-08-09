//
//  XYZViewController.m
//  TableDemo
//
//  Created by 史江凯 on 15/5/10.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//
static const NSString *kAPI_KEY = @"FC8A8F0215C88437AEB851C64688EB8E";
#import "XYZViewController.h"
#import "DetailTableViewController.h"
#import "XYZHeroTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface XYZViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *dataPath;
}

@property NSArray  *listArray;
@property NSURLSession *session;
@property NSDictionary *heroesDetail;
@end

@implementation XYZViewController

- (void)fetchHeroesAbilityData
{
    NSURL *apiURL = [NSURL URLWithString:@"http://www.dota2.com/jsfeed/abilitydata"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:apiURL
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     NSDictionary *abilityData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error][@"abilitydata"];
                                                     [abilityData writeToFile:[dataPath stringByAppendingPathComponent:@"ablitydata.plist" ] atomically:YES];
                                                 }];
    [dataTask resume];

}
- (void)fetchHeroesDetailData
{
    NSURL *apiURL = [NSURL URLWithString:@"http://www.dota2.com/jsfeed/heropickerdata"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:apiURL
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     self.heroesDetail = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     [self.heroesDetail writeToFile:[dataPath stringByAppendingPathComponent:@"Detaildata.plist"] atomically:YES];
                                                 }];
    [dataTask resume];
}
- (void)fetchHeroesListData
{
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=%@&language=en_US",kAPI_KEY]];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:apiURL
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     self.listArray =  json[@"result"][@"heroes"];
                                                     [self.listArray writeToFile:[dataPath stringByAppendingPathComponent:@"listdata.plist"] atomically:YES];
                                                 }];
    [dataTask resume];

}
- (void)setupDataSource
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[dataPath stringByAppendingPathComponent:@"listdata.plist"]]) {
        self.listArray = [NSArray arrayWithContentsOfFile:[dataPath stringByAppendingPathComponent:@"listdata.plist"]];
    } else {
        [self fetchHeroesListData];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[dataPath stringByAppendingPathComponent:@"abilitydata.plist"]]) {
    } else {
        [self fetchHeroesAbilityData];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[dataPath stringByAppendingPathComponent:@"Detaildata.plist"]]) {
        self.heroesDetail = [NSDictionary dictionaryWithContentsOfFile:[dataPath stringByAppendingPathComponent:@"Detaildata.plist"]];
    } else {
        [self fetchHeroesDetailData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZHeroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *name = self.listArray[indexPath.row][@"name"];
    NSString *realname = [name stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""];
    NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_lg.png",realname]];
    [cell.iconImageView sd_setImageWithURL:urlString];
    cell.nameLabel.text = self.listArray[indexPath.row][@"localized_name"];
    cell.typeLabel.text = self.heroesDetail[realname][@"atk_l"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TODETAIL"]) {
        DetailTableViewController *detailVC = [segue destinationViewController];
        NSString *selectedHero = [self.listArray[self.tableView.indexPathForSelectedRow.row][@"name"] stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""];
        detailVC.hero = selectedHero;
        
        NSString *name = self.listArray[self.tableView.indexPathForSelectedRow.row][@"name"];
        NSString *realname = [name stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""];
        NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com.cn/apps/dota2/images/heroes/%@_vert.jpg",realname]];
        detailVC.fullImageURL = urlString;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"Dota2 Heropedia";
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    [self setupDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
