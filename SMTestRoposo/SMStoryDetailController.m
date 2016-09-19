//
//  SMStoryDetailController.m
//  SMTestRoposo
//
//  Created by Shubham Mandal on 19/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import "SMStoryDetailController.h"
#import "SMStyle.h"
#import "SMUtility.h"
#import "SMUser.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SMGradientView.h"
#import "SMStoryCell.h"
#import "SMCoreDataManager.h"

@interface SMStoryDetailController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) SMGradientView *navGradientView;
@property (nonatomic, strong) SMGradientView *userGradientView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIButton *followButton;


@end

@implementation SMStoryDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = GRAY(0.94);

    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_backButton setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
    [_backButton setTintColor:[UIColor whiteColor]];
    [_backButton addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = GRAY(0.94);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    
    _navGradientView = [[SMGradientView alloc] initWithFrame:CGRectZero];
    [_navGradientView updateDisplay];
    [_navGradientView addSubview:_backButton];
    [self.view addSubview:_navGradientView];

    _userGradientView = [[SMGradientView alloc] initWithFrame:CGRectZero];
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    _userImageView.clipsToBounds = YES;
    [_userImageView setImageWithURL:[NSURL URLWithString:_story.user.image]];
    [_userGradientView addSubview:_userImageView];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectZero];
    _userName.font = MEDIUM(17.0);
    _userName.numberOfLines = 0;
    _userName.textColor = [UIColor whiteColor];
    _userName.text = _story.user.userName;
    [_userGradientView addSubview:_userName];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followButton.titleLabel setFont:REGULAR(10.0)];
    [_followButton addTarget:self action:@selector(followPressed:) forControlEvents:UIControlEventTouchUpInside];

    _followButton.clipsToBounds = YES;
    if (![_story.user.isFollowing boolValue]) {
        [_followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
        [_followButton setTitleColor:GRAY(0.15) forState:UIControlStateNormal];
        [_followButton setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [_followButton setTitle:@"FOLLOWING" forState:UIControlStateNormal];
        [_followButton setTitleColor:GRAY(1.0) forState:UIControlStateNormal];
        [_followButton setBackgroundColor:RGB(66.0, 172.0, 169.0)];
        _followButton.layer.borderWidth = 0.0;
    }

    [_userGradientView addSubview:_followButton];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = GRAYA(0.7, 0.7);
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kImageWidth, kImageDummyHeight)];
    self.tableView.tableHeaderView = _tableHeaderView;

    [_tableHeaderView addSubview:self.imageView];
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.hidesWhenStopped = YES;
    [self.tableHeaderView addSubview:_activity];
    
    [_tableHeaderView addSubview:_userGradientView];
    [self.tableHeaderView bringSubviewToFront:_activity];
    

    _activity.center = _tableHeaderView.center;
    [_activity startAnimating];
    __weak typeof(self) weakSelf = self;
    [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.story.si]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        weakSelf.imageView.image = image;
        [weakSelf.activity stopAnimating];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [weakSelf.activity stopAnimating];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;//
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    CGSize size = rect.size;
    _navGradientView.frame = CGRectMake(0, 0, rect.size.width, 64);
    _backButton.frame = (CGRect) {kSidePadding, 20.0, _backButton.intrinsicContentSize};
    _tableView.frame = rect;
    _imageView.frame = _tableHeaderView.frame;
    
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
    
    y = CGRectGetMaxY(_tableHeaderView.frame) - headerHeight;
    x = 0;
    _userGradientView.frame = CGRectMake(x, y, size.width, headerHeight);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SMStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SMStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier cellType:SMStoryCellTypeStoryDetail];
    }
    [cell updateCellWithStory:_story];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SMStoryCell getHeightForStory:_story isCard:NO];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yPos = -scrollView.contentOffset.y;
    if (yPos > 0) {
        CGRect imgRect = self.imageView.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height = kImageDummyHeight + yPos;
        self.imageView.frame = imgRect;
    }
}

- (void)followPressed:(id)sender
{
    if ([_story.user.isFollowing boolValue]) {
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to unfollow %@ ?", _story.user.userName];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Unfollow" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            SMUser *user = (SMUser *)[[[SMCoreDataManager shareManager] managedObjectContext] objectWithID:_story.user.objectID];
            user.isFollowing = [NSNumber numberWithBool:NO];
            [[SMCoreDataManager shareManager] saveContext];
            [_followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
            [_followButton setTitleColor:GRAY(0.2) forState:UIControlStateNormal];
            [_followButton setBackgroundColor:[UIColor whiteColor]];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }]];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else {
        SMUser *user = (SMUser *)[[[SMCoreDataManager shareManager] managedObjectContext] objectWithID:_story.user.objectID];
        user.isFollowing = [NSNumber numberWithBool:YES];
        [[SMCoreDataManager shareManager] saveContext];
        _story.user.isFollowing = user.isFollowing;
        [_followButton setTitle:@"FOLLOWING" forState:UIControlStateNormal];
        [_followButton setTitleColor:GRAY(1.0) forState:UIControlStateNormal];
        [_followButton setBackgroundColor:RGB(66.0, 172.0, 169.0)];
        _followButton.layer.borderWidth = 0.0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

    }
}


@end
