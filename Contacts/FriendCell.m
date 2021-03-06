//
//  FriendCell.m
//  Contacts
//
//  Created by fly on 16/1/19.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "FriendCell.h"
#import <Contacts/Contacts.h>

static const NSInteger commonSpace = 10;

@implementation FriendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * commonSpace, commonSpace, self.contentView.frame.size.width - 4 * commonSpace, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nameLabel];
    
    self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * commonSpace, CGRectGetMaxY(self.nameLabel.frame), self.contentView.frame.size.width - 4 * commonSpace, 20)];
    self.phoneNumberLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.phoneNumberLabel];
    
    self.emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * commonSpace, CGRectGetMaxY(self.phoneNumberLabel.frame), self.contentView.frame.size.width - 4 * commonSpace, 20)];
    self.emailLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.emailLabel];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(commonSpace, self.contentView.frame.size.height - 1, self.contentView.frame.size.width - 2 * commonSpace, 1)];
    self.lineView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.lineView];
}

- (void)bindModel:(id)model
{
    CNContact *contact = (CNContact *)model;
    
    self.nameLabel.text = [NSString stringWithFormat:@"姓名: %@ %@", contact.familyName, contact.givenName];
    
    NSArray *phones = contact.phoneNumbers;
    if (phones && phones.count > 0) {
        CNLabeledValue *firstPhone = phones[0];
        CNPhoneNumber *number = firstPhone.value;
        self.phoneNumberLabel.text = [NSString stringWithFormat:@"电话: %@",number.stringValue];
    }
    NSArray *emails = contact.emailAddresses;
    if (emails && emails.count > 0) {
        CNLabeledValue *firstEmail = emails[0];
        self.emailLabel.text = [NSString stringWithFormat:@"邮箱: %@",firstEmail.value];
    }
}

@end
