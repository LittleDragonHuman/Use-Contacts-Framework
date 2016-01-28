//
//  ContactAccess.m
//  Contacts
//
//  Created by 冯莉娅 on 16/1/28.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "ContactAccess.h"
#import <Contacts/Contacts.h>

@implementation ContactAccess

+ (AppDelegate *)getAppDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (void)requestForAccess:(void(^)(NSString *msg))block
{
    CNContactStore *store = [[CNContactStore alloc] init];
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized:
        {
            block(@"");
        }
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusNotDetermined:
        {
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!granted && status == CNAuthorizationStatusDenied) {
                    block(@"You can set authorization by setting.");
                }
            }];
        }
            break;
        default:
        {
            block(nil);
        }
            break;
    }
}

@end
