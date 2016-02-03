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

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet IntroHeaderView *signUpHeaderView;

@property (weak, nonatomic) IBOutlet IntroTextView *textViewName;
@property (weak, nonatomic) IBOutlet IntroTextView *textViewEmail;
@property (weak, nonatomic) IBOutlet IntroTextView *textViewPassword;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_signUpHeaderView.labelHeaderTitle setText:@"Sign Up"];
    
    [_textViewName.textField setPlaceholder:@"Name"];
    [_textViewName.imageView setImage:[UIImage imageNamed:@"iconName"]];
    
    [_textViewEmail.textField setPlaceholder:@"Email"];
    [_textViewEmail.imageView setImage:[UIImage imageNamed:@"iconEmail"]];
    
    [_textViewPassword.textField setPlaceholder:@"Password"];
    [_textViewPassword.imageView setImage:[UIImage imageNamed:@"iconPassword"]];
    
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
