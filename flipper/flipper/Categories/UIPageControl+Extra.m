//
//  UIPageControl+Extra.m
//  flipper
//
//  Created by Mayur Joshi on 31/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "UIPageControl+Extra.h"

@implementation UIPageControl (Extra)

- (void) setPageForScrollView: (UIScrollView* ) scrollView {
    //get the current page of scrollview
    NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);

    //set that page to pagecontrol
    self.currentPage = currentPage;
}

@end
