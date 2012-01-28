//
//  FriendUtility.m
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendUtility.h"

@implementation FriendUtility

static int number = 69;

+ (int)getNumber {
    return number;
}

+ (void)setNumber:(int)newNumber {
    number = newNumber;
}

- (int)uniqueID:(int)number
{
    return 500;
}

+ (id)alloc {
    [NSException raise:@"Cannot be instantiated!" format:@"Static class 'ClassName' cannot be instantiated!"];
    return nil;
}

@end