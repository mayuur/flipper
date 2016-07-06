//
//  SignUpViewController.m
//  flipper
//
//  Created by Mayur Joshi on 30/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "SignUpViewController.h"
#import "IntroHeaderView.h"
#import "IntroTextView.h"
#import "Parse.h"
#import "PFFacebookUtils.h"
#import "PFTwitterUtils.h"
#import "PF_Twitter.h"
#import "FBSDKCoreKit/FBSDKGraphRequest.h"
#import "NSString+Validations.h"
#import <FHSTwitterEngine/FHSTwitterEngine.h>
#import "CategoriesViewController.h"
#import "Utility.h"
#import "People.h"

#define kOFFSET_FOR_KEYBOARD 180.0

@interface SignUpViewController ()
{
    UIActivityIndicatorView *activityView;
}

@property (weak, nonatomic) IBOutlet IntroHeaderView *signUpHeaderView;

@property (weak, nonatomic) IBOutlet IntroTextView *textViewName;
@property (weak, nonatomic) IBOutlet IntroTextView *textViewEmail;
@property (weak, nonatomic) IBOutlet IntroTextView *textViewPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewSignUp;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_signUpHeaderView.labelHeaderTitle setText:@"Sign Up"];
    [_signUpHeaderView.buttonHeader setImage:[UIImage imageNamed:@"iconBack"] forState:UIControlStateNormal];
    [_signUpHeaderView.buttonHeader addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_textViewName.textField setPlaceholder:@"Name"];
    [_textViewName.imageView setImage:[UIImage imageNamed:@"iconName"]];
    
    [_textViewEmail.textField setPlaceholder:@"Email"];
    [_textViewEmail.textField setKeyboardType:UIKeyboardTypeEmailAddress];
    [_textViewEmail.imageView setImage:[UIImage imageNamed:@"iconEmail"]];
    
    [_textViewPassword.textField setPlaceholder:@"Password"];
    [_textViewPassword.textField setSecureTextEntry:YES];
    [_textViewPassword.imageView setImage:[UIImage imageNamed:@"iconPassword"]];
    
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    activityView.hidesWhenStopped = YES;
    
    [self.view addSubview:activityView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


-(void)keyboardWillShow {
    // Animate the current view out of the way
   [self moveScrollViewUp:YES];
}

-(void)keyboardWillHide {
    [self moveScrollViewUp:NO];
}

-(void)moveScrollViewUp:(BOOL)movedUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    if (movedUp)
    {
        [_scrollViewSignUp setContentOffset:CGPointMake(0, kOFFSET_FOR_KEYBOARD) animated:YES];
    }
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)loginClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpClicked:(id)sender {
    UIAlertController *alertController;
    if(![_textViewEmail.textField.text validateEmail]) {
        alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter a proper email address" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    NSArray  *validation = [_textViewPassword.textField.text checkPasswordValidations];
    if([validation count] != 0) {
        
        alertController = [UIAlertController alertControllerWithTitle:nil message:[validation objectAtIndex:0] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return ;
        
    }
    
    PFUser *user = [PFUser user];
    user.username = _textViewEmail.textField.text;
    user.password = _textViewPassword.textField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"user did sign up!");
//            [UIAlertView addDismissableAlertWithText:@"User did sign up!" OnController:self];
            CategoriesViewController *categories = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
            [self.navigationController pushViewController:categories animated:YES];
        }
        else {
            NSLog(@"Error >> %@", [error localizedDescription]);
            [UIAlertView addDismissableAlertWithText:[NSString stringWithFormat:@"Sign Up failed with error - %@", [error localizedDescription]] OnController:self];
        }
    }];
}

/*
 - Check if user is already a user
 - If new user, let user establish himselves and then make him follow selected celebrities
 - If coming from start, directly go to FeedView instead of Categories View
 */

