//
//  FacebookViewController.h
//  Player
//
//  Created by Sina on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface FacebookViewController : UIViewController <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate>
{
    Facebook *facebook;
    FBRequest *requestProfilePic;
    FBRequest *requestFriends;
}

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

- (IBAction)onClickLogIn:(id)sender;
- (IBAction)onClickLogOut:(id)sender;

@property (nonatomic, retain) Facebook *facebook; 

@property (nonatomic, retain) NSArray *facebookFriends;

@end
