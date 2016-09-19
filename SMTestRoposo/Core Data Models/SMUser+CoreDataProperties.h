//
//  SMUser+CoreDataProperties.h
//  
//
//  Created by Shubham Mandal on 18/09/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SMUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *about;
@property (nullable, nonatomic, retain) NSDate *createdOn;
@property (nullable, nonatomic, retain) NSNumber *followers;
@property (nullable, nonatomic, retain) NSNumber *following;
@property (nullable, nonatomic, retain) NSString *handle;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSNumber *isFollowing;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSSet<SMStory *> *stories;

@end

@interface SMUser (CoreDataGeneratedAccessors)

- (void)addStoriesObject:(SMStory *)value;
- (void)removeStoriesObject:(SMStory *)value;
- (void)addStories:(NSSet<SMStory *> *)values;
- (void)removeStories:(NSSet<SMStory *> *)values;

@end

NS_ASSUME_NONNULL_END
