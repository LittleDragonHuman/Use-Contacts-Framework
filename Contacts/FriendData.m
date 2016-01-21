//
//  FriendData.m
//  Contacts
//
//  Created by fly on 16/1/19.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "FriendData.h"

@implementation FriendDetailModel

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end

@implementation FriendData

- (NSArray *)constructDetailArrays:(CNContact *)contact
{
    NSMutableArray *detailArrays = [NSMutableArray array];

    [detailArrays addObject:[self constructNamesArray:contact]];
    
    [detailArrays addObject:[self constructNumbersArray:contact]];
    
    [detailArrays addObject:[self constructEmailsArray:contact]];
    
    return [NSArray arrayWithArray:detailArrays];
}

- (NSArray *)constructNamesArray:(CNContact *)contact
{
    NSMutableArray *names = [NSMutableArray array];
    
    NSString *familyName = @"";
    if (contact && contact.familyName) {
        familyName = contact.familyName;
    }
    FriendDetailModel *familyNameModel = [[FriendDetailModel alloc] initWithKey:@"姓：" value:familyName];
    familyNameModel.infoType = FriendDetailInfoTypeFamilyName;
    [names addObject:familyNameModel];
    
    NSString *givenName = @"";
    if (contact && contact.givenName) {
        givenName = contact.givenName;
    }
    FriendDetailModel *givenNameModel = [[FriendDetailModel alloc] initWithKey:@"名：" value:givenName];
    givenNameModel.infoType = FriendDetailInfoTypeGivenName;
    [names addObject:givenNameModel];
    
    return [NSArray arrayWithArray:names];
}

- (NSArray *)constructNumbersArray:(CNContact *)contact
{
    NSMutableArray *numbers = [NSMutableArray array];
    
    __block NSString *mobile = @"";
    __block NSString *home = @"";
        
    if (contact && contact.phoneNumbers && contact.phoneNumbers.count > 0) {
        [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.label == CNLabelPhoneNumberMobile) {
                mobile = obj.value.stringValue;
            }
            if (obj.label == CNLabelPhoneNumberHomeFax) {
                home = obj.value.stringValue;
            }
        }];
    }
    FriendDetailModel *mobileModel = [[FriendDetailModel alloc] initWithKey:@"电话：" value:mobile];
    mobileModel.infoType = FriendDetailInfoTypeMobile;
    [numbers addObject:mobileModel];

    FriendDetailModel *homeModel = [[FriendDetailModel alloc] initWithKey:@"家庭：" value:home];
    homeModel.infoType = FriendDetailInfoTypeHomePhone;
    [numbers addObject:homeModel];
    
    return [NSArray arrayWithArray:numbers];
}

- (NSArray *)constructEmailsArray:(CNContact *)contact
{
    NSMutableArray *emails = [NSMutableArray array];
    
    __block NSString *home = @"";
    __block NSString *work = @"";
    
    if (contact && contact.emailAddresses && contact.emailAddresses.count > 0) {
        [contact.emailAddresses enumerateObjectsUsingBlock:^(CNLabeledValue<NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.label == CNLabelHome) {
                home = obj.value;
            }
            if (obj.label == CNLabelWork) {
                work = obj.value;
            }
        }];
    }
    FriendDetailModel *workModel = [[FriendDetailModel alloc] initWithKey:@"工作：" value:work];
    workModel.infoType = FriendDetailInfoTypeWorkEmail;
    [emails addObject:workModel];
    
    FriendDetailModel *homeModel = [[FriendDetailModel alloc] initWithKey:@"家庭：" value:home];
    homeModel.infoType = FriendDetailInfoTypeHomeEmail;
    [emails addObject:homeModel];
    
    return [NSArray arrayWithArray:emails];
}

+ (CNMutableContact *)parseDatasToContact:(NSArray *)datas
{
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [datas enumerateObjectsUsingBlock:^(NSArray *section, NSUInteger idx, BOOL * _Nonnull stop) {
        [section enumerateObjectsUsingBlock:^(FriendDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            dic[@(model.infoType)] = model.value ? model.value : @"";
        }];
    }];
    
    __block CNMutableContact *contact = [CNMutableContact new];
    contact.givenName = dic[@(FriendDetailInfoTypeGivenName)];
    contact.familyName = dic[@(FriendDetailInfoTypeFamilyName)];
    
    CNPhoneNumber *mobileValue = [CNPhoneNumber phoneNumberWithStringValue:dic[@(FriendDetailInfoTypeMobile)]];
    CNLabeledValue *mobile = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile
                                                             value:mobileValue];
    CNPhoneNumber *homePhoneValue = [CNPhoneNumber phoneNumberWithStringValue:dic[@(FriendDetailInfoTypeHomePhone)]];
    CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberHomeFax
                                                                value:homePhoneValue];
    contact.phoneNumbers = @[mobile, homePhone];
    
    CNLabeledValue *workEmail = [CNLabeledValue labeledValueWithLabel:CNLabelWork
                                                                value:dic[@(FriendDetailInfoTypeWorkEmail)]];
    CNLabeledValue *homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome
                                                                value:dic[@(FriendDetailInfoTypeHomeEmail)]];
    contact.emailAddresses = @[workEmail, homeEmail];

    return contact;
}

+ (void)multableContactWithContact:(CNMutableContact *)tmpContact realContact:(CNMutableContact *)realContact
{
    realContact.givenName = tmpContact.givenName;
    realContact.familyName = tmpContact.familyName;
    realContact.phoneNumbers = tmpContact.phoneNumbers;
    realContact.emailAddresses = tmpContact.emailAddresses;
}
@end
