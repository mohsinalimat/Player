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
-(void)rearrangeGroupsFrom:(int)startIndex to:(int)endIndex;
-(void)rearrangeFriendsFrom:(int)startIndex to:(int)endIndex;
-(void)updateGroup:(int)group toName:(NSString*)newName;
-(void)updateFriend:(Friend*)friend;
-(void)removeFriend:(Friend*)friend;
-(void)removeFriendAtRow:(int)row inSection:(int)section;
-(void)moveFriendFrom:(NSIndexPath*)path to:(NSIndexPath*)newPath;

+ (id)sharedManager;

@property (nonatomic) int currentGroup;
@property (strong,nonatomic) NSString* currentGroupName;

@property (nonatomic) int currentFriend;
@property (nonatomic) Friend* currentFriendObject;

@property (strong,nonatomic) NSMutableArray *groups;

@end