//
//  FriendViewController.m
//  Player
//
//  Created by Sina on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FriendViewController () <UITextFieldDelegate>

@end

@implementation FriendViewController
@synthesize nameLabel;
@synthesize ratingSlider;
@synthesize phoneLabel;
@synthesize ratingLabel;
@synthesize relationshipLabel;
@synthesize emailLabel;
@synthesize friendsManager = _friendsManager;
@synthesize friend;

- (FriendsManager *)friendsManager
{
    if (!_friendsManager) _friendsManager = [FriendsManager sharedManager];
    return _friendsManager;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)displayFriendInfo:(Friend*)newFriend
{
    self.friend = newFriend;
    
    NSURL *imageURL = [NSURL URLWithString:[friend imageURL_iPad]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,20,300,300)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 10;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageView];
    
    phoneLabel.delegate = self;
    emailLabel.delegate = self;
    
    NSLog(@"Number: %@", friend.phoneNumber);
    
    nameLabel.text = friend.name;
    phoneLabel.text = friend.phoneNumber;
    emailLabel.text = friend.email;
    relationshipLabel.text = friend.relationshipStatus;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == phoneLabel)
    {
        NSLog(@"Phone Number");
        [self.friend setPhoneNumber:textField.text];
    }else if(textField == emailLabel)
    {
        NSLog(@"Email");
        [self.friend setEmail:textField.text];
    }
    
    [self.friendsManager updateFriend:friend];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setRatingSlider:nil];
    [self setRatingLabel:nil];
    [self setPhoneLabel:nil];
    [self setEmailLabel:nil];
    [self setRelationshipLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
    