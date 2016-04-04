//
//  FollowPeopleViewController.m
//  flipper
//
//  Created by Mayur Joshi on 15/03/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "FollowPeopleViewController.h"
#import "PeopleTableViewCell.h"
#import "IntroHeaderView.h"
#import "People.h"

@interface FollowPeopleViewController ()<UITableViewDataSource,UITableViewDelegate> {
    __weak IBOutlet IntroHeaderView *peopleHeader;
    __weak IBOutlet UITableView *tablePeople;
    NSMutableArray *arrayPeople;
}

@property (nonatomic, readwrite) BOOL followAll;

@end

@implementation FollowPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [peopleHeader.labelHeaderTitle setText:@"Follow"];
    [peopleHeader.buttonHeader addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    [peopleHeader.buttonHeader setImage:[UIImage imageNamed:@"FollowPeopleBack"] forState:UIControlStateNormal];
    
    arrayPeople = [NSMutableArray array];
    //[self getPeopleDataFrom:@[@"ua70boG3jc",@"OTNCmSBXeL"]];
    [self getPeopleDataFrom:self.arraySelectedCategories];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayPeople.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.clipsToBounds = NO;

    if(indexPath.row == 0) {
        cell.layer.shadowOpacity = 0.25;
        cell.layer.shadowRadius = 20;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        
        CGRect shadowFrame = CGRectMake(0, 0, CGRectGetWidth(cell.layer.bounds), 15);
        CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
        cell.layer.shadowPath = shadowPath;
    }
    else {
        /*cell.layer.shadowOpacity = 0.25;
        cell.layer.shadowRadius = 20;
        cell.layer.shadowOffset = CGSizeMake(0, 20);
        cell.layer.shadowColor = [UIColor blackColor].CGColor;*/
    }
    
    cell.imagePerson.layer.shadowOpacity = 0.25;
    cell.imagePerson.layer.shadowRadius = 10;
    cell.imagePerson.layer.shadowOffset = CGSizeMake(0, 20);
    cell.imagePerson.layer.shadowColor = [UIColor blackColor].CGColor;

    People *tempPeople = [arrayPeople objectAtIndex:indexPath.row];
    [cell.labelName setText:tempPeople.person_name];
    if(tempPeople.isSelected) {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleSelectedTick"]];
    }
    else {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleTick"]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tempPeople.person_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            [cell.imagePerson setImage:[UIImage imageWithData:data]];
        }];
    });
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleHeaderCell"];
    [cell.buttonFollow addTarget:self action:@selector(followAll:) forControlEvents:UIControlEventTouchUpInside];
    
    //if followAll is selected or all cells are selected, show the selected cell value
    if(self.followAll) {
        [cell.buttonFollow setImage:[UIImage imageNamed:@"FollowPeopleSelectedTick"] forState:UIControlStateNormal];
    }
    else {
        [cell.buttonFollow setImage:[UIImage imageNamed:@"FollowPeopleTick"] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 98;
}

-(void)followAll:(UIButton *)sender {
    
    self.followAll = !self.followAll;
    
    for (People *tempPeople in arrayPeople) {
        tempPeople.isSelected = self.followAll;
    }
    [tablePeople reloadData];
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    People *tempPeople = [arrayPeople objectAtIndex:indexPath.row];
    if(tempPeople.isSelected) {
        tempPeople.isSelected = NO;
    }
    else {
        tempPeople.isSelected = YES;
    }
    [tableView reloadData];
}

#pragma mark - Custom Methods

-(void)getPeopleDataFrom:(NSArray *)array {
    for (NSString *temp in array) {
        PFQuery *query = [PFQuery queryWithClassName:[People parseClassName]];
        [query whereKey:@"fk_category_id" equalTo:[PFObject objectWithoutDataWithClassName:@"Categories" objectId:temp]];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(!error){
                [arrayPeople addObjectsFromArray:objects];
                [tablePeople reloadData];
            }else {
                NSLog(@"Error:%@",error.localizedDescription);
            }
        }];
    }
}

#pragma mark - Button actions
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
