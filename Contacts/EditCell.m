//
//  EditCell.m
//  Contacts
//
//  Created by fly on 16/1/20.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "EditCell.h"
#import "FriendData.h"

static const NSInteger commonSpace = 10;

@implementation EditSectionHeader

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
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.titleLabel];
}

- (void)bindTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end

@implementation EditCell

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
    self.keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * commonSpace, 0, 40, 20)];
    self.keyLabel.font = [UIFont systemFontOfSize:12];
    self.keyLabel.backgroundColor = [UIColor redColor];
    self.keyLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.keyLabel];
    
    self.valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.keyLabel.frame), 0, self.contentView.frame.size.width - CGRectGetMaxX(self.keyLabel.frame) - commonSpace, 20)];
    self.valueTextField.font = [UIFont systemFontOfSize:12];
    self.valueTextField.layer.borderWidth = 1.0f;
    self.valueTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.valueTextField.delegate = self;
    [self.contentView addSubview:self.valueTextField];
}

- (void)bindModel:(id)model
{
    self.data = (FriendDetailModel *)model;
    self.keyLabel.text = self.data.key;
    self.valueTextField.text = self.data.value;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.data.value = self.valueTextField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.data.value = self.valueTextField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.data.value = [NSString stringWithFormat:@"%@%@",textField.text, string];
    return YES;
}

@end
