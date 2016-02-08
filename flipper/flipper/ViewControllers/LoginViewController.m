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
#include "PFFacebookUtils.h"
#include "NSString+Validations.h"

#define kOFFSET_FOR_KEYBOARD 180.0

@interface LoginViewController() <UITextFieldDelegate>

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
