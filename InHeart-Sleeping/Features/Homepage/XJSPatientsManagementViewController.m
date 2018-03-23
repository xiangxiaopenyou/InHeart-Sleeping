//
//  XJSPatientsManagementViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSPatientsManagementViewController.h"
#import "XJSAddPatientViewController.h"
#import "XJSModifyInformationViewController.h"

#import "XJSPatientInfomationCollectionViewCell.h"

#import "ZWPullMenuView.h"

#define kXJSPatientInfoCellWidth (XJSScreenWidth - 80.f) / 5.f
#define kXJSPatientInfoCellHeight kXJSPatientInfoCellWidth * 23.f / 20.f

@interface XJSPatientsManagementViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation XJSPatientsManagementViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)createNavigationItems {
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:self.addButton];
    self.navigationItem.leftBarButtonItems = @[searchItem, addItem];
    UIBarButtonItem *userItem = [[UIBarButtonItem alloc] initWithCustomView:self.userButton];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
    self.navigationItem.rightBarButtonItems = @[moreItem, userItem];
}

#pragma mark - Action
- (void)moreAction {
    NSArray *titlesArray = @[@"注销", @"清理缓存", @"关于系统"];
    NSArray *imagesArray = @[@"system_logout", @"system_clean", @"system_about"];
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:self.moreButton titleArray:titlesArray imageArray:imagesArray];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        
    };
}
- (void)addAction {
    XJSAddPatientViewController *addController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSAddPatient"];
    [self.navigationController pushViewController:addController animated:YES];
}
- (void)userAction {
    NSArray *titlesArray = @[@"姓名修改", @"密码修改", @"手机号修改"];
    NSArray *imagesArray = @[@"setting_name", @"setting_password", @"setting_phone"];
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:self.userButton titleArray:titlesArray imageArray:imagesArray];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        XJSModifyInformationViewController *modifyInformationController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSModifyInformation"];
        modifyInformationController.informationType = menuRow;
        [self.navigationController pushViewController:modifyInformationController animated:YES];
    };
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientInfomationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJSPatientInfomationCollectionCell" forIndexPath:indexPath];
    return cell;
}
#pragma mark - Collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){kXJSPatientInfoCellWidth, kXJSPatientInfoCellHeight};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //return (UIEdgeInsets){18, 18, 18, 18};
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 18.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
#pragma mark - Collection view delegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Getters
- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(0, 0, 40, 40);
        [_searchButton setImage:[UIImage imageNamed:@"navigation_search"] forState:UIControlStateNormal];
    }
    return _searchButton;
}
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(0, 0, 40, 40);
        [_addButton setImage:[UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (UIButton *)userButton {
    if (!_userButton) {
        _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userButton.frame = CGRectMake(0, 0, 60, 40);
        [_userButton setImage:[UIImage imageNamed:@"navigation_arrow_down"] forState:UIControlStateNormal];
        [_userButton setTitle:@"项平" forState:UIControlStateNormal];
        [_userButton setTitleColor:XJSHexRGBColorWithAlpha(0x666666, 1) forState:UIControlStateNormal];
        _userButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_userButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 85)];
        [_userButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - 40, 0, 0)];
        [_userButton addTarget:self action:@selector(userAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userButton;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(0, 0, 40, 40);
        [_moreButton setImage:[UIImage imageNamed:@"navigation_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
