//
//  FriendData.h
//  Contacts
//
//  Created by fly on 16/1/19.
//  Copyright © 2016年 fly. All rights reserved.
//

#import <Contacts/Contacts.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FriendDetailInfoType) {
    FriendDetailInfoTypeGivenName, //名
    FriendDetailInfoTypeFamilyName, //姓
    FriendDetailInfoTypeMiddleName, //中间名
    FriendDetailInfoTypeMobile, //mobile
    FriendDetailInfoTypeHomePhone, //家庭电话
    FriendDetailInfoTypeWorkEmail, //工作邮件
    FriendDetailInfoTypeHomeEmail, //家庭邮件
};

@interface FriendDetailModel : NSObject

@property (nonatomic, assign) FriendDetailInfoType infoType;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;

@end

@interface FriendData : NSObject

- (NSArray *)constructDetailArrays:(CNContact *)contact;

+ (CNMutableContact *)parseDatasToContact:(NSArray *)datas;

+ (void)multableContactWithContact:(CNMutableContact *)tmpContact realContact:(CNMutableContact *)realContact;

@end
