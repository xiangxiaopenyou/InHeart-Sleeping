//
//  XJSPatientCommonInfomationCell.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSPatientCommonInfomationCell.h"

@implementation XJSPatientCommonInfomationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewOfInput.layer.masksToBounds = YES;
    self.viewOfInput.layer.cornerRadius = 10.f;
    self.viewOfInput.layer.borderWidth = 0.5;
    self.viewOfInput.layer.borderColor = XJSHexRGBColorWithAlpha(0xb7b7b7, 1).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupContentView:(NSInteger)tableViewType index:(NSInteger)cellIndex {
    NSArray *leftItemArray = @[@"病案号", @"姓名", @"性别", @"年龄", @"医保卡", @"身份证"];
    NSArray *leftPlaceholderArray = @[@"病案号", @"姓名", @"选择性别", @"年龄", @"卡号", @"号码"];
    NSArray *rightItemArray = @[@"症状", @"婚姻状态", @"文化程度", @"手机号", @"入院日期", @"家庭住址"];
    NSArray *rightPlaceholderArray = @[@"症状", @"选择婚姻状况", @"选择文化程度", @"号码", @"选择日期", @"住址"];
    if (tableViewType == 1) {
        self.itemNameLabel.text = leftItemArray[cellIndex];
        self.textField.placeholder = leftPlaceholderArray[cellIndex];
        self.textField.enabled = cellIndex == 2 ? NO : YES;
        self.textField.keyboardType = cellIndex == 1 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
        self.asteriskImageView.hidden = cellIndex >= 0 && cellIndex <= 3 ? NO : YES;
        if (cellIndex == 2) {
            self.tipImageView.hidden = NO;
            self.tipImageView.image = [UIImage imageNamed:@"information_pulldown"];
        } else {
            self.tipImageView.hidden = YES;
        }
    } else {
        self.itemNameLabel.text = rightItemArray[cellIndex];
        self.textField.placeholder = rightPlaceholderArray[cellIndex];
        self.textField.enabled = cellIndex == 1 || cellIndex == 2 ? NO : YES;
        self.textField.keyboardType = cellIndex == 3 ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
        self.asteriskImageView.hidden = cellIndex == 0 ? NO : YES;
        if (cellIndex == 1 || cellIndex == 2) {
            self.tipImageView.hidden = NO;
            self.tipImageView.image = [UIImage imageNamed:@"information_pulldown"];
        } else if (cellIndex == 4) {
            self.tipImageView.hidden = NO;
            self.tipImageView.image = [UIImage imageNamed:@"information_date"];
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            
            //设置地区: zh-中国
            datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
            //设置日期模式
            datePicker.datePickerMode = UIDatePickerModeDate;
            // 设置当前显示时间
            [datePicker setDate:[NSDate date] animated:YES];
            // 设置显示最大时间（此处为当前时间）
            [datePicker setMaximumDate:[NSDate date]];
            //监听DataPicker的滚动
            [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
            //设置时间输入框的键盘框样式为时间选择器
            self.textField.inputView = datePicker;
            
        } else {
            self.tipImageView.hidden = YES;
        }
    }
}
- (void)dateChange:(UIDatePicker *)datePicker {
    
}

@end
