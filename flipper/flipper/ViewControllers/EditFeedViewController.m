//
//  EditFeedViewController.m
//  flipper
//
//  Created by Mayur Joshi on 17/06/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "EditFeedViewController.h"
#import "EditFeedCell.h"

@interface EditFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation EditFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditFeedCell"];
    cell.labelFeedSocialType.text = @"Facebook";
    return cell;
}

@end
