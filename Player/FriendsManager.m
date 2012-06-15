//
//  LocalNotificationsManager.m
//  Ghonoot
//
//  Created by Sina on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsManager.h"

#define MY_FRIENDS @"FriendsViewController.MyFriends"
#define MY_GROUPS @"FriendsViewController.MyGroups"

static FriendsManager *sharedMyManager = nil;

@implementation FriendsManager

@synthesize currentGroup = _currentGroup;
@synthesize currentGroupName = _currentGroupName;
@synthesize groups = _groups;

-(NSMutableArray*)groups{
    if(_groups)
        _groups = [self loadCustomObjectWithKey:MY_GROUPS];
    
    return _groups;
}

-(NSString*)currentGroupName
{
    NSMutableArray *allObjects = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *theGroup = (Group*)[allObjects objectAtIndex:self.currentGroup];
    return theGroup.name;
}

-(int)currentGroup
{
    return _currentGroup;
}

-(void)setCurrentGroup:(int)currentGroup
{
    NSLog(@"ST CUR G");
    NSLog(@"%i", currentGroup);
    _currentGroup = currentGroup;
}

-(void)setGroups:(NSMutableArray *)input{
    _groups = input;
}

#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}
- (id)init {
    if (self = [super init]) {
        //sound = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

-(void)removeGroup:(int)index
{
    NSMutableArray *allObjects = [self loadCustomObjectWithKey:MY_GROUPS];
    [allObjects removeObjectAtIndex:index];
    [self saveObjects:allObjects forKey:MY_GROUPS];
}

-(void)createGroupWithName:(NSString*)name
{
    NSLog(@"Create group: %@", name);
    NSMutableArray *allGroups = [self loadCustomObjectWithKey:MY_GROUPS];
    
    Group *group = [[Group alloc] init];
    group.name = name;
    group.idNum = [NSString stringWithFormat:@"%i", [allGroups count]];
    [allGroups addObject:group];
    
    [self saveObjects:allGroups forKey:MY_GROUPS];
    
    _groups = [self loadCustomObjectWithKey:MY_GROUPS];
}

-(void)saveObjects:(NSMutableArray*)array forKey:(NSString*)key
{
    [self saveCustomObject:array forKey:key];
}

-(void)rearrangeGroupsFrom:(int)startIndex to:(int)endIndex
{
    NSMutableArray *allGroups = [self loadCustomObjectWithKey:MY_GROUPS];
    
    NSObject *object = [allGroups objectAtIndex:startIndex];
    [allGroups removeObject:object];
    [allGroups insertObject:object atIndex:endIndex];
    
    [self saveObjects:allGroups forKey:MY_GROUPS];
}

-(void)rearrangeFriendsFrom:(int)startIndex to:(int)endIndex
{
    NSMutableArray *allGroups = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *theGroup = (Group*)[allGroups objectAtIndex:self.currentGroup];
    
    NSObject *friend = [theGroup.friends objectAtIndex:startIndex];
    [theGroup.friends removeObject:friend];
    [theGroup.friends insertObject:friend atIndex:endIndex];
    
    [self saveCustomObject:allGroups forKey:MY_GROUPS];
}

-(NSMutableArray*)getFriendsForGroup:(int)index
{
    NSMutableArray *allGroups = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *group = [allGroups objectAtIndex:index];    
    return group.friends;
}

-(NSMutableArray*)getObjectsForKey:(NSString*)key
{
    NSMutableArray *objects = [self loadCustomObjectWithKey:key];
    
    if(!objects)
    {
        NSLog(@"No objects found!");
        objects = [NSMutableArray array];
        
        if(key == MY_GROUPS){
            Group *group = [[Group alloc] init];
            group.name = @"Tonight";
            [objects addObject:group];
        }
        
        [self saveObjects:objects forKey:MY_GROUPS];
    }
    
    //objects = [NSMutableArray array];
    
    return objects;
}

-(void)addFriend:(Friend*)friend toGroup:(NSString*)group
{
    NSLog(@"Add");
    NSMutableArray *objects = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *theGroup = (Group*)[objects objectAtIndex:self.currentGroup];
    [theGroup.friends insertObject:friend atIndex:0];
    [self saveCustomObject:objects forKey:MY_GROUPS];
}

-(void)updateFriend:(Friend*)newFriend
{
    NSMutableArray *objects = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *theGroup = (Group*)[objects objectAtIndex:self.currentGroup];
    for(int i=0; i < [theGroup.friends count];i++)
    {
        Friend *friend = [theGroup.friends objectAtIndex:i];
        if([newFriend.idNum isEqualToString:friend.idNum])
        {
            [theGroup.friends insertObject:newFriend atIndex:i];
            [theGroup.friends removeObject:friend];
            break;
        }
    }
    [self saveCustomObject:objects forKey:MY_GROUPS];
}

-(void)removeFriend:(Friend*)newFriend
{
    NSMutableArray *objects = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *theGroup = (Group*)[objects objectAtIndex:self.currentGroup];
    for(int i=0; i < [theGroup.friends count];i++)
    {
        Friend *friend = [theGroup.friends objectAtIndex:i];
        NSLog(@"---------------------");
        NSLog(@"old: %@", friend.idNum);
        NSLog(@"new: %@", newFriend.idNum);
        NSLog(@"new: %@", newFriend.name);
        if([newFriend.idNum isEqualToString:friend.idNum])
        {
            [theGroup.friends removeObject:friend];
            break;
        }
    }
    [self saveCustomObject:objects forKey:MY_GROUPS];
}

-(void)removeFriendAtRow:(int)row inSection:(int)section
{
    NSMutableArray *objects = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *theGroup = (Group*)[objects objectAtIndex:section];
    
    Friend *friend = [theGroup.friends objectAtIndex:row];
    [theGroup.friends removeObject:friend];

    [self saveCustomObject:objects forKey:MY_GROUPS];
}

-(void)moveFriendFrom:(NSIndexPath*)path to:(NSIndexPath*)newPath
{
    NSMutableArray *objects = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *oldGroup = (Group*)[objects objectAtIndex:path.section];
    
    Friend *friend = [oldGroup.friends objectAtIndex:path.row];
    [oldGroup.friends removeObject:friend];
    
    Group *newGroup = (Group*)[objects objectAtIndex:newPath.section];
    [newGroup.friends insertObject:friend atIndex:newPath.row];
    
    [self saveCustomObject:objects forKey:MY_GROUPS];
}

- (void)saveCustomObject:(NSMutableArray *)obj forKey:(NSString*)key {
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:key];
    [defaults synchronize];
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:key];
    NSMutableArray *objs = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return objs;
}

@end
