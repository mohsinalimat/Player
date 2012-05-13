//
//  FriendViewController.m
//  Player
//
//  Created by Sina on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)displayFriendInfo:(Friend*)friend
{
    NSLog(@"%@", friend.name);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 100)];
    label.text = friend.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
