//
//  PeopleViewController.m
//  flipper
//
//  Created by Mayur Joshi on 4/5/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "PeopleViewController.h"
#import "Categories.h"

@interface PeopleViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewCategories;
@property (strong, nonatomic) NSMutableArray* arrayCategories;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrayCategories = [NSMutableArray new];
    [self getAllCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - General Methods
-(void)getAllCategories {
    PFQuery *query = [PFQuery queryWithClassName:[Categories parseClassName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            [self.arrayCategories addObjectsFromArray:objects];
            [self.tableViewCategories reloadData];
        }else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    
    Categories* category = self.arrayCategories[indexPath.row];
    cell.textLabel.text = category.category_name;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
