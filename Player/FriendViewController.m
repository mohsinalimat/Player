//
//  FriendViewController.m
//  Player
//
//  Created by Sina on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    NSURL *imageURL = [NSURL URLWithString:[friend imageURL_iPad]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,20,200,200)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 10;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(240, 20, 400, 100)];
    //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = [friend name];
    label.textAlignment = UITextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.highlightedTextColor = [UIColor grayColor];
    //if (INTERFACE_IS_PHONE)
    //   label.font = [UIFont boldSystemFontOfSize:10];
    //else
        label.font = [UIFont boldSystemFontOfSize:30];
    //label.shadowColor = [UIColor blackColor];
    //label.shadowOffset = CGSizeMake(1, 2);
    [self.view addSubview:label];
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
