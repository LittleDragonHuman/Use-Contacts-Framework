//
//  RootViewController.m
//  Contacts
//
//  Created by fly on 16/1/19.
//  Copyright © 2016年 fly. All rights reserved.
//

#import <Contacts/Contacts.h>
#import "RootViewController.h"
#import "FriendDetailViewController.h"
#import "FriendCell.h"

static NSString *cellIdentifier = @"friendCell";

@interface RootViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *allFriends;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"All Friends";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFriend)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[FriendCell class] forCellWithReuseIdentifier:cellIdentifier];

    self.allFriends = [NSMutableArray array];
    
    [self constructFriends];
}

- (void)constructFriends
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fetchAllFriends];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allFriends.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CNContact *friend = self.allFriends[indexPath.row];
    [((FriendCell *)cell) bindModel:friend];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CNContact *friend = self.allFriends[indexPath.row];
    [self showFriendDetailWithFriend:friend];
}

- (void)fetchAllFriends
{
    [self.allFriends removeAllObjects];
    CNContactStore *store = [[CNContactStore alloc] init];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]];
    typeof(&*self) __weak weakSelf = self;
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [weakSelf.allFriends addObject:contact];
    }];
}

- (void)addNewFriend
{
    [self showFriendDetailWithFriend:nil];
}

- (void)showFriendDetailWithFriend:(CNContact *)friend
{
    typeof(&*self) __weak weakSelf = self;
    FriendDetailViewController *detailVC = [[FriendDetailViewController alloc] init];
    detailVC.contact = friend;
    detailVC.block = ^(BOOL isFinished) {
        [weakSelf constructFriends]; //此处应该用弱引用
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
