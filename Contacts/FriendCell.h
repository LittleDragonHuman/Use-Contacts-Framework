//
//  FriendCell.h
//  Contacts
//
//  Created by 冯莉娅 on 16/1/19.
//  Copyright © 2016年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UILabel *emailLabel;

- (void)bindModel:(id)model;

@end