- (IBAction)facebookSignUp:(UIButton *)sender {
    if([Utility isNetAvailable]) {
        [activityView startAnimating];
        [PFUser logOut];
        [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile",@"email"] block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else if (user.isNew) {
                
                NSLog(@"User signed up and logged in through Facebook!");
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name,email"}];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                 {
                     [activityView stopAnimating];
                     if (error)
                     {
                         UIAlertView *alertVeiw = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                         
                         [alertVeiw show];
                         
                     } else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                         //   NSLog(@"The facebook session was invalidated");
                         [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
                     }
                     else {
                         
                         NSDictionary *userData = (NSDictionary *)result;
                         //   [self requestFacebookUser:user];
                         
                         NSString *name = userData[@"name"];
                         NSString *email = userData[@"email"];
                         
                         user.username = name;
                         user.email = email;
                         [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                          {
                              if (error)
                              {
                                  UIAlertView *alertVeiw = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                  
                                  [alertVeiw show];
                                  
                              }
                              else {
                                  // [self dismissViewControllerAnimated:NO completion:nil];
                                  //[self.navigationController popToRootViewControllerAnimated:NO];
                                  
                                  //user has been created, so if there are people, follow it right now
                                  if(self.arrayFollowPeople.count > 0) {
                                      //add categories for this user
                                      for(People *tempPeople in self.arrayFollowPeople) {
                                          PFObject *objUserPeople = [PFObject objectWithClassName:@"User_People"];
                                          [objUserPeople setValue:tempPeople.objectId forKey:@"fk_people_id"];
                                          [objUserPeople setValue:user.objectId forKey:@"fk_user_id"];
                                          [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsFacebook"];
                                          [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsTwitter"];
                                          [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsInstagram"];
                                          [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsVine"];
                                          [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsYoutube"];
                                          [objUserPeople saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                              NSLog(@"Object saved error:%@",error.localizedDescription);
                                          }];
                                      }
                                      
                                      //add people to follow for this user
                                      PFUser* currentUser = [PFUser currentUser];
                                      [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"follows_celebrities"];
                                      [currentUser saveInBackground];
                                  }
                                  
                                  if(self.arrayFollowPeople.count > 0) {
                                      UINavigationController* homeNavigationViewController = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                                      [APP_DELEGATE.window setRootViewController:homeNavigationViewController];
                                  }
                                  else {
                                      CategoriesViewController *categories = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
                                      [self.navigationController pushViewController:categories animated:YES];
                                  }
                              }
                          }];
                     }
                 }];
                
            } else {
                NSLog(@"User logged in through Facebook!");
                [UIAlertView addDismissableAlertWithText:@"Already an existing user. Logging in!" OnController:self];
                UINavigationController* homeNavigationViewController = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                [APP_DELEGATE.window setRootViewController:homeNavigationViewController];
            }
        }];
    }else {
        [UIAlertView addDismissableAlertWithText:@"No Internet Connection" OnController:self];
    }
}


- (void)getTwitterAccounts:(void (^)(BOOL accountsWereFound, NSArray *twitterAccounts))completionBlock
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType = [accountStore
                                  accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler completionHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterType];
            if (completionBlock) {
                if (twitterAccounts.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(YES, twitterAccounts);
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(NO, nil);
                    });
                    // No accounts on device
                }
            }
        }
        
        // We were denied by the user...
        else {
            // Account access denied
            
            // Pass back nothing
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, nil);
                });
            }
        }
    };
    
    // iOS 5 and iOS 6 have different APIs
    if ([accountStore
         respondsToSelector:@selector(requestAccessToAccountsWithType:
                                      options:
                                      completion:)]) {
             [accountStore requestAccessToAccountsWithType:twitterType
                                                   options:nil
                                                completion:completionHandler];
         }
    else {
        [accountStore requestAccessToAccountsWithType:twitterType
                                withCompletionHandler:completionHandler];
    }
    
}
- (IBAction)twitterSignUp:(id)sender {
    
    [self getTwitterAccounts:^(BOOL accountsWereFound, NSArray *twitterAccounts) {
        if(accountsWereFound) {
            [PFTwitterUtils logInWithBlock:^(PFUser * _Nullable user, NSError * _Nullable error) {
                
                if (!user) {
                    NSLog(@"Uh oh. The user cancelled the Twitter login.");
                    return;
                } else if (user.isNew) {
                    NSString *twitterScreenName = [PFTwitterUtils twitter].screenName;
                    NSLog(@"%@",[PFTwitterUtils twitter].screenName);
                    
                    NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
                    [[PFTwitterUtils twitter] signRequest:request];
                    [[[NSURLSession alloc]init] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        if (!error) {
                            
                            user.username = twitterScreenName;
                            user[@"name"]= result[@"name"];
                            [user saveEventually];
                        }
                    }];
                    
                    [self performSegueWithIdentifier: @"username" sender: self];
                    
                }
            }];
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Twitter Accounts" message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
