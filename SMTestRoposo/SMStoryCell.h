//
//  SMStoryCell.h
//  SMTestRoposo
//
//  Created by Shubham Mandal on 18/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMStory.h"

typedef enum {
      SMStoryCellTypeStoryCard = 0,
      SMStoryCellTypeStoryDetail = 1
} SMStoryCellType;

@protocol SMStoryCellDelegate <NSObject>
@optional
- (void)followButtonPressedForStory:(SMStory *)story;

@end
@interface SMStoryCell : UITableViewCell

@property (nonatomic, weak) id <SMStoryCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(SMStoryCellType)cellType;
- (void)updateCellWithStory:(SMStory *)story;
+ (CGFloat)getHeightForStory:(SMStory *)story isCard:(BOOL)isCard;

@end
