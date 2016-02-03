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

@interface LoginViewController()

@property (weak, nonatomic) IBOutlet IntroHeaderView *loginHeaderView;

@property (weak, nonatomic) IBOutlet IntroTextView *textViewEmail;
@property (weak, nonatomic) IBOutlet IntroTextView *textViewPassword;

@property (strong, nonatomic) IBOutlet IntroButton *buttonFacebook;

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
