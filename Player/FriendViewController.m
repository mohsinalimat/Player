//
//  FriendViewController.m
//  Player
//
//  Created by Sina on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"
#import <QuartzCore/QuartzCore.h>

#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 

@interface FriendViewController () <UITextFieldDelegate>

@end

@implementation FriendViewController
@synthesize uislider;
@synthesize nameLabel;
@synthesize ratingSlider;
@synthesize phoneLabel;
@synthesize ratingLabel;
@synthesize relationshipLabel;
@synthesize emailLabel;
@synthesize friendsManager = _friendsManager;
@synthesize friend;


- (IBAction)ratingChange:(UISlider *)sender {

    int result;
    result = (int)roundf(sender.value);
    
    NSString *str = [NSString stringWithFormat:@"Rating: %d", result];
    ratingLabel.text = str;
    
    [self.friend setRating:[NSNumber numberWithFloat:uislider.value]];
    [self.friendsManager updateFriend:friend];
}

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
    
    UIImageView *imageView;
    if(INTERFACE_IS_PAD)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,20,300,300)];
    }else if(INTERFACE_IS_PHONE)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,140,140)];
    }
             
    
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 10;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageView];
    
    phoneLabel.delegate = self;
    emailLabel.delegate = self;
    
    nameLabel.text = friend.name;
    phoneLabel.text = friend.phoneNumber;
    emailLabel.text = friend.email;
    relationshipLabel.text = friend.relationshipStatus;
    
    int result;
    result = (int)roundf([friend.rating floatValue]);
    
    NSString *str = [NSString stringWithFormat:@"Rating: %d", result];
    ratingLabel.text = str;
    [uislider setValue:[friend.rating floatValue]];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == phoneLabel)
    {
        [self.friend setPhoneNumber:textField.text];
    }else if(textField == emailLabel)
    {
        [self.friend setEmail:textField.text];
    }
    
    [self.friendsManager updateFriend:friend];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self displayFriendInfo:[self.friendsManager currentFriendObject]];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setRatingSlider:nil];
    [self setRatingLabel:nil];
    [self setPhoneLabel:nil];
    [self setEmailLabel:nil];
    [self setRelationshipLabel:nil];
    [self setUislider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
    