//
//  FriendDetailViewController.h
//  Contacts
//
//  Created by fly on 16/1/20.
//  Copyright © 2016年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>

typedef void(^editBlock)(BOOL isFinished);

@interface FriendDetailViewController : UIViewController

@property (nonatomic, copy) editBlock block;
@property (nonatomic, strong) CNContact *contact;

@end
