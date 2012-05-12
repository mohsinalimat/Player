//
//  Friend.m
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Group.h"
#import "Friend.h"

@implementation Group
- (id)init {
    if (self = [super init]) {
        [self setName:@"Player Name"];
        [self setIdNum:@"idNum"];
        [self setFriends:[NSMutableArray array]];
    }
    return self;
}

@synthesize name = _name;
@synthesize idNum = _idNum;
@synthesize friends = _friends;

- (NSString *)name {
    return _name;
}

- (NSString *)idNum {
    return _idNum ;
}

- (NSMutableArray *)friends {
    if(!_friends)
    {
        Friend *friend = [[Friend alloc] init];
        friend.name = @"Sample";
        _friends = [NSMutableArray array];
        [_friends addObject:friend];
    }
    
    return _friends ;
}

- (void)setName:(NSString *)input {
    _name = input;
}

- (void)setIdNum:(NSString *)input {
    _idNum = input;
}

- (void)setFriends:(NSMutableArray *)input{
    _friends = input;
}

/* This code has been added to support encoding and decoding my objects */

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.idNum forKey:@"idNum"];
    [encoder encodeObject:self.friends forKey:@"friends"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.idNum = [decoder decodeObjectForKey:@"idNum"];
        self.friends = [decoder decodeObjectForKey:@"friends"];
    }
    return self;
}

-(void)dealloc {
    
}
@end