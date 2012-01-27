//
//  FacebookViewController.m
//  Player
//
//  Created by Sina on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookViewController.h"
#import "FBRequest.h"
#import "ContactsTableViewController.h"

@implementation FacebookViewController
@synthesize profilePicImageView;
@synthesize activityIndicator;
@synthesize loginButton;
@synthesize logoutButton;
@synthesize facebook;
@synthesize facebookFriends;

- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"fbDidNotLogin");
}
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    NSLog(@"fbDidExtendToken");
}

- (void)fbSessionInvalidated
{
    NSLog(@"fbSessionInvalidated");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loginFacebook
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                @"publish_stream",
                                @"friends_photos",
                                nil];
        [facebook authorize:permissions];
    }else
    {
        [self fbDidLogin];
    }
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    loginButton.hidden = FALSE;
    logoutButton.enabled = FALSE;
    
    facebook = [[Facebook alloc] initWithAppId:@"285390884858630" andDelegate:self];
    [self loginFacebook];
    
    [super viewDidLoad];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"To Facebook Friends"])
    {
        if ([segue.destinationViewController isKindOfClass:[ContactsTableViewController class]])
        {
            [(ContactsTableViewController *)segue.destinationViewController setCreateWithArray:facebookFriends];
        }
    }
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)request:(FBRequest*)request didLoad:(id)result
{
    if(request == requestProfilePic)     
    {
        NSLog(@"FBDidLoad: ProfilePic");
        UIImage *image = [[UIImage alloc] initWithData:result];
        self.profilePicImageView.image = image;
        profilePicImageView.alpha = .4;
    }
    
    if(request == requestFriends)
    {
        NSLog(@"FBDidLoad: requestFriends");
        facebookFriends = [result objectForKey:@"data"];

        [self performSegueWithIdentifier:@"To Facebook Friends" sender:self];
        [activityIndicator stopAnimating];
        activityIndicator.hidden = YES;
    }
}

- (void)fbDidLogin 
{
    loginButton.hidden = TRUE;
    logoutButton.enabled = TRUE;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    requestFriends = [facebook requestWithGraphPath:@"me/friends?fields=name,picture" andDelegate:self];
    [activityIndicator startAnimating];
    activityIndicator.hidden = NO;
    
    requestProfilePic = [facebook requestWithGraphPath:@"me/picture?type=large" andDelegate:self];
}

- (IBAction)onClickLogIn:(id)sender {
    [self loginFacebook];
}

- (IBAction)onClickLogOut:(id)sender
{
    [facebook logout];
}

- (void) fbDidLogout 
{
    loginButton.hidden = FALSE;
    logoutButton.enabled = FALSE;
    
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)viewDidUnload {
    [self setLoginButton:nil];
    [self setLogoutButton:nil];
    [self setActivityIndicator:nil];
    [self setProfilePicImageView:nil];
    [super viewDidUnload];
}
@end
