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
@synthesize groups = _groups;

-(NSMutableArray*)groups{
    if(_groups)
        _groups = [self loadCustomObjectWithKey:MY_GROUPS];
    
    return _groups;
}

-(int)currentGroup
{
    return _currentGroup;
}

-(void)setCurrentGroup:(int)currentGroup
{
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

-(NSMutableArray*)getFriendsForGroup:(int)index
{
    NSMutableArray *allGroups = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *group = [allGroups objectAtIndex:index];
    NSLog(@"Group:%@", group.name);
    NSLog(@"Friends: %i", [group.friends count]);
    
    NSMutableArray *selectedFriends = [NSMutableArray array];
    /*NSMutableArray *allFriends = [self loadCustomObjectWithKey:MY_FRIENDS];
    for (int i=0; i < [allFriends count]; i++) {
        Friend *friend = [allFriends objectAtIndex:i];
        if([friend.group isEqualToString:group.name])
        {
            [selectedFriends addObject:friend];
        }
    }
     */
    
    return selectedFriends;
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
    NSMutableArray *objects = [self loadCustomObjectWithKey:MY_GROUPS];
    Group *theGroup = (Group*)[objects objectAtIndex:self.currentGroup];
    theGroup.name = @"Name Changed!";
    [theGroup.friends insertObject:friend atIndex:0];
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
