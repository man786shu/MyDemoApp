//
//  SMStoryCell.m
//  SMTestRoposo
//
//  Created by Shubham Mandal on 18/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import "SMStoryCell.h"
#import "SMStyle.h"
#import "SMUtility.h"
#import "SMUser.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface SMStoryCell ()
{
    SMStoryCellType _cellType;
}
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIImageView *storyImageView;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *titleAndDescLabel;
@property (nonatomic, strong) SMStory *currentStory;


@end

@implementation SMStoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(SMStoryCellType)cellType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellType = cellType;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = GRAY(0.94);
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_containerView];
    
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    _userImageView.clipsToBounds = YES;
    [_containerView addSubview:_userImageView];
    
    _storyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _storyImageView.contentMode = UIViewContentModeScaleAspectFill;
    _storyImageView.backgroundColor = GRAYA(0.7, 0.7);
    _storyImageView.clipsToBounds = YES;
    [_containerView addSubview:_storyImageView];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectZero];
    _userName.font = MEDIUM(17.0);
    _userName.numberOfLines = 0;
    _userName.textColor = [UIColor blackColor];
    [_containerView addSubview:_userName];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followButton.titleLabel setFont:REGULAR(10.0)];
    _followButton.clipsToBounds = YES;
    [_followButton addTarget:self action:@selector(followPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_followButton];
    
    _likeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _likeLabel.font = REGULAR(15.0);
    _likeLabel.textColor = GRAY(0.5);
    [_containerView addSubview:_likeLabel];
    
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = REGULAR(15.0);
    _commentLabel.textColor = GRAY(0.5);
    [_containerView addSubview:_commentLabel];
    
    _titleAndDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleAndDescLabel.numberOfLines = 0;
    [_containerView addSubview:_titleAndDescLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.contentView.bounds.size;
    self.separatorInset = UIEdgeInsetsMake(0, size.width / 2, 0, size.width / 2);
    
    if (_cellType == SMStoryCellTypeStoryCard)
    {
        _containerView.frame = CGRectMake(0, kTopPadding, size.width, size.height - (2 * kTopPadding));

        float headerHeight = kInterItemSpace + kUserImageHeight + kInterItemSpace;
        
        float x = kSidePadding;
        float y = kInterItemSpace;
        _userImageView.frame = CGRectMake(x, y, kUserImageHeight, kUserImageHeight);
        _userImageView.layer.cornerRadius = kUserImageHeight / 2;
        
        CGSize bSize = _followButton.intrinsicContentSize;
        bSize.width += 20.0;
        y = SMCenteredOrigin(headerHeight, bSize.height);
        x = size.width - kSidePadding - bSize.width;
        _followButton.frame = CGRectMake(x, y, bSize.width, bSize.height);
        _followButton.layer.cornerRadius = bSize.height / 2;
        
        float remainingWidth = size.width - (2 * kSidePadding + kInterItemSpace + bSize.width + kUserImageHeight);
        CGSize tSize = [SMUtility sizeForString:_userName.text font:_userName.font width:remainingWidth];
        x = CGRectGetMaxX(_userImageView.frame) + kInterItemSpace / 2;
        y = SMCenteredOrigin(headerHeight, tSize.height);
        _userName.frame = (CGRect) {x, y, tSize};
        
        CGSize iSize = CGSizeMake(kImageWidth, kImageDummyHeight);
        x = 0;
        y = headerHeight;
        _storyImageView.frame = (CGRect) {x, y, iSize};
        
        x = kSidePadding;
        y = kInterItemSpace + CGRectGetMaxY(_storyImageView.frame);
        tSize = [SMUtility sizeForString:_likeLabel.text font:_likeLabel.font];
        _likeLabel.frame = (CGRect) {x, y, tSize};
        
        x = kSidePadding + tSize.width + kSidePadding;
        y = kInterItemSpace + CGRectGetMaxY(_storyImageView.frame);
        tSize = [SMUtility sizeForString:_commentLabel.text font:_commentLabel.font];
        _commentLabel.frame = (CGRect) {x, y, tSize};
        
        x = kSidePadding;
        y += kInterItemSpace / 2 + tSize.height;
        NSAttributedString *str = [SMStoryCell attributedStringForTitle:_currentStory.title andDescription:_currentStory.storyDescription];
        tSize = [SMUtility sizeForAttributedString:str width:(size.width - 2 * kSidePadding)];
        _titleAndDescLabel.frame = (CGRect) {x, y, tSize.width, tSize.height};
    }
    else
    {
        _containerView.frame = CGRectMake(0, 0, size.width, size.height);

        float x, y;
        CGSize tSize;
        x = kSidePadding;
        y = kInterItemSpace;
        tSize = [SMUtility sizeForString:_likeLabel.text font:_likeLabel.font];
        _likeLabel.frame = (CGRect) {x, y, tSize};
        
        x = kSidePadding + tSize.width + kSidePadding;
        y = kInterItemSpace;
        tSize = [SMUtility sizeForString:_commentLabel.text font:_commentLabel.font];
        _commentLabel.frame = (CGRect) {x, y, tSize};
        
        x = kSidePadding;
        y += kInterItemSpace / 2 + tSize.height;
        NSAttributedString *str = [SMStoryCell attributedStringForTitle:_currentStory.title andDescription:_currentStory.storyDescription];
        tSize = [SMUtility sizeForAttributedString:str width:(size.width - 2 * kSidePadding)];
        _titleAndDescLabel.frame = (CGRect) {x, y, tSize.width, tSize.height};
    }
}

- (void)updateCellWithStory:(SMStory *)story
{
    _currentStory = story;
    _storyImageView.image = nil;
    [_userImageView setImageWithURL:[NSURL URLWithString:story.user.image]];
    _userName.text = story.user.userName;
    
    if (![story.user.isFollowing boolValue]) {
        [_followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
        [_followButton setTitleColor:GRAY(0.1) forState:UIControlStateNormal];
        [_followButton setBackgroundColor:[UIColor whiteColor]];
        _followButton.layer.borderColor = GRAY(0.1).CGColor;
        _followButton.layer.borderWidth = 1.0;
    }
    else {
        [_followButton setTitle:@"FOLLOWING" forState:UIControlStateNormal];
        [_followButton setTitleColor:GRAY(1.0) forState:UIControlStateNormal];
        [_followButton setBackgroundColor:RGB(66.0, 172.0, 169.0)];
        _followButton.layer.borderWidth = 0.0;
    }
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.storyImageView.center;
    [self.containerView addSubview:activityIndicatorView];
    [self.containerView bringSubviewToFront:activityIndicatorView];
    [activityIndicatorView startAnimating];
    __weak typeof(self) weakSelf = self;
    [_storyImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:story.si]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [activityIndicatorView removeFromSuperview];
        weakSelf.storyImageView.image = image;
        weakSelf.storyImageView.layer.borderWidth = kImageBorderWidth;
        weakSelf.storyImageView.layer.borderColor = GRAY(0.94).CGColor;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [activityIndicatorView removeFromSuperview];
    }];
    
    _likeLabel.text = [NSString stringWithFormat:@"%@ Likes", story.likesCount];
    _commentLabel.text = [NSString stringWithFormat:@"%@ Comments", story.commentsCount];
    
    _titleAndDescLabel.attributedText = [SMStoryCell attributedStringForTitle:story.title andDescription:story.storyDescription];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

+ (NSAttributedString *)attributedStringForTitle:(NSString *)title andDescription:(NSString *)description
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //style.lineSpacing = 2.0;
    
    NSDictionary *titleDict = @{NSForegroundColorAttributeName : RGB(128.0, 128.0, 128.0),
                                NSFontAttributeName : LIGHT(15.0),
                                NSParagraphStyleAttributeName : style};
    
//    NSDictionary *blueDict = @{NSForegroundColorAttributeName : [UIColor blueColor],
//                                NSFontAttributeName : LIGHT(15.0),
//                               NSParagraphStyleAttributeName : style};
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    NSAttributedString *str = nil;
    
    str = [[NSAttributedString alloc] initWithString:title attributes:titleDict];
    [string appendAttributedString:str];
    
    if (description.length > 0) {
//        NSArray *components = [[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]componentsSeparatedByString:@" "];
//        for (NSString *innerStr in components) {
//            NSAttributedString *str = nil;
//
//            if ([innerStr rangeOfString:@"#"].location != NSNotFound) {
//                str = [[NSAttributedString alloc] initWithString:innerStr attributes:blueDict];
//            }
//            else {
//                str = [[NSAttributedString alloc] initWithString:innerStr attributes:titleDict];
//            }
//            if ([components indexOfObject:innerStr] == 0) {
//                [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
//            }
//            else {
//                [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:nil]];
//            }
//            [string appendAttributedString:str];
//        }
        str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", description] attributes:titleDict];
        [string appendAttributedString:str];
    }
    return string;
}

+ (CGFloat)getHeightForStory:(SMStory *)story isCard:(BOOL)isCard
{
    if (isCard) {
        float  height = kImageDummyHeight + kInterItemSpace;
        height += kTopPadding + kInterItemSpace + kUserImageHeight + kInterItemSpace + kTopPadding;
        
        CGSize tSize = [SMUtility sizeForString:[NSString stringWithFormat:@"%@ Likes", story.likesCount] font:REGULAR(15.0)];
        height += tSize.height + kInterItemSpace / 2;
        
        NSAttributedString *str = [SMStoryCell attributedStringForTitle:story.title andDescription:story.storyDescription];
        tSize = [SMUtility sizeForAttributedString:str width:[UIScreen mainScreen].bounds.size.width - 2 * kSidePadding];
        
        height += tSize.height+ kInterItemSpace;
        
        return height;
    }
    else
    {
        float height = 0;
        
        CGSize tSize = [SMUtility sizeForString:[NSString stringWithFormat:@"%@ Likes", story.likesCount] font:REGULAR(15.0)];
        height += kInterItemSpace + tSize.height + kInterItemSpace / 2;
        
        NSAttributedString *str = [SMStoryCell attributedStringForTitle:story.title andDescription:story.storyDescription];
        tSize = [SMUtility sizeForAttributedString:str width:[UIScreen mainScreen].bounds.size.width - 2 * kSidePadding];
        
        height += tSize.height+ kInterItemSpace;
        
        return height;
    }
}

- (void)followPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(followButtonPressedForStory:)]) {
        [_delegate followButtonPressedForStory:_currentStory];
    }
}
@end
