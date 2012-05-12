//
//  FriendsManager.h
//  Ghonoot
//
//  Created by Sina on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"
#import "Group.h"

@interface FriendsManager : NSObject
{
    
}

-(void)removeGroup:(int)index;
-(void)createGroupWithName:(NSString*)name;
-(void)addFriend:(Friend*)friend toGroup:(NSString*)group;
-(void)saveObjects:(NSMutableArray*)array forKey:(NSString*)key;
-(NSMutableArray*)getObjectsForKey:(NSString*)key;
-(NSMutableArray*)getFriendsForGroup:(int)group;

+ (id)sharedManager;

@property (nonatomic) int currentGroup;
@property (strong,nonatomic) NSMutableArray *groups;

@end