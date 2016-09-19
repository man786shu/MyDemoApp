//
//  SMCoreDataManager.m
//  SMTestRoposo
//
//  Created by Shubham Mandal on 18/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import "SMCoreDataManager.h"
#import "SMUser.h"
#import "SMStory.h"

#define getFetchRequest(fetchRequestTemplate,variableDictionary) [self.managedObjectContext.persistentStoreCoordinator.managedObjectModel fetchRequestFromTemplateWithName:fetchRequestTemplate substitutionVariables:variableDictionary]

#define getFetchRequestWithName(fetchRequestTemplate)  [self.managedObjectContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:fetchRequestTemplate];

//Fetch Request Template

#define kGetAllStories @"getAllStories"
#define kGetAllStoriesForUserID @"getAllStoriesForUserID"
#define kGetAllUsers @"getAllUsers"
#define kGetStoryWithStoryID @"getStoryWithStoryID"
#define kGetUserWithUserID @"getUserWithUserID"

@interface SMCoreDataManager ()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation SMCoreDataManager

+ (SMCoreDataManager *)shareManager
{
    static SMCoreDataManager * _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[super allocWithZone:nil] init];
        [_sharedManager setup];
    });
    return _sharedManager;
}

- (void)setup
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iOSData" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    for (NSDictionary *dict in jsonDataArray) {
        if ([[dict allKeys] containsObject:@"handle"]) {
            [self getUserWithUserID:dict[@"id"] withCompletionHandler:^(SMUser *user) {
                if (!user) {
                    SMUser *user = (SMUser *)[NSEntityDescription insertNewObjectForEntityForName:@"SMUser" inManagedObjectContext:self.managedObjectContext];
                    
                    user.userID = dict[@"id"];
                    user.about = dict[@"about"];
                    user.userName = dict[@"username"];
                    user.followers = @([dict[@"followers"] integerValue]);
                    user.following = @([dict[@"following"] integerValue]);
                    user.image = dict[@"image"];
                    user.url = dict[@"url"];
                    user.handle = dict[@"handle"];
                    user.isFollowing = @([dict[@"is_following"] boolValue]);
                    long time = [dict[@"createdOn"] integerValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                    user.createdOn = date;
                    [self saveContext];
                }
            }];
        }
    }
    for (NSDictionary *dict in jsonDataArray) {
        if (![[dict allKeys] containsObject:@"handle"]) {
           [self getStoryWithStoryID:dict[@"id"] withCompletionHandler:^(SMStory *story) {
               if (!story) {
                   SMStory *story = (SMStory *)[NSEntityDescription insertNewObjectForEntityForName:@"SMStory" inManagedObjectContext:self.managedObjectContext];
                   story.storyId = dict[@"id"];
                   story.storyDescription = dict[@"description"];
                   story.verb = dict[@"verb"];
                   story.likesCount = @([dict[@"likes_count"] integerValue]);
                   story.commentsCount = @([dict[@"comment_count"] integerValue]);
                   story.si = dict[@"si"];
                   story.url = dict[@"url"];
                   story.db = dict[@"db"];
                   story.type = dict[@"type"];
                   story.title = dict[@"title"];
                   story.likeFlag = @([dict[@"like_flag"] boolValue]);
                   
                   [self getUserWithUserID:story.db withCompletionHandler:^(SMUser *user) {
                       story.user = user;
                       [self saveContext];
                   }];
               }
           }];
        }
    }
}

- (void)getAllStoriesWithCompletionHandler:(void (^)(NSArray *))completionBlock
{
    [self.managedObjectContext performBlock:^{
        NSFetchRequest *fetchRequest = getFetchRequestWithName(kGetAllStories);
        NSError *error = nil;
        NSArray *allStories = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock (allStories);
        });
    }];
}

- (void)getStoryWithStoryID:(NSString *)storyId withCompletionHandler:(void (^)(SMStory *))completionBlock
{
    NSFetchRequest *fetchRequest = getFetchRequest(kGetStoryWithStoryID, @{@"storyId" : storyId});
    NSError *error = nil;
    NSArray *storyArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (storyArr.count > 0) {
        SMStory *story = (SMStory *)(storyArr[0]);
        completionBlock (story);
    }
    else {
        completionBlock (nil);
    }

}

- (void)getAllUsersWithCompletionHandler:(void (^)(NSArray *))completionBlock
{
    [self.managedObjectContext performBlock:^{
        NSFetchRequest *fetchRequest = getFetchRequestWithName(kGetAllUsers);
        NSError *error = nil;
        NSArray *allStories = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock (allStories);
        });
    }];
}

- (void)getUserWithUserID:(NSString *)userId withCompletionHandler:(void (^)(SMUser *))completionBlock
{
    NSFetchRequest *fetchRequest = getFetchRequest(kGetUserWithUserID, @{@"userID" : userId});
    NSError *error = nil;
    NSArray *userArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (userArr.count > 0) {
        SMUser *user = (SMUser *)(userArr[0]);
        completionBlock (user);
    }
    else {
        completionBlock (nil);
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.iappstreet.SMTestRoposo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SMTestRoposo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SMTestRoposo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    [_managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)deleteAllCoreData
{
    NSPersistentStore *store = self.persistentStoreCoordinator.persistentStores[0];
    NSError *error;
    NSURL *storeURL = store.URL;
    NSPersistentStoreCoordinator *storeCoordinator = self.persistentStoreCoordinator;
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
    
    _persistentStoreCoordinator = nil;
}

@end
