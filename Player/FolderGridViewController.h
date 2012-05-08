//
//  FolderGridViewController.h
//  Player
//
//  Created by Sina on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderGridViewController : UIViewController
{
    NSMutableArray *groups;
}

@property (nonatomic,retain) NSMutableArray *groups;
-(void)setData:(NSArray*)groups;

@end
