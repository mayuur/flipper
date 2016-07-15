//
//  FeedViewController.m
//  flipper
//
//  Created by Mayur Joshi on 4/5/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "FeedViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "Categories.h"
#import "People.h"
#import "FeedDetailViewController.h"
#import "EditFeedViewController.h"

#import "FacebookModel.h"
#import "FBSDKCoreKit/FBSDKGraphRequest.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "FBSDKCoreKit/FBSDKAccessToken.h"
#import "PFFacebookUtils.h"
#import "FacebookCell.h"

#import "InstagramModel.h"
#import "InstagramCell.h"

#import "TwitterModel.h"
#import "TwitterFeedSharedManager.h"
#import "TwitterCell.h"

#import "VineModel.h"
#import "VineFeedSharedManager.h"
#import "VineCell.h"

#import "YouTubeModel.h"
#import "YoutubeSharedManager.h"
#import "YouTubeCell.h"

#import "ViewHeaderCell.h"

#define GLOBAL_KEY_SOCIAL_TYPE @"type"
#define GLOBAL_KEY_MODEL @"socialModel"
#define GLOBAL_KEY_POST_DATE @"postDate"
#define GLOBAL_KEY_DISPLAY_PIC @"displayPic"

#define IDENTIFIER_TWITTER_CELL @"TwitterCell"
#define IDENTIFIER_FACEBOOK_CELL @"FacebookCell"
#define IDENTIFIER_INSTAGRAM_CELL @"InstagramCell"
#define IDENTIFIER_VINE_CELL @"VineCell"
#define IDENTIFIER_YOUTUBE_CELL @"YouTubeCell"

@interface FeedViewController() <UITableViewDataSource,UITableViewDelegate,IGSessionDelegate,IGRequestDelegate>
{
    UIRefreshControl *refreshControlTable;
    AppDelegate* appDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *tableViewSocialFeed;
@property (nonatomic, strong) NSMutableArray* arrayAllSocial;

@end

@implementation FeedViewController

#pragma mark - General methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    refreshControlTable = [[UIRefreshControl alloc]init];
    [refreshControlTable addTarget:self action:@selector(getCelebritiesFollowedByUser) forControlEvents:UIControlEventValueChanged];
    [self.tableViewSocialFeed addSubview:refreshControlTable];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    self.arrayAllSocial = [NSMutableArray arrayWithCapacity:0];
    
    _tableViewSocialFeed.estimatedRowHeight = 60.0;
    _tableViewSocialFeed.rowHeight = UITableViewAutomaticDimension;
    
