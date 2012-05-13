//
//  FriendsViewController_iPad.h
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "GMGridView.h"

@interface FriendsGridViewController : UIViewController
{

}

@property (nonatomic,strong) NSMutableArray *friends;
- (IBAction)onTapEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
