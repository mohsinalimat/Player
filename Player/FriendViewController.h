//
//  FriendViewController.h
//  Player
//
//  Created by Sina on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "FriendsManager.h"

@interface FriendViewController : UIViewController

-(void)displayFriendInfo:(Friend*)friend;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISlider *ratingSlider;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationshipLabel;

@property (nonatomic, strong) FriendsManager *friendsManager;
@property (nonatomic, strong) Friend *friend;
@property (weak, nonatomic) IBOutlet UISlider *uislider;

- (IBAction)ratingChange:(UISlider *)sender;

@end
