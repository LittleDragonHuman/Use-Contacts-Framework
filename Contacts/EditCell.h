//
//  EditCell.h
//  Contacts
//
//  Created by fly on 16/1/20.
//  Copyright © 2016年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendDetailModel;

@interface EditSectionHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;

- (void)bindTitle:(NSString *)title;

@end

@interface EditCell : UICollectionViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UITextField *valueTextField;
@property (nonatomic, strong) FriendDetailModel *data;

- (void)bindModel:(id)model;

@end
