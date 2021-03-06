//
//  FollowPeopleViewController.m
//  flipper
//
//  Created by Mayur Joshi on 15/03/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "FollowPeopleViewController.h"
#import "SignUpViewController.h"
#import "PeopleTableViewCell.h"
#import "IntroHeaderView.h"
#import "HomeViewController.h"
#import "People.h"
#import "Utility.h"

@interface FollowPeopleViewController ()<UITableViewDataSource,UITableViewDelegate> {
    __weak IBOutlet IntroHeaderView *peopleHeader;
    __weak IBOutlet UITableView *tablePeople;
    NSMutableArray *arrayPeople;
    NSMutableArray* selectedPeople;
    UIActivityIndicatorView *activityView;
}

@property (nonatomic, readwrite) BOOL followAll;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation FollowPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [peopleHeader.labelHeaderTitle setText:@"Follow"];
    [peopleHeader.buttonHeader addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    [peopleHeader.buttonHeader setImage:[UIImage imageNamed:@"FollowPeopleBack"] forState:UIControlStateNormal];
    
    arrayPeople = [NSMutableArray array];
    selectedPeople = [NSMutableArray arrayWithCapacity:0];
    //[self getPeopleDataFrom:@[@"ua70boG3jc",@"OTNCmSBXeL"]];
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    activityView.hidesWhenStopped = YES;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    [self getPeopleDataFrom:self.arraySelectedCategories];
    
    if(self.fromPeopleViewController) {
        [self.doneButton setTitle:@"Update"];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.opaque = YES;
    }
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
    cell.imagePerson.contentMode = UIViewContentModeScaleAspectFit;

    People *tempPeople = [arrayPeople objectAtIndex:indexPath.row];
    [cell.labelName setText:tempPeople.person_name];
    
    if([selectedPeople containsObject:tempPeople] || [self.arrayFromPeopleViewController containsObject:tempPeople.objectId]) {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleSelectedTick"]];
    }
    else {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleTick"]];
    }
    
    /*if(tempPeople.isSelected) {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleSelectedTick"]];
    }
    else {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleTick"]];
    }*/
    
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
    
    [selectedPeople removeAllObjects];
    if(self.followAll) {
        [selectedPeople addObjectsFromArray:arrayPeople];
    }
    
    /*for (People *tempPeople in arrayPeople) {
        tempPeople.isSelected = self.followAll;
    }*/
    [tablePeople reloadData];
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    People *tempPeople = [arrayPeople objectAtIndex:indexPath.row];
    
    if([self.arrayFromPeopleViewController containsObject:tempPeople.objectId]) {
        return;
    }
    
    if([selectedPeople containsObject:tempPeople]) {
        [selectedPeople removeObject:tempPeople];
    }
    else {
        [selectedPeople addObject:tempPeople];
    }
    
    /*if(tempPeople.isSelected) {
        tempPeople.isSelected = NO;
    }
    else {
        tempPeople.isSelected = YES;
    }*/
    [tableView reloadData];
}

#pragma mark - Custom Methods

-(void)getPeopleDataFrom:(NSArray *)array {
    if([Utility isNetAvailable]) {
        for (NSString *temp in array) {
            PFQuery *query = [PFQuery queryWithClassName:[People parseClassName]];
            [query whereKey:@"fk_category_id" equalTo:[PFObject objectWithoutDataWithClassName:@"Categories" objectId:temp]];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                [activityView stopAnimating];
                if(!error){
                    [arrayPeople addObjectsFromArray:objects];
                    [tablePeople reloadData];
                }else {
                    NSLog(@"Error:%@",error.localizedDescription);
                }
            }];
        }
    }else {
        [UIAlertView addDismissableAlertWithText:@"No Internet Connection" OnController:self];
    }
}

#pragma mark - Button actions
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneClicked:(id)sender {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected=1"];
    NSArray* selectedArray = [arrayPeople filteredArrayUsingPredicate:predicate];
    
    if(selectedPeople.count == 0) {
        
        if(self.fromPeopleViewController) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        [UIAlertView addDismissableAlertWithText:@"Please follow some people first!" OnController:self];
        return;
    }
    
    if(self.isFromStart) {
        SignUpViewController* signUpViewController = [INTRO_STORYBOARD instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        signUpViewController.arrayFollowPeople = selectedPeople;
        [self.navigationController pushViewController:signUpViewController animated:YES];
    }
    else {
        
        //add categories for this user
        for(People *tempPeople in selectedPeople) {
            PFObject *objUserPeople = [PFObject objectWithClassName:@"User_People"];
            [objUserPeople setValue:tempPeople.objectId forKey:@"fk_people_id"];
            [objUserPeople setValue:[PFUser currentUser].objectId forKey:@"fk_user_id"];
            [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsFacebook"];
            [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsTwitter"];
            [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsInstagram"];
            [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsVine"];
            [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsYoutube"];
            [objUserPeople saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                NSLog(@"Object saved error:%@",error.localizedDescription);
            }];
            
            //PFObject* userCategories = [];
            /*        if(tempPeople.isSelected) {
             tempPeople.isSelected = false;
             PFObject *objUserPeople = [PFObject objectWithClassName:@"User_People"];
             [objUserPeople setValue:tempPeople.objectId forKey:@"fk_people_id"];
             [objUserPeople setValue:[PFUser currentUser].objectId forKey:@"fk_user_id"];
             [objUserPeople saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
             NSLog(@"Object saved error:%@",error.localizedDescription);
             }];
             }*/
        }
        
        //add people to follow for this user
        PFUser* currentUser = [PFUser currentUser];
        [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"follows_celebrities"];
        [currentUser saveInBackground];
        
        if(self.fromPeopleViewController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            UINavigationController* homeNavigationViewController = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
            [APP_DELEGATE.window setRootViewController:homeNavigationViewController];
        }
    }
}


@end
