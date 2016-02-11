//
//  LoginViewController.m
//  flipper
//
//  Created by Mayur Joshi on 26/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "LoginViewController.h"
#import "IntroHeaderView.h"
#import "IntroTextView.h"
#import "IntroButton.h"
#import "Parse.h"
#import "PFFacebookUtils.h"
#import <PFTwitterUtils.h>
#import "NSString+Validations.h"
#import <FHSTwitterEngine/FHSTwitterEngine.h>

#define kOFFSET_FOR_KEYBOARD 180.0
NSString * const TWITTER_CONSUMER_KEY = @"TexzVYvmdlkcpRWBiVn2txexW";
NSString * const TWITTER_CONSUMER_SECRET = @"0iQLTuMR9CewQn4fPZ0wl85iwnTWJ9l12ZzujhlZDzKc8S5CCi";

@interface LoginViewController() <UITextFieldDelegate>
{
    NSArray *arrayTwitterAccounts;
}
@property (weak, nonatomic) IBOutlet IntroHeaderView *loginHeaderView;

@property (weak, nonatomic) IBOutlet IntroTextView *textViewEmail;
@property (weak, nonatomic) IBOutlet IntroTextView *textViewPassword;

@property (strong, nonatomic) IBOutlet IntroButton *buttonFacebook;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_loginHeaderView.labelHeaderTitle setText:@"Login"];
    
    [_textViewEmail.textField setPlaceholder:@"Email"];
    [_textViewEmail.textField setKeyboardType:UIKeyboardTypeEmailAddress];
    [_textViewEmail.imageView setImage:[UIImage imageNamed:@"iconEmail"]];
    
    [_textViewPassword.textField setPlaceholder:@"Password"];
    [_textViewPassword.textField setSecureTextEntry:YES];
    [_textViewPassword.imageView setImage:[UIImage imageNamed:@"iconPassword"]];
    
    _buttonFacebook = [[IntroButton alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.frame), 60.0f)];
    [_buttonFacebook.imageViewButton setImage:[UIImage imageNamed:@"iconFacebook"]];
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
        [_scrollViewLogin setContentOffset:CGPointMake(0, kOFFSET_FOR_KEYBOARD) animated:YES];
    }
    [UIView commitAnimations];
}

#pragma mark - UIButtonActions

- (IBAction)forgotClicked:(UIButton *)sender {
//    actionOk.enabled = NO;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Want to reset your password?" message:@"Enter your email address"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.delegate = self;
    }];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Reset"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [PFUser requestPasswordResetForEmailInBackground:alertController.textFields[0].text block:^(BOOL succeeded, NSError * _Nullable error) {
                                                             if(succeeded) {
                                                                 NSLog(@"email address found! sending an email for password reset");
                                                                 [UIAlertView addDismissableAlertWithText:@"Sent an email for password reset!" OnController:self];
                                                             }
                                                             else {
                                                                 NSLog(@"Error >> %@", [error localizedDescription]);
                                                                 [UIAlertView addDismissableAlertWithText:[NSString stringWithFormat:@"Reset Password failed with error - %@", [error localizedDescription]] OnController:self];
                                                             }
                                                         }];
                                                     }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)loginClicked:(id)sender {
    UIAlertController *alertController;
    if(![_textViewEmail.textField.text validateEmail]) {
        alertController = [UIAlertController alertControllerWithTitle:nil message:@"Invalid email" preferredStyle:UIAlertControllerStyleAlert];
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
    
    [PFUser logInWithUsernameInBackground:_textViewEmail.textField.text password:_textViewPassword.textField.text
                                    block:^(PFUser *user, NSError *error) {
                                      if (user) {
                                          // Do stuff after successful login.
                                          NSLog(@"user logged in!");
                                          [UIAlertView addDismissableAlertWithText:@"User did login!" OnController:self];
                                      }
                                      else {
                                          NSLog(@"Error >> %@", [error localizedDescription]);
                                          [UIAlertView addDismissableAlertWithText:[NSString stringWithFormat:@"Login failed with error - %@", [error localizedDescription]] OnController:self];
                                      }
                                  }];
}

- (IBAction)facebookLoginClicked:(UIButton *)sender {
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile",@"email"] block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
}


- (IBAction)twitterLogin:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
            NSURL *info = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/settings.json"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:info];
            [[PFTwitterUtils twitter] signRequest:request];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!!data) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    NSString *userName = dict[@"screen_name"];
                    userName = [userName stringByReplacingOccurrencesOfString:@"Twitter:" withString:@""];
                    
                    PFUser *user = [PFUser currentUser];
                    user[@"Twitter"] = userName;
                    [user saveEventually];
                } else {
                    // no response
                }
            }];
        } else {
            // login failed
        }
    }];
}

#pragma mark - Twitter Login Methods

-(void)handleTwitterAccounts:(NSArray *)twitterAccounts {
    switch ([twitterAccounts count]) {
        case 0:
        {
            [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:TWITTER_CONSUMER_KEY andSecret:TWITTER_CONSUMER_SECRET];
            UIViewController *twitterLoginViewController = [[FHSTwitterEngine sharedEngine] loginControllerWithCompletionHandler:^(BOOL success) {
                if(success) {
                    
                }
            }];
            [self presentViewController:twitterLoginViewController animated:YES completion:nil];
        }
            break;
            
        case 1:
            [self onUserTwitterAccountSelection:twitterAccounts[0]];
            break;
        
        default:
            [self displayTwitterAccounts:twitterAccounts];
            break;
    }
}

-(void)displayTwitterAccounts:(NSArray *)twitterAccounts {
    __block UIAlertController *alertAction = [UIAlertController alertControllerWithTitle:@"Select Twitter Account" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [twitterAccounts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertAction addAction:[UIAlertAction actionWithTitle:[obj username] style:UIAlertActionStyleDefault handler:nil]];
    }];
    [alertAction addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
}
-(void)onUserTwitterAccountSelection:(ACAccount *)twitterAccount {
    // Logint with twitter account
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



@end
