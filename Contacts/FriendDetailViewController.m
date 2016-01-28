//
//  FriendDetailViewController.m
//  Contacts
//
//  Created by fly on 16/1/20.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "EditCell.h"
#import "FriendData.h"
#import "ContactAccess.h"

static NSString *cellIdentifier = @"editCell";
static NSString *headerIdentifier = @"sectionHeader";

@interface FriendDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *sectionArray;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.contact) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", self.contact.familyName, self.contact.givenName];
    }
    else {
        self.navigationItem.title = @"New Contact";
    }
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContact)];
    
    if (self.contact) {
        UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteContact)];
        self.navigationItem.rightBarButtonItems = @[deleteItem, saveItem];
    }
    else {
        self.navigationItem.rightBarButtonItem = saveItem;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[EditCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[EditSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    self.dataArray = [NSMutableArray array];
    
    FriendData *friendData = [FriendData new];
    [self.dataArray addObjectsFromArray:[friendData constructDetailArrays:self.contact]];
    
    self.sectionArray = @[@"Names",@"Phone Numbers",@"Email Address"];
    
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *rows = self.dataArray[section];
    return rows.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width, 25);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.frame.size.width, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.sectionArray[indexPath.section];
    EditSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    [header bindTitle:title];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rows = self.dataArray[indexPath.section];
    FriendDetailModel *friend = rows[indexPath.row];
    [((EditCell *)cell) bindModel:friend];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (void)saveContact
{
    typeof(&*self) __weak weakSelf = self;
    [ContactAccess requestForAccess:^(NSString *msg) {
        if (msg == nil) {
            return ;
        }
        
        if (msg.length > 0) {
            NSLog(msg);
            return ;
        }
        //在保存时，禁止再次进行编辑操作，否则会保存最后一次的数据，此处需增加loading状态，暂时不添加了。
        CNMutableContact *tmpContact = [FriendData parseDatasToContact:weakSelf.dataArray];
        CNSaveRequest *request = [CNSaveRequest new];
        if (weakSelf.contact) {
            CNMutableContact *contact = (CNMutableContact *)[weakSelf.contact mutableCopy];
            [FriendData multableContactWithContact:tmpContact realContact:contact];
            [request updateContact:contact];
        }
        else {
            [request addContact:tmpContact toContainerWithIdentifier:nil];
        }
        CNContactStore *store = [CNContactStore new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL result = [store executeSaveRequest:request error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.block) {
                    weakSelf.block(result);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            });
        });
    }];
}

- (void)deleteContact
{
    typeof(&*self) __weak weakSelf = self;
    [ContactAccess requestForAccess:^(NSString *msg) {
        if (msg == nil) {
            return ;
        }
        
        if (msg.length > 0) {
            NSLog(msg);
            return ;
        }
        CNMutableContact *contact = (CNMutableContact *)[self.contact mutableCopy];
        CNSaveRequest *request = [CNSaveRequest new];
        [request deleteContact:contact];
        CNContactStore *store = [CNContactStore new];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL result = [store executeSaveRequest:request error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.block) {
                    weakSelf.block(result);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            });
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
