//
//  FeedDetailViewController.m
//  flipper
//
//  Created by Ashutosh Dave on 26/04/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "FeedDetailViewController.h"

#import "FacebookModel.h"
#import "TwitterModel.h"
#import "VineModel.h"
#import "YouTubeModel.h"
#import "InstagramModel.h"

#define GLOBAL_KEY_SOCIAL_TYPE @"type"
#define GLOBAL_KEY_MODEL @"socialModel"
#define GLOBAL_KEY_POST_DATE @"postDate"
#define GLOBAL_KEY_DISPLAY_PIC @"displayPic"


@interface FeedDetailViewController ()

@end

@implementation FeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInteger socialType = [_socialDict[GLOBAL_KEY_SOCIAL_TYPE] integerValue];
    
    switch (socialType) {
        case SocialMediaTypeFacebook: {
            FacebookModel *tempModel = (FacebookModel* ) _socialDict[GLOBAL_KEY_MODEL];
        }
            break;
            
        case SocialMediaTypeTwitter: {
            TwitterModel *tempModel = (TwitterModel* ) _socialDict[GLOBAL_KEY_MODEL];
        }
            break;
            
        case SocialMediaTypeInstagram: {
            InstagramModel *tempModel = (InstagramModel* ) _socialDict[GLOBAL_KEY_MODEL];
        }
            break;
            
        case SocialMediaTypeYoutube: {
            YouTubeModel *tempModel = (YouTubeModel* ) _socialDict[GLOBAL_KEY_MODEL];
        }
            break;
            
        case SocialMediaTypeVine: {
            VineModel *tempModel = (VineModel *) _socialDict[GLOBAL_KEY_MODEL];
        }
            break;
            
    }

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
