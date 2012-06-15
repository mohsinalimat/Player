//
//  CreateNewGroupViewController.m
//  Player
//
//  Created by Sina on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateNewGroupViewController.h"
#import "FriendsManager.h"

@interface CreateNewGroupViewController ()

@property (nonatomic, strong) FriendsManager *friendsManager;

@end

@implementation CreateNewGroupViewController
@synthesize textField;
@synthesize friendsManager = _friendsManager;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onTapCreate:(id)sender {
    if(![self.textField.text isEqualToString:@""])
    {
        [self.friendsManager createGroupWithName:self.textField.text];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
@end