    [_tableViewSocialFeed registerNib:[UINib nibWithNibName:@"TwitterCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER_TWITTER_CELL];
    [_tableViewSocialFeed registerNib:[UINib nibWithNibName:@"VineCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER_VINE_CELL];
    [_tableViewSocialFeed registerNib:[UINib nibWithNibName:@"YouTubeCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER_YOUTUBE_CELL];
    [_tableViewSocialFeed registerNib:[UINib nibWithNibName:@"InstagramCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER_INSTAGRAM_CELL];
    [_tableViewSocialFeed registerNib:[UINib nibWithNibName:@"FacebookCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER_FACEBOOK_CELL];

    
    
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] && [[NSUserDefaults standardUserDefaults] objectForKey:@"isInstaAuthShown"] == nil) {
        [self showInstaAuthentication];
    }
    
    
    
    if([Utility isNetAvailable]) {
        if(self.isForFeedDetail) {
            UIBarButtonItem *editFeedButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                               style:UIBarButtonItemStyleDone target:self action:@selector(editFeedButtonClicked:)];
            self.navigationItem.rightBarButtonItem = editFeedButton;
            [self getDataForCelebrity];
        }
        else {
            [self getCelebritiesFollowedByUser];
        }
        
    }else {
        [UIAlertView addDismissableAlertWithText:@"No Internet Connection" OnController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!self.isForFeedDetail) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if(self.isForFeedDetail && self.needsUpdate) {
        self.needsUpdate = NO;
        [self.arrayAllSocial removeAllObjects];
        [self.tableViewSocialFeed reloadData];
        [self getDataForCelebrity];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void) refreshTableView {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:GLOBAL_KEY_POST_DATE ascending:NO];
    self.arrayAllSocial = [NSMutableArray arrayWithArray:[self.arrayAllSocial sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]];
    [_tableViewSocialFeed reloadData];
}

- (void) getCelebritiesFollowedByUser {
    //get all the celebrities followed by this user
    NSPredicate* userPredicate = [NSPredicate predicateWithFormat:@"fk_user_id = %@", [PFUser currentUser].objectId];
    PFQuery *fetchCelebrityQuery = [PFQuery queryWithClassName:@"User_People" predicate:userPredicate];
    [fetchCelebrityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable parentObjects, NSError * _Nullable error) {
        [refreshControlTable endRefreshing];
        NSArray* arrayCelebrities = [parentObjects valueForKey:@"fk_people_id"];
        
        PFQuery* fetchCelebDetailsQuery = [PFQuery queryWithClassName:@"People"];
        [fetchCelebDetailsQuery whereKey:@"objectId" containedIn:arrayCelebrities];
        [fetchCelebDetailsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable peopleObjects, NSError * _Nullable error) {
            if(!error){
                for (People* people in peopleObjects) {
//                    NSLog(@"FacebookID - %@\nTwitterHandle - %@\nYoutubePlaylistID - %@\nInstagramID - %@\nVineID - %@\n",people.facebook_page_id, people.twitter_handle_name, people.youtube_playlist_id, people.instagram_user_id, people.vine_page_id);

                    PFQuery* fetchFeedSettings = [PFQuery queryWithClassName:@"User_People"];
                    [fetchFeedSettings whereKey:@"fk_user_id" equalTo:[PFUser currentUser].objectId];
                    [fetchFeedSettings whereKey:@"fk_people_id" equalTo:people.objectId];
                    
                    [fetchFeedSettings findObjectsInBackgroundWithBlock:^(NSArray * _Nullable feedObjects, NSError * _Nullable error) {
                        if(!error && feedObjects.count > 0) {
                            PFObject* user_settings = feedObjects[0];
                            if([[user_settings objectForKey:@"followsFacebook"] boolValue]) {
                                [self fetchDataForFacebook:people.facebook_page_id withImageFile:people.person_image];
                            }
                            
                            if([[user_settings objectForKey:@"followsTwitter"] boolValue]) {
                                [self fetchDataForTwitter:people.twitter_handle_name withImageFile:people.person_image];
                            }
                            
                            if([[user_settings objectForKey:@"followsInstagram"] boolValue]) {
                                [self fetchDataFromInstagram:people.instagram_user_id withImageFile:people.person_image];
                            }
                            
                            if([[user_settings objectForKey:@"followsVine"] boolValue]) {
                                [self fetchDataForVine:people.vine_page_id withImageFile:people.person_image];
                            }
                            
                            if([[user_settings objectForKey:@"followsYoutube"] boolValue]) {
                                [self fetchDataForYoutube:people.youtube_playlist_id withImageFile:people.person_image];
                            }
                        }
                    }];
                }
            }
            else {
                NSLog(@"Error:%@",error.localizedDescription);
            }
        }];
    }];
}

- (void) getDataForCelebrity {
    NSMutableArray* arrayCelebrities = [NSMutableArray arrayWithCapacity:0];
    [arrayCelebrities addObject:self.celebrity.objectId];
    
    self.title = self.celebrity.person_name;
    
    PFQuery* fetchCelebDetailsQuery = [PFQuery queryWithClassName:@"People"];
    [fetchCelebDetailsQuery whereKey:@"objectId" containedIn:arrayCelebrities];
    [fetchCelebDetailsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable peopleObjects, NSError * _Nullable error) {
        if(!error){
            for (People* people in peopleObjects) {
//                NSLog(@"FacebookID - %@\nTwitterHandle - %@\nYoutubePlaylistID - %@\nInstagramID - %@\nVineID - %@\n",people.facebook_page_id, people.twitter_handle_name, people.youtube_playlist_id, people.instagram_user_id, people.vine_page_id);
                
                PFQuery* fetchFeedSettings = [PFQuery queryWithClassName:@"User_People"];
                [fetchFeedSettings whereKey:@"fk_user_id" equalTo:[PFUser currentUser].objectId];
                [fetchFeedSettings whereKey:@"fk_people_id" equalTo:people.objectId];
                
                [fetchFeedSettings findObjectsInBackgroundWithBlock:^(NSArray * _Nullable feedObjects, NSError * _Nullable error) {
                    if(!error && feedObjects.count > 0) {
                        PFObject* user_settings = feedObjects[0];
                        if([[user_settings objectForKey:@"followsFacebook"] boolValue]) {
                            [self fetchDataForFacebook:people.facebook_page_id withImageFile:people.person_image];
                        }
                        
                        if([[user_settings objectForKey:@"followsTwitter"] boolValue]) {
                            [self fetchDataForTwitter:people.twitter_handle_name withImageFile:people.person_image];
                        }
                        
                        if([[user_settings objectForKey:@"followsInstagram"] boolValue]) {
                            [self fetchDataFromInstagram:people.instagram_user_id withImageFile:people.person_image];
                        }
                        
                        if([[user_settings objectForKey:@"followsVine"] boolValue]) {
                            [self fetchDataForVine:people.vine_page_id withImageFile:people.person_image];
                        }
                        
                        if([[user_settings objectForKey:@"followsYoutube"] boolValue]) {
                            [self fetchDataForYoutube:people.youtube_playlist_id withImageFile:people.person_image];
                        }
                    }
                }];
                
            }
        }
        else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

-(void)showInstaAuthentication {
    UIAlertController *instaAuthAlert = [UIAlertController alertControllerWithTitle:@"Connect to Instagram?" message:@"Would like to connect your Instagram Account?" preferredStyle:UIAlertControllerStyleAlert];
    
    [instaAuthAlert addAction:[UIAlertAction actionWithTitle:@"Connect" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"public_content", @"comments", @"likes", nil]];
    }]];
    
    [instaAuthAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self.navigationController presentViewController:instaAuthAlert animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"isInstaAuthShown"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];
}

-(void)openLink:(UIButton *)button {
    NSMutableDictionary* socialDict = self.arrayAllSocial[button.tag];
    NSInteger socialType = [socialDict[GLOBAL_KEY_SOCIAL_TYPE] integerValue];
    NSURL *feedLink;
    switch (socialType) {
        case SocialMediaTypeFacebook: {
            
            FacebookModel *tempModel = (FacebookModel* ) socialDict[GLOBAL_KEY_MODEL];
            feedLink = [NSURL URLWithString:tempModel.link];
        }
        break;
            
        case SocialMediaTypeTwitter: {
            TwitterModel *tempModel = (TwitterModel* ) socialDict[GLOBAL_KEY_MODEL];
            feedLink = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@/status/%@",tempModel.name,tempModel.tweetId]];
        }
        break;
            
        case SocialMediaTypeInstagram: {
            InstagramModel *tempModel = (InstagramModel* ) socialDict[GLOBAL_KEY_MODEL];
            feedLink = [NSURL URLWithString:tempModel.link];
        }
        break;
            
        case SocialMediaTypeYoutube: {
            YouTubeModel *tempModel = (YouTubeModel* ) socialDict[GLOBAL_KEY_MODEL];
            NSString *urlString = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@&list=%@",tempModel.videoId,tempModel.playlistId];
            feedLink = [NSURL URLWithString:urlString];
        }
        break;
            
        case SocialMediaTypeVine: {
            VineModel *tempModel = (VineModel *) socialDict[GLOBAL_KEY_MODEL];
            feedLink = [NSURL URLWithString:tempModel.vineLink];
        }
            break;
            
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:feedLink]) {
        [[UIApplication sharedApplication] openURL:feedLink];
    }
}

#pragma mark - Data Fetch Functions
- (void) fetchDataForYoutube : (NSString* ) playlistID withImageFile:(PFFile* ) imageFile {
    [[YoutubeSharedManager manager] getTimeLineByScreenName:playlistID pageSize:5 Success:^(id responseObject) {
//        NSLog(@"ResponseObject >> %@", responseObject);
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        for (NSDictionary *tempDict in [(NSDictionary *)responseObject objectForKey:@"items"]) {
            YouTubeModel *objYouTubeModel = [[YouTubeModel alloc]initWithDictionary:tempDict];
            
            NSMutableDictionary* socialDict = [NSMutableDictionary dictionaryWithCapacity:0];
            [socialDict setObject:[NSString stringWithFormat:@"%ld", (long) SocialMediaTypeYoutube] forKey:GLOBAL_KEY_SOCIAL_TYPE];
            [socialDict setObject:objYouTubeModel forKey:GLOBAL_KEY_MODEL];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            NSDate* date = [dateFormatter dateFromString:objYouTubeModel.publishedAt];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = [dateFormatter stringFromDate:date];
            
            [socialDict setObject:dateString forKey:GLOBAL_KEY_POST_DATE];
            [socialDict setObject:imageFile forKey:GLOBAL_KEY_DISPLAY_PIC];

            [self.arrayAllSocial addObject:socialDict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshTableView];
        });
    } error:^(NSError *error) {
        NSLog(@"Error >> %@", error);
    }];
}

- (void) fetchDataForVine: (NSString* ) vineID withImageFile:(PFFile* ) imageFile {
    [[VineFeedSharedManager manager] getTimeLineByScreenName:vineID pageSize:5 Success:^(id responseObject) {
//        NSLog(@"ResponseObject >> %@", responseObject);
        if([(NSDictionary *)responseObject objectForKey:@"success"]) {
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            
            for (NSDictionary *tempDict in [[(NSDictionary *)responseObject objectForKey:@"data"] objectForKey:@"records"]) {
                VineModel *objVineModel = [[VineModel alloc]initWithDictionary:tempDict];
                
                NSMutableDictionary* socialDict = [NSMutableDictionary dictionaryWithCapacity:0];
                [socialDict setObject:[NSString stringWithFormat:@"%ld", (long) SocialMediaTypeVine] forKey:GLOBAL_KEY_SOCIAL_TYPE];
                [socialDict setObject:objVineModel forKey:GLOBAL_KEY_MODEL];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
                NSDate* date = [dateFormatter dateFromString:objVineModel.createdAt];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString* dateString = [dateFormatter stringFromDate:date];
                [socialDict setObject:dateString forKey:GLOBAL_KEY_POST_DATE];
                [socialDict setObject:imageFile forKey:GLOBAL_KEY_DISPLAY_PIC];

                [self.arrayAllSocial addObject:socialDict];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshTableView];
            });
        }
    } error:^(NSError *error) {
        NSLog(@"Error >> %@", error);
    }];
}

- (void) fetchDataForTwitter : (NSString* ) handleName withImageFile:(PFFile* ) imageFile {
    [[TwitterFeedSharedManager manager] getTimeLineByScreenName:handleName pageSize:15 Success:^(id responseObject) {
//        NSLog(@"ResponseObject >> %@", responseObject);
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        for (NSDictionary *dict in responseObject) {
            
            TwitterModel *objTwitterModel = [[TwitterModel alloc]initWithDictionary:dict];
            
            NSMutableDictionary* socialDict = [NSMutableDictionary dictionaryWithCapacity:0];
            [socialDict setObject:[NSString stringWithFormat:@"%ld", (long) SocialMediaTypeTwitter] forKey:GLOBAL_KEY_SOCIAL_TYPE];
            [socialDict setObject:objTwitterModel forKey:GLOBAL_KEY_MODEL];
            
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            NSDate* date = [dateFormatter dateFromString:objTwitterModel.createdAt];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = [dateFormatter stringFromDate:date];
            [socialDict setObject:dateString forKey:GLOBAL_KEY_POST_DATE];
            [socialDict setObject:imageFile forKey:GLOBAL_KEY_DISPLAY_PIC];
            [self.arrayAllSocial addObject:socialDict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshTableView];
        });
        
    } error:^(NSError *error) {
        NSLog(@"Error >> %@", error);
    }];
}

