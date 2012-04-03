//
//  FriendsViewController_iPhone.h
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface FriendsViewController_iPhone : UITableViewController <UITableViewDelegate>
{
    NSMutableArray *friends;
    NSDictionary *_articleDictionary;
    NSMutableArray *_reusableCells;
    UIImageView *backgroundImageView;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)tapOnEdit:(id)sender;

@property (assign) NSMutableArray *friends;

@property (nonatomic, retain) NSDictionary *articleDictionary;
@property (nonatomic, retain) NSMutableArray *reusableCells;
@property (nonatomic, retain) UIImageView *backgroundImageView;



@end
