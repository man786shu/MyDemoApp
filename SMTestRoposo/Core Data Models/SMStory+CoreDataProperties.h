//
//  SMStory+CoreDataProperties.h
//  
//
//  Created by Shubham Mandal on 18/09/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SMStory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMStory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *commentsCount;
@property (nullable, nonatomic, retain) NSString *db;
@property (nullable, nonatomic, retain) NSNumber *likeFlag;
@property (nullable, nonatomic, retain) NSNumber *likesCount;
@property (nullable, nonatomic, retain) NSString *si;
@property (nullable, nonatomic, retain) NSString *storyDescription;
@property (nullable, nonatomic, retain) NSString *storyId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *verb;
@property (nullable, nonatomic, retain) SMUser *user;

@end

NS_ASSUME_NONNULL_END
