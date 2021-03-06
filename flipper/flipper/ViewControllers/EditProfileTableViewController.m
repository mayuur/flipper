//
//  EditProfileTableViewController.m
//  flipper
//
//  Created by Ashutosh Dave on 23/04/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "EditProfileTableViewController.h"
#import "Parse.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"

/*Add "pod 'MBProgressHUD', '~> 0.9.2'" to Podfile 
    and then run pod install*/

#import "MBProgressHUD.h"

@interface EditProfileTableViewController ()
{
    
    __weak IBOutlet UIImageView *imageViewProfile;
    __weak IBOutlet UILabel *labelUserName;
    __weak IBOutlet UITextField *textFieldEmail;
    __weak IBOutlet UITextField *textFieldPassword;
}
@end

@implementation EditProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textFieldEmail.enabled = NO;
    textFieldPassword.enabled = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [labelUserName setText:[[PFUser currentUser] username]];
    [textFieldEmail setText:[[PFUser currentUser] email]];
    [imageViewProfile setImageWithURL:[NSURL URLWithString:[[PFUser currentUser] valueForKey:@"profile_image"]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isInstaAuthShown"];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Intro" bundle:nil];
            LoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:login];
            navigationController.navigationBar.barTintColor = [UIColor blackColor];
            navigationController.navigationBar.translucent = NO;
            
            [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
            [[UIApplication sharedApplication].keyWindow setRootViewController:navigationController];
        }];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
