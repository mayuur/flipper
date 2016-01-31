//
//  WalkthroughViewController.m
//  flipper
//
//  Created by Mayur Joshi on 30/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "WalkthroughViewController.h"
#import "PageWalkthrough.h"

@interface WalkthroughViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray* arrayPages;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation WalkthroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createWalkthrough];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - General Methods
- (void) createWalkthrough {
    PageWalkthrough* page1 = [[PageWalkthrough alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) text:@"This is the first page of the walkthrough" backgroundImage:@"WalkthroughPage1" andLogoImage:@"logoFlipper"];
    page1.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:page1];
    
    PageWalkthrough* page2 = [[PageWalkthrough alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) text:@"This is the second page of the walkthrough" backgroundImage:@"WalkthroughPage2" andLogoImage:@"logoPlus"];
    page2.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:page2];
    
    PageWalkthrough* page3 = [[PageWalkthrough alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 2, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) text:@"This is the third page of the walkthrough" backgroundImage:@"WalkthroughPage3" andLogoImage:@"logoPlus"];
    page3.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:page3];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*3, CGRectGetHeight(self.scrollView.frame));
}

#pragma mark - Button actions
- (IBAction)startClicked:(id)sender {
    //move to the Categories controller without signing up
    
}

#pragma mark - UIScrollViewDelegate functions
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageControl setPageForScrollView:scrollView];
}

@end
