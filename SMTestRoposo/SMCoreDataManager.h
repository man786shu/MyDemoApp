//
//  SMCoreDataManager.h
//  SMTestRoposo
//
//  Created by Shubham Mandal on 18/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMStory, SMUser;

@interface SMCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (SMCoreDataManager *)shareManager;

- (void)getAllStoriesWithCompletionHandler:(void (^) (NSArray * stories))completionBlock;
- (void)getAllUsersWithCompletionHandler:(void (^) (NSArray * users))completionBlock;
- (void)getStoryWithStoryID:(NSString *)storyId withCompletionHandler:(void (^) (SMStory * story))completionBlock;
- (void)getUserWithUserID:(NSString *)userId withCompletionHandler:(void (^) (SMUser * user))completionBlock;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
