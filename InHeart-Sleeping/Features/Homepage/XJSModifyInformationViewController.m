//
//  XJSModifyInformationViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSModifyInformationViewController.h"

@interface XJSModifyInformationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField1;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField2;

@end

@implementation XJSModifyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *titleString = nil;
    switch (self.informationType) {
        case XJSUserInformationTypeName: {
            titleString = @"姓名修改";
            self.contentTextField1.hidden = YES;
            self.titleLabel1.text = @"治疗师:";
            self.titleLabel2.text = @"更改为:";
        }
            break;
        case XJSUserInformationTypePassword: {
            titleString = @"密码修改";
            self.contentLabel.hidden = YES;
            self.titleLabel1.text = @"新密码:";
            self.titleLabel2.text = @"请确认:";
            self.contentTextField1.secureTextEntry = YES;
            self.contentTextField2.secureTextEntry = YES;
        }
            break;
        case XJSUserInformationTypePhone: {
            titleString = @"手机号修改";
            self.contentTextField1.hidden = YES;
            self.titleLabel1.text = @"手机号:";
            self.titleLabel2.text = @"更改为:";
            self.contentTextField2.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        default:
            break;
    }
    self.title = titleString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
