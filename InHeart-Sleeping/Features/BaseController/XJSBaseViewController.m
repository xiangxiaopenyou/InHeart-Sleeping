//
//  XJSBaseViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseViewController.h"

@interface XJSBaseViewController ()

@end

@implementation XJSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *userItem = [[UIBarButtonItem alloc] initWithCustomView:self.userButton];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
    self.navigationItem.rightBarButtonItems = @[moreItem, userItem];
}
- (void)viewWillAppear:(BOOL)animated {
    NSString *nameString = [[NSUserDefaults standardUserDefaults] stringForKey:USERREALNAME];
    CGSize nameSize = [nameString sizeWithAttributes:@{NSFontAttributeName : XJSSystemFont(16)}];
    [self.userButton setTitle:nameString forState:UIControlStateNormal];
    [self.userButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - nameSize.width * 1.7)];
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
#pragma mark - Getters
- (UIButton *)userButton {
    if (!_userButton) {
        _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userButton.frame = CGRectMake(0, 0, 60, 40);
        [_userButton setImage:[UIImage imageNamed:@"navigation_arrow_down"] forState:UIControlStateNormal];
        [_userButton setTitleColor:XJSHexRGBColorWithAlpha(0x666666, 1) forState:UIControlStateNormal];
        _userButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_userButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - 40, 0, 0)];
    }
    return _userButton;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(0, 0, 40, 40);
        [_moreButton setImage:[UIImage imageNamed:@"navigation_more"] forState:UIControlStateNormal];
    }
    return _moreButton;
}

@end
