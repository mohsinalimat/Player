//
//  NewGroupPopOverViewController.m
//  Player
//
//  Created by Sina on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewGroupPopOverViewController.h"

@interface NewGroupPopOverViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation NewGroupPopOverViewController

@synthesize delegate = _delegate;
@synthesize textField = _textField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_delegate != nil) {
        NSString *name = textField.text;
        [_delegate createGroupWithName:name];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(200, 140.0);
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 180, 20)];
    [self.textField setBackgroundColor:[UIColor whiteColor]];
    [self.textField setPlaceholder:@"Group Name"];
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
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

- (void)dealloc
{
    self.delegate = nil;
}

@end



