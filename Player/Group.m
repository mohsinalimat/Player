//
//  Friend.m
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Group.h"
@implementation Group
- (id)init {
    if (self = [super init]) {
        [self setName:@"Player Name"];
        [self setGroupName:@"Group Name 1"];
    }
    return self;
}

@synthesize groupName = _groupName;

- (NSString *)name {
    return name;
}

- (void)setName:(NSString *)input {
    name = input;
}


-(NSString*)groupName
{
    return _groupName;
}

-(void)setGroupName:(NSString *)groupName
{
    _groupName = groupName;
}

/* This code has been added to support encoding and decoding my objecst */

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"groupName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"groupName"];
    }
    return self;
}

-(void)dealloc {
    
}
@end