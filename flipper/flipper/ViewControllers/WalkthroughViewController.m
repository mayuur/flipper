//
//  WalkthroughViewController.m
//  flipper
//
//  Created by Mayur Joshi on 30/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "WalkthroughViewController.h"
#import "PageWalkthrough.h"

#define IMAGE_OFFSET_SPEED 250

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
    PageWalkthrough* page1 = [[PageWalkthrough alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) text:@"follow once follow everywhere" backgroundImage:@"WalkthroughPage1" andPageID:0];
    [page1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView addSubview:page1];
    
    PageWalkthrough* page2 = [[PageWalkthrough alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) text:@"Instantly follow your favorite celebrities, influencers and interests" backgroundImage:@"WalkthroughPage2" andPageID:1];
    [page2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView addSubview:page2];
    [self.scrollView sendSubviewToBack:page2];
    
    PageWalkthrough* page3 = [[PageWalkthrough alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 2, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) text:@"Follow multiple timelines from Facebook, Twitter, Vine, Instagram, Youtube and more" backgroundImage:@"WalkthroughPage3" andPageID:2];
    [page3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView addSubview:page3];
    [self.scrollView sendSubviewToBack:page3];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*3, CGRectGetHeight(self.scrollView.frame));
    
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
}

#pragma mark - Button actions
- (IBAction)startClicked:(id)sender {
    //move to the Categories controller without signing up
    
}

#pragma mark - UIScrollViewDelegate functions
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageControl setPageForScrollView:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(UIView* subView in scrollView.subviews) {
        
        if([subView isKindOfClass:[PageWalkthrough class]]) {
            PageWalkthrough* pageView = (PageWalkthrough* ) subView;
            CGFloat xOffset = ((scrollView.contentOffset.x - pageView.frame.origin.x) / 320) * IMAGE_OFFSET_SPEED;
            pageView.imageOffset = CGPointMake(xOffset, 0.0f);
        }
    }
}

@end
