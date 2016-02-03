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

#define kOFFSET_FOR_KEYBOARD 180.0

@interface LoginViewController()

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
    [_textViewEmail.imageView setImage:[UIImage imageNamed:@"iconEmail"]];
    
    [_textViewPassword.textField setPlaceholder:@"Password"];
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
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                           handler:nil];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    actionOk.enabled = NO;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Forgot Password" message:@"Enter your email"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.delegate = self;
    }];
    
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
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