-(void)fetchDataFromInstagram: (NSString* ) userID withImageFile:(PFFile* ) imageFile {
    
    
    appDelegate.instagram.sessionDelegate = self;
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"IGAccessToken"];
    
    // here i can set accessToken received on previous login
    if ([appDelegate.instagram isSessionValid]) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/media/recent", userID], @"method", nil];
        [appDelegate.instagram requestWithParams:params
                                        delegate:self];
    } else {
        //[appDelegate.instagram authorize:[NSArray arrayWithObjects:@"public_content", @"comments", @"likes", nil]];
    }
}

- (void) fetchDataForFacebook : (NSString* ) pageID withImageFile:(PFFile* ) imageFile {
    
    if(![FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id, name, email" forKey:@"fields"];
             
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 
                 [self fetchDataForFacebook:pageID withImageFile:imageFile];
             }
         }];
    }
    else {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[NSString stringWithFormat:@"/%@/feed", pageID]
                                      parameters:@{@"fields": @"id, message,full_picture,link,name,caption,description,icon,created_time,from,likes.summary(true),comments.summary(true)"}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            // Handle the result
            NSDictionary *dictionaryResult = (NSDictionary *)result;
            NSArray *tempArray = [dictionaryResult objectForKey:@"data"];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            
            for (NSDictionary *tempDictionary in tempArray) {
                FacebookModel *objFacebookModel = [[FacebookModel alloc]initWithDictionary:tempDictionary];
                
                NSMutableDictionary* socialDict = [NSMutableDictionary dictionaryWithCapacity:0];
                [socialDict setObject:[NSString stringWithFormat:@"%ld", (long) SocialMediaTypeFacebook] forKey:GLOBAL_KEY_SOCIAL_TYPE];
                [socialDict setObject:objFacebookModel forKey:GLOBAL_KEY_MODEL];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                NSDate *date = [dateFormatter dateFromString:objFacebookModel.createdTime];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString* dateString = [dateFormatter stringFromDate:date];
                [socialDict setObject:dateString forKey:GLOBAL_KEY_POST_DATE];
                [socialDict setObject:imageFile forKey:GLOBAL_KEY_DISPLAY_PIC];
                [self.arrayAllSocial addObject:socialDict];
            }
            
            [self refreshTableView];
        }];
    }
}

