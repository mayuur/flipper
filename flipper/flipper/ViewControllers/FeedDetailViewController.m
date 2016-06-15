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
#import "FeedViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Parse.h"

#define GLOBAL_KEY_SOCIAL_TYPE @"type"
#define GLOBAL_KEY_MODEL @"socialModel"
#define GLOBAL_KEY_POST_DATE @"postDate"
#define GLOBAL_KEY_DISPLAY_PIC @"displayPic"


@interface FeedDetailViewController ()
{
    __weak IBOutlet UIButton *buttonSocialIcon;
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UIImageView *imageProfile;
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UIImageView *imageMain;
    __weak IBOutlet UILabel *labelCreatedAt;
    
    __weak IBOutlet UIButton *buttonLike;
    __weak IBOutlet UIButton *buttonComment;
    __weak IBOutlet UIButton *buttonShare;
}
@end

@implementation FeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    NSInteger socialType = [_socialDict[GLOBAL_KEY_SOCIAL_TYPE] integerValue];
    
    switch (socialType) {
        case SocialMediaTypeFacebook: {
            FacebookModel *tempModel = (FacebookModel* ) _socialDict[GLOBAL_KEY_MODEL];
            labelName.text = tempModel.pageName;
            labelTitle.text = tempModel.message;
            [imageMain setImageWithURL:[NSURL URLWithString:tempModel.picture]];
            [buttonSocialIcon setImage:[UIImage imageNamed:@"Facebook"] forState:UIControlStateNormal];
            
            PFFile* imageFile = (PFFile* ) _socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                imageProfile.image = [UIImage imageWithData:data];
            }];
            [buttonComment setTitle:tempModel.totalComments forState:UIControlStateNormal];
            [buttonLike setTitle:tempModel.totalLikes forState:UIControlStateNormal];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            NSDate* date = [dateFormatter dateFromString:tempModel.createdTime];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hhmm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            [labelCreatedAt setText:mydate];
            
            [buttonShare addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case SocialMediaTypeTwitter: {
            TwitterModel *tempModel = (TwitterModel* ) _socialDict[GLOBAL_KEY_MODEL];
            labelName.text = [NSString stringWithFormat:@"%@", tempModel.name];
            labelTitle.text = [NSString stringWithFormat:@"%@", tempModel.twitterText];
            NSString *dateString = [NSString stringWithFormat:@"%@", tempModel.createdAt];
            NSDateFormatter *dateFormatter= [NSDateFormatter new];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            dateFormatter =[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            labelCreatedAt.text = [NSString stringWithFormat:@"%@", mydate];
            [buttonLike setTitle:[NSString stringWithFormat:@"%@", tempModel.favoriteCount] forState:UIControlStateNormal];
            [buttonComment setTitle:[NSString stringWithFormat:@"%@", tempModel.retweetCount] forState:UIControlStateNormal];
            
            [buttonShare addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonSocialIcon setImage:[UIImage imageNamed:@"Twitter"] forState:UIControlStateNormal];
            
            PFFile* imageFile = (PFFile* ) _socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                imageProfile.image = [UIImage imageWithData:data];
            }];
        }
            break;
            
        case SocialMediaTypeVine: {
            VineModel *tempModel = (VineModel* ) _socialDict[GLOBAL_KEY_MODEL];
            [labelName setText:tempModel.username];
            [labelTitle setText:tempModel.vineDescription];
            [buttonComment setTitle:tempModel.commentCount forState:UIControlStateNormal];
            [buttonLike setTitle:tempModel.likes forState:UIControlStateNormal];
            [imageProfile setImageWithURL:[NSURL URLWithString:tempModel.urlAvatar]];
            [imageMain setImageWithURL:[NSURL URLWithString:tempModel.urlThumb]];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
            NSDate* date = [dateFormatter dateFromString:tempModel.createdAt];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            [labelCreatedAt setText:mydate];
            
            
            [buttonSocialIcon setImage:[UIImage imageNamed:@"Vine"] forState:UIControlStateNormal];
            
            PFFile* imageFile = (PFFile* ) _socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                imageProfile.image = [UIImage imageWithData:data];
            }];

            
        }
            break;
            
        case SocialMediaTypeInstagram: {
            InstagramModel *tempModel = (InstagramModel* ) _socialDict[GLOBAL_KEY_MODEL];
            [labelTitle setText:tempModel.captionText];
            [labelName setText:tempModel.username];
            [imageMain setImageWithURL:[NSURL URLWithString:tempModel.mainImage]];
            [imageProfile setImageWithURL:[NSURL URLWithString:tempModel.profile_picture]];
            [buttonComment setTitle:tempModel.commentCount forState:UIControlStateNormal];
            [buttonLike setTitle:tempModel.likesCount forState:UIControlStateNormal];
            
            NSTimeInterval timeInterval = (NSTimeInterval)  [tempModel.createdAt longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString* dateString = [dateFormatter stringFromDate:date];
            [labelCreatedAt setText:dateString];
            
            
                    }
            break;
            
        case SocialMediaTypeYoutube: {
            YouTubeModel *tempModel = (YouTubeModel* ) _socialDict[GLOBAL_KEY_MODEL];
            [labelName setText:tempModel.channelTitle];
            [labelTitle setText:tempModel.postTitle];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            NSDate* date = [dateFormatter dateFromString:tempModel.publishedAt];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            [labelCreatedAt setText:mydate];
            [imageMain setImageWithURL:[NSURL URLWithString:tempModel.urlThumb]];

            [buttonSocialIcon setImage:[UIImage imageNamed:@"Youtube"] forState:UIControlStateNormal];
            
            PFFile* imageFile = (PFFile* ) _socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                imageProfile.image = [UIImage imageWithData:data];
            }];
        }
            break;
            
        default:
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
