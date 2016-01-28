//
//  ContactAccess.h
//  Contacts
//
//  Created by 冯莉娅 on 16/1/28.
//  Copyright © 2016年 fly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ContactAccess : NSObject

+ (AppDelegate *)getAppDelegate;
+ (void)requestForAccess:(void(^)(NSString *msg))block;

@end