#pragma mark - Instagram
#pragma mark - IGRequestDelegate

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
//    [alertView show];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"Instagram did load: %@", result);
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    for (NSArray *tempArray in (NSArray*)[result objectForKey:@"data"]) {
        InstagramModel *objInstagramModel = [[InstagramModel alloc]initWithDictionary:(NSDictionary *)tempArray];
        
        NSMutableDictionary* socialDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [socialDict setObject:[NSString stringWithFormat:@"%ld", (long) SocialMediaTypeInstagram] forKey:GLOBAL_KEY_SOCIAL_TYPE];
        [socialDict setObject:objInstagramModel forKey:GLOBAL_KEY_MODEL];
        
        NSTimeInterval timeInterval = (NSTimeInterval)  [objInstagramModel.createdAt longLongValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [dateFormatter stringFromDate:date];
        [socialDict setObject:dateString forKey:GLOBAL_KEY_POST_DATE];
        [socialDict setObject:@"" forKey:GLOBAL_KEY_DISPLAY_PIC];
        [self.arrayAllSocial addObject:socialDict];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTableView];
    });
}

#pragma mark - IGSessionDelegate functions

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"IGAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}

#pragma mark - Facebook
#pragma mark -

-(void)loginWithFacebook {
    
    if(![FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id, name, email" forKey:@"fields"];
             
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 
                 //[self fetchDataForFacebook];
             }
         }];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayAllSocial.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary* socialDict = self.arrayAllSocial[indexPath.section];
    NSInteger socialType = [socialDict[GLOBAL_KEY_SOCIAL_TYPE] integerValue];
    switch (socialType) {
        case SocialMediaTypeFacebook: {
            FacebookCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FACEBOOK_CELL];
            cell.buttonMainImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            cell.buttonMainImage.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            
            FacebookModel *tempModel = (FacebookModel* ) socialDict[GLOBAL_KEY_MODEL];
            cell.labelName.text = tempModel.pageName;
            cell.labelTitle.text = tempModel.message;
            
//            [cell.imageMain setImageWithURL:[NSURL URLWithString:tempModel.picture]];
            
            if(tempModel.picture.length > 0) {
                cell.imageMainHeightConstraint.constant = 250;
                [[cell.buttonMainImage imageView]setContentMode:UIViewContentModeScaleAspectFill];
                
                [cell.buttonMainImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:tempModel.picture]];
                cell.buttonMainImage.tag = indexPath.row;
                [cell.buttonMainImage addTarget:self action:@selector(buttonMainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else {
                cell.imageMainHeightConstraint.constant = 0;
                [cell.buttonMainImage setImage:nil forState:UIControlStateNormal];
            }
            [cell.buttonComment setTitle:tempModel.totalComments forState:UIControlStateNormal];
            [cell.buttonLike setTitle:tempModel.totalLikes forState:UIControlStateNormal];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            NSDate* date = [dateFormatter dateFromString:tempModel.createdTime];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hhmm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            [cell.labelCreatedAt setText:mydate];
            
            [cell.buttonShare addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonShare setTag:indexPath.section];
           
            return cell;
        }
            break;
            
        case SocialMediaTypeTwitter: {
            TwitterCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_TWITTER_CELL];
            cell.buttonMainImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            cell.buttonMainImage.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

            TwitterModel *tempModel = (TwitterModel* ) socialDict[GLOBAL_KEY_MODEL];
            cell.labelName.text = [NSString stringWithFormat:@"%@", tempModel.name];
            cell.labelTweet.text = [NSString stringWithFormat:@"%@", tempModel.twitterText];
            NSString *dateString = [NSString stringWithFormat:@"%@", tempModel.createdAt];
            NSDateFormatter *dateFormatter= [NSDateFormatter new];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            dateFormatter =[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            cell.labelCreatedAt.text = [NSString stringWithFormat:@"%@", mydate];
            [cell.buttonFavorite setTitle:[NSString stringWithFormat:@"%@", tempModel.favoriteCount] forState:UIControlStateNormal];
            [cell.buttonRetweet setTitle:[NSString stringWithFormat:@"%@", tempModel.retweetCount] forState:UIControlStateNormal];
            if(tempModel.tweetImage.length > 0) {
                cell.imageMainHeightConstraint.constant = 250;
                [[cell.buttonMainImage imageView]setContentMode:UIViewContentModeScaleAspectFill];
                
                [cell.buttonMainImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:tempModel.tweetImage]];

                cell.buttonMainImage.tag = indexPath.row;
                [cell.buttonMainImage addTarget:self action:@selector(buttonMainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else {
                [cell.buttonMainImage setImage:nil forState:UIControlStateNormal];
                cell.imageMainHeightConstraint.constant = 0;
            }
            return cell;
        }
            break;
            
        case SocialMediaTypeVine: {
            VineCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_VINE_CELL];
            cell.buttonMainImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            cell.buttonMainImage.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

            VineModel *tempModel = (VineModel* ) socialDict[GLOBAL_KEY_MODEL];
            [cell.labelUserName setText:tempModel.username];
            [cell.labelDescription setText:tempModel.vineDescription];
            [cell.buttonComment setTitle:tempModel.commentCount forState:UIControlStateNormal];
            [cell.buttonLike setTitle:tempModel.likes forState:UIControlStateNormal];
            [cell.imageAvatar setImageWithURL:[NSURL URLWithString:tempModel.urlAvatar]];
            [cell.imageThumb setImageWithURL:[NSURL URLWithString:tempModel.urlThumb]];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
            NSDate* date = [dateFormatter dateFromString:tempModel.createdAt];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            [cell.labelCreatedAt setText:mydate];
            
            if(tempModel.urlThumb.length > 0) {
                cell.imageMainHeightConstraint.constant = 250;
                [[cell.buttonMainImage imageView]setContentMode:UIViewContentModeScaleAspectFill];
                
                [cell.buttonMainImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:tempModel.urlThumb]];
                cell.buttonMainImage.tag = indexPath.row;
                [cell.buttonMainImage addTarget:self action:@selector(buttonMainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else {
                cell.imageMainHeightConstraint.constant = 0;
                [cell.buttonMainImage setImage:nil forState:UIControlStateNormal];
            }
            return cell;
        }
            break;
            
        case SocialMediaTypeInstagram: {
            InstagramCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_INSTAGRAM_CELL];
            cell.buttonMainImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            cell.buttonMainImage.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

            InstagramModel *tempModel = (InstagramModel* ) socialDict[GLOBAL_KEY_MODEL];
            [cell.labelCaption setText:tempModel.captionText];
            [cell.labelUserName setText:tempModel.username];
            
//            [cell.imageMain setImageWithURL:[NSURL URLWithString:tempModel.mainImage]];
            if(tempModel.mainImage.length > 0) {
                cell.imageMainHeightConstraint.constant = 250;
                [[cell.buttonMainImage imageView]setContentMode:UIViewContentModeScaleAspectFill];
                
                [cell.buttonMainImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:tempModel.mainImage]];
                cell.buttonMainImage.tag = indexPath.row;
                [cell.buttonMainImage addTarget:self action:@selector(buttonMainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                cell.imageMainHeightConstraint.constant = 0;
                [cell.buttonMainImage setImage:nil forState:UIControlStateNormal];
            }
            [cell.imageProfile setImageWithURL:[NSURL URLWithString:tempModel.profile_picture]];
            [cell.buttonComment setTitle:tempModel.commentCount forState:UIControlStateNormal];
            [cell.buttonFavorite setTitle:tempModel.likesCount forState:UIControlStateNormal];
            
            NSTimeInterval timeInterval = (NSTimeInterval)  [tempModel.createdAt longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString* dateString = [dateFormatter stringFromDate:date];
            [cell.labelCreatedAt setText:dateString];
            
            return cell;
        }
            break;
            
        case SocialMediaTypeYoutube: {
            YouTubeCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_YOUTUBE_CELL];
            cell.buttonMainImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            cell.buttonMainImage.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

            YouTubeModel *tempModel = (YouTubeModel* ) socialDict[GLOBAL_KEY_MODEL];
            [cell.labelName setText:tempModel.channelTitle];
            [cell.labelDescription setText:tempModel.postTitle];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            NSDate* date = [dateFormatter dateFromString:tempModel.publishedAt];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            [cell.labelCreatedAt setText:mydate];
//            [cell.imageMain setImageWithURL:[NSURL URLWithString:tempModel.urlThumb]];
            if(tempModel.urlThumb.length > 0){
                cell.imageMainHeightConstraint.constant = 250;
                [[cell.buttonMainImage imageView]setContentMode:UIViewContentModeScaleAspectFill];
                
                [cell.buttonMainImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:tempModel.urlThumb]];
                cell.buttonMainImage.tag = indexPath.row;
                [cell.buttonMainImage addTarget:self action:@selector(buttonMainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else {
                cell.imageMainHeightConstraint.constant = 0;
                [cell.buttonMainImage setImage:nil forState:UIControlStateNormal];
            }
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ViewHeaderCell* headerView = [[[NSBundle mainBundle] loadNibNamed:@"ViewHeaderCell" owner:self options:nil] objectAtIndex:0];
    
    NSMutableDictionary* socialDict = self.arrayAllSocial[section];
    NSInteger socialType = [socialDict[GLOBAL_KEY_SOCIAL_TYPE] integerValue];
    switch (socialType) {
        case SocialMediaTypeFacebook: {
            FacebookModel *tempModel = (FacebookModel* ) socialDict[GLOBAL_KEY_MODEL];
            headerView.labelHeader.text = tempModel.pageName;
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            NSDate* date = [dateFormatter dateFromString:tempModel.createdTime];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            headerView.labelDate.text = [NSString stringWithFormat:@"%@", mydate];
            
            [headerView.buttonSocialIcon setImage:[UIImage imageNamed:@"Facebook"] forState:UIControlStateNormal];
            
            PFFile* imageFile = (PFFile* ) socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                headerView.imageViewProfile.image = [UIImage imageWithData:data];
            }];
        }
            break;
            
        case SocialMediaTypeTwitter: {
            TwitterModel *tempModel = (TwitterModel* ) socialDict[GLOBAL_KEY_MODEL];
            headerView.labelHeader.text = [NSString stringWithFormat:@"%@", tempModel.name];
            
            NSString *dateString = [NSString stringWithFormat:@"%@", tempModel.createdAt];
            NSDateFormatter *dateFormatter= [NSDateFormatter new];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            dateFormatter =[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            headerView.labelDate.text = [NSString stringWithFormat:@"%@", mydate];
            
            [headerView.buttonSocialIcon setImage:[UIImage imageNamed:@"Twitter"] forState:UIControlStateNormal];
            
            PFFile* imageFile = (PFFile* ) socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                headerView.imageViewProfile.image = [UIImage imageWithData:data];
            }];
        }
            break;
            
        case SocialMediaTypeVine: {
            VineModel *tempModel = (VineModel* ) socialDict[GLOBAL_KEY_MODEL];
            
            headerView.labelHeader.text = [NSString stringWithFormat:@"%@", tempModel.username];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
            NSDate* date = [dateFormatter dateFromString:tempModel.createdAt];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            headerView.labelDate.text = mydate;
            
            [headerView.buttonSocialIcon setImage:[UIImage imageNamed:@"Vine"] forState:UIControlStateNormal];
            
            PFFile* imageFile = (PFFile* ) socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                headerView.imageViewProfile.image = [UIImage imageWithData:data];
            }];
        }
            break;
            
        case SocialMediaTypeInstagram: {
            InstagramModel *tempModel = (InstagramModel* ) socialDict[GLOBAL_KEY_MODEL];
            headerView.labelHeader.text = [NSString stringWithFormat:@"%@", tempModel.username];
            
            NSTimeInterval timeInterval = (NSTimeInterval)  [tempModel.createdAt longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString* dateString = [dateFormatter stringFromDate:date];
            headerView.labelDate.text = dateString;
            
            [headerView.buttonSocialIcon setImage:[UIImage imageNamed:@"Instagram"] forState:UIControlStateNormal];
            
            /*PFFile* imageFile = (PFFile* ) socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                headerView.imageViewProfile.image = [UIImage imageWithData:data];
            }];*/
        }
            break;
            
        case SocialMediaTypeYoutube: {
            YouTubeModel *tempModel = (YouTubeModel* ) socialDict[GLOBAL_KEY_MODEL];
            headerView.labelHeader.text = [NSString stringWithFormat:@"%@", tempModel.channelTitle];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            NSDate* date = [dateFormatter dateFromString:tempModel.publishedAt];
            [dateFormatter setDateFormat:@"dd MMMM' at 'hh:mm a"];
            NSString *mydate=[dateFormatter stringFromDate:date];
            headerView.labelDate.text = mydate;
            
            [headerView.buttonSocialIcon setImage:[UIImage imageNamed:@"Youtube"] forState:UIControlStateNormal];
            
            PFFile* imageFile = (PFFile* ) socialDict[GLOBAL_KEY_DISPLAY_PIC];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                headerView.imageViewProfile.image = [UIImage imageWithData:data];
            }];
        }
            break;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSMutableDictionary* socialDict = self.arrayAllSocial[indexPath.section];
//    NSInteger socialType = [socialDict[GLOBAL_KEY_SOCIAL_TYPE] integerValue];
//    switch (socialType) {
//        case SocialMediaTypeFacebook: {
//            FacebookModel *tempModel = (FacebookModel* ) socialDict[GLOBAL_KEY_MODEL];
//            if(tempModel.picture.length > 0) {
//                return 210;
//            }
//        }
//            break;
//            
//        case SocialMediaTypeTwitter: {
//            TwitterModel *tempModel = (TwitterModel* ) socialDict[GLOBAL_KEY_MODEL];
//            if(tempModel.tweetImage.length > 0) {
//                return UITableViewAutomaticDimension;
//            }
//        }
//            break;
//            
//        case SocialMediaTypeVine: {
//            VineModel *tempModel = (VineModel* ) socialDict[GLOBAL_KEY_MODEL];
//            if([tempModel urlThumb].length > 0) {
//                return 210;
//            }
//        }
//            break;
//            
//        case SocialMediaTypeInstagram: {
//            InstagramModel *tempModel = (InstagramModel* ) socialDict[GLOBAL_KEY_MODEL];
//            if([tempModel mainImage].length > 0) {
//                return 210;
//            }
//        }
//            break;
//            
//        case SocialMediaTypeYoutube: {
//            YouTubeModel *tempModel = (YouTubeModel* ) socialDict[GLOBAL_KEY_MODEL];
//            if([tempModel urlThumb].length > 0) {
//                return 210;
//            }
//        }
//            break;
//    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* socialDict = self.arrayAllSocial[indexPath.section];
    FeedDetailViewController *feedDetail = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"FeedDetailViewController"];
    feedDetail.socialDict = socialDict;
    [self.navigationController pushViewController:feedDetail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButton Events

-(void)buttonMainImageClicked:(UIButton *)sender {
    NSMutableDictionary* socialDict = self.arrayAllSocial[sender.tag];
    NSInteger socialType = [socialDict[GLOBAL_KEY_SOCIAL_TYPE] integerValue];
    switch (socialType) {
        case SocialMediaTypeFacebook: {
            FacebookModel *tempModel = (FacebookModel* ) socialDict[GLOBAL_KEY_MODEL];
            if(tempModel.link.length > 0) {
                NSURL *url = [NSURL URLWithString:tempModel.link];
                if([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else {
                FeedDetailViewController *feedDetail = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"FeedDetailViewController"];
                feedDetail.socialDict = socialDict;
                [self.navigationController pushViewController:feedDetail animated:YES];
            }
        }
            break;
            
        case SocialMediaTypeTwitter: {
            TwitterModel *tempModel = (TwitterModel* ) socialDict[GLOBAL_KEY_MODEL];
            if(tempModel.tweetImage.length > 0) {

            }
        }
            break;
            
        case SocialMediaTypeVine: {
            VineModel *tempModel = (VineModel* ) socialDict[GLOBAL_KEY_MODEL];
            if([tempModel vineLink].length > 0) {
                NSURL *url = [NSURL URLWithString:tempModel.vineLink];
                if([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else {
                FeedDetailViewController *feedDetail = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"FeedDetailViewController"];
                feedDetail.socialDict = socialDict;
                [self.navigationController pushViewController:feedDetail animated:YES];

            }
        }
            break;
            
        case SocialMediaTypeInstagram: {
            InstagramModel *tempModel = (InstagramModel* ) socialDict[GLOBAL_KEY_MODEL];
            if([tempModel link].length > 0) {
                NSURL *url = [NSURL URLWithString:tempModel.link];
                if([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else {
                FeedDetailViewController *feedDetail = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"FeedDetailViewController"];
                feedDetail.socialDict = socialDict;
                [self.navigationController pushViewController:feedDetail animated:YES];
            }
        }
            break;
            
        case SocialMediaTypeYoutube: {
            YouTubeModel *tempModel = (YouTubeModel* ) socialDict[GLOBAL_KEY_MODEL];
            if([tempModel urlThumb].length > 0) {

            }
        }
            break;
    }
    

}

- (void) editFeedButtonClicked : (id) sender {
    EditFeedViewController* editFeedController = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"EditFeedViewController"];
    editFeedController.celebrity = self.celebrity;
    editFeedController.parentFeedViewController = self;
    [self.navigationController pushViewController:editFeedController animated:YES];
}

@end
