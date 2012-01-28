//
//  FriendUtility.h
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendUtility : NSObject

+ (int)getNumber;
+ (void)setNumber:(int)number;
- (int)uniqueID:(int)number;

@end