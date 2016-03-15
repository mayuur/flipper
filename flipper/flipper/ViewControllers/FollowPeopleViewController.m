//
//  FollowPeopleViewController.m
//  flipper
//
//  Created by Mayur Joshi on 15/03/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "FollowPeopleViewController.h"

@implementation FollowPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
