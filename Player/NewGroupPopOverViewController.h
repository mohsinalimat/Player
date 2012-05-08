//
//  NewGroupPopOverViewController.h
//  Player
//
//  Created by Sina on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewGroupPopOverDelegate
- (void)createGroupWithName:(NSString *)name;
@end


@interface NewGroupPopOverViewController : UIViewController {

    id<NewGroupPopOverDelegate> _delegate;
}

@property (nonatomic, strong) id<NewGroupPopOverDelegate> delegate;

@end


