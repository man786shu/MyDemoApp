//
//  ViewController.m
//  SMTestRoposo
//
//  Created by Shubham Mandal on 18/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import "SMHomeViewController.h"
#import "SMCoreDataManager.h"
#import "SMStory.h"
#import "SMUser.h"
#import "SMStoryCell.h"
#import "SMStyle.h"
#import "SMStoryDetailController.h"

@interface SMHomeViewController ()<UITableViewDelegate, UITableViewDataSource, SMStoryCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *storyArray;

@end

@implementation SMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"STORIES";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = GRAY(0.94);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = GRAY(0.94);
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self getStories];
}

- (void)handleDataModelChange:(NSNotification *)note
{
    [self getStories];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)getStories
{
    __weak typeof(self) weakSelf = self;
    [[SMCoreDataManager shareManager] getAllStoriesWithCompletionHandler:^(NSArray *stories) {
        _storyArray = stories;
        [weakSelf.tableView reloadData];
    }];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _storyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SMStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SMStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier cellType:SMStoryCellTypeStoryCard];
    }
    cell.delegate = self;
    [cell updateCellWithStory:_storyArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SMStoryCell getHeightForStory:_storyArray[indexPath.row] isCard:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMStory *story = (SMStory *)(_storyArray[indexPath.row]);
    SMStoryDetailController *detailController = [[SMStoryDetailController alloc] init];
    detailController.story = story;
    [self.navigationController pushViewController:detailController animated:NO];
    
}

#pragma mark - SMStoryCellDelegate

- (void)followButtonPressedForStory:(SMStory *)story
{
    if ([story.user.isFollowing boolValue]) {
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to unfollow %@ ?", story.user.userName];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Unfollow" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:YES completion:^{
    
            }];
            SMUser *user = (SMUser *)[[[SMCoreDataManager shareManager] managedObjectContext] objectWithID:story.user.objectID];
            user.isFollowing = [NSNumber numberWithBool:NO];
            [[SMCoreDataManager shareManager] saveContext];
        }]];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else {
        SMUser *user = (SMUser *)[[[SMCoreDataManager shareManager] managedObjectContext] objectWithID:story.user.objectID];
        user.isFollowing = [NSNumber numberWithBool:YES];
        [[SMCoreDataManager shareManager] saveContext];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
