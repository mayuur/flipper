//
//  HomeViewController.m
//  flipper
//
//  Created by Mayur Joshi on 04/04/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "HomeViewController.h"
#import "CarbonKit.h"
#import "FeedViewController.h"
#import "PeopleViewController.h"
#import "SearchViewController.h"
#import "ProfileViewController.h"

@interface HomeViewController () <CarbonTabSwipeNavigationDelegate> {
    NSArray *items;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarTabs;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    items = @[[UIImage imageNamed:@"TabFeed"], [UIImage imageNamed:@"TabPeople"],
              [UIImage imageNamed:@"TabSearch"], [UIImage imageNamed:@"TabProfile"]];
        
    carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc]
                                initWithItems:items
                                toolBar:_toolbarTabs
                                delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:self
                                             andTargetView:self.view];
    [_toolbarTabs.superview bringSubviewToFront:_toolbarTabs];

    [self style];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)style {
    
    UIColor *color = [UIColor colorWithRed:243.0/255 green:243/255 blue:243/255 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setIndicatorColor:color];
    [carbonTabSwipeNavigation setTabExtraWidth:30];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:CGRectGetWidth(self.view.frame)/4 forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:CGRectGetWidth(self.view.frame)/4 forSegmentAtIndex:1];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:CGRectGetWidth(self.view.frame)/4 forSegmentAtIndex:2];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:CGRectGetWidth(self.view.frame)/4 forSegmentAtIndex:3];
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]
                                        font:[UIFont boldSystemFontOfSize:14]];
    [carbonTabSwipeNavigation setSelectedColor:[UIColor whiteColor]
                                          font:[UIFont boldSystemFontOfSize:14]];
}

# pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"FeedViewController"];
            
        case 1:
            return [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"PeopleViewController"];
            
        case 2:
            return [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"SearchViewController"];
            
        case 3:
            return [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            
        default:
            return [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    }
}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
    switch(index) {
        case 0:
            self.title = @"News Feed";
            break;
        case 1:
            self.title = @"Celebrities";
            break;
        case 2:
            self.title = @"Search";
            break;
        default:
            self.title = @"Profile";
            break;
    }
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}


@end
