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
#import "XJSTrainingCenterViewController.h"
#import "XJSSearchPatientsViewController.h"
#import "XJSPatientDetailViewController.h"

#import "XJSPatientInfomationCollectionViewCell.h"

#import "ZWPullMenuView.h"

#import "XJSPatientModel.h"

#import <MJRefresh.h>

#define kXJSPatientInfoCellWidth (XJSScreenWidth - 80.f) / 5.f
#define kXJSPatientInfoCellHeight kXJSPatientInfoCellWidth * 23.f / 20.f

@interface XJSPatientsManagementViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XJSPatientInfomationCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *patientsArray;
@end

@implementation XJSPatientsManagementViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:self.addButton];
    self.navigationItem.leftBarButtonItems = @[searchItem, addItem];
    [self.userButton addTarget:self action:@selector(userAction) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    _paging = 1;
    [self fetchPatientsList];
    
    [self addRefreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)addRefreshView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self fetchPatientsList];
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchPatientsList];
    }];
    footer.stateLabel.hidden = YES;
    self.collectionView.mj_footer = footer;
}

#pragma mark - Requests
- (void)fetchPatientsList {
    [XJSPatientModel patientsList:nil page:@(_paging) handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (object) {
            NSArray *resultArray = [(NSArray *)object copy];
            if (_paging == 1) {
                self.patientsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.patientsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.patientsArray = [tempArray mutableCopy];
            }
            if (resultArray.count < 10) {
                self.collectionView.mj_footer.hidden = YES;
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.collectionView.mj_footer.hidden = NO;
                _paging += 1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}


#pragma mark - Action
- (void)searchAction {
    XJSSearchPatientsViewController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSSearchPatients"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self presentViewController:navigationController animated:NO completion:nil];
}
- (void)addAction {
    XJSAddPatientViewController *addController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSAddPatient"];
    [self.navigationController pushViewController:addController animated:YES];
}
- (void)userAction {
    NSArray *titlesArray = @[@"姓名修改", @"密码修改"/*, @"手机号修改"*/];
    NSArray *imagesArray = @[@"setting_name", @"setting_password"/*, @"setting_phone"*/];
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:self.userButton titleArray:titlesArray imageArray:imagesArray];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        XJSModifyInformationViewController *modifyInformationController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSModifyInformation"];
        modifyInformationController.informationType = menuRow;
        [self.navigationController pushViewController:modifyInformationController animated:YES];
    };
}
- (void)moreAction {
    NSArray *titlesArray = @[@"注销", @"清理缓存", @"关于系统"];
    NSArray *imagesArray = @[@"system_logout", @"system_clean", @"system_about"];
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:self.moreButton titleArray:titlesArray imageArray:imagesArray];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        switch (menuRow) {
            case 0: {
                [[XJSUserManager sharedUserInfo] removeUserInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:XJSLoginStatusDidChange object:@NO];
            }
                break;
            case 1: {
                
            }
                break;
            case 2: {
                
            }
                break;
            default:
                break;
        }
    };
}
#pragma mark - Patient infomation cell delegate
- (void)didClickTraining:(XJSPatientModel *)model {
    XJSTrainingCenterViewController *trainingCenterController = [[UIStoryboard storyboardWithName:@"Training" bundle:nil] instantiateViewControllerWithIdentifier:@"XJSTrainingCenter"];
    trainingCenterController.patientModel = model;
    [self.navigationController pushViewController:trainingCenterController animated:YES];
}
- (void)didClickRecord:(XJSPatientModel *)model {
    
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.patientsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientInfomationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJSPatientInfomationCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    XJSPatientModel *patientModel = self.patientsArray[indexPath.row];
    cell.patientModel = patientModel;
    cell.nameLabel.text = patientModel.realname;
    cell.avatarImageView.image = patientModel.gender.integerValue == 1 ? [UIImage imageNamed:@"head_boy"] : [UIImage imageNamed:@"head_girl"];
    cell.patientNumberLabel.text = patientModel.patientNumber;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@岁", patientModel.age];
    cell.diseaseLabel.text = patientModel.symptoms;
    return cell;
}
#pragma mark - Collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){kXJSPatientInfoCellWidth, kXJSPatientInfoCellHeight};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 18.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientModel *model = self.patientsArray[indexPath.row];
    XJSPatientDetailViewController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSPatientDetail"];
    detailController.patientModel = model;
    [self.navigationController pushViewController:detailController animated:YES];
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
- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(0, 0, 40, 40);
        [_searchButton setImage:[UIImage imageNamed:@"navigation_search"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
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
- (NSMutableArray *)patientsArray {
    if (!_patientsArray) {
        _patientsArray = [[NSMutableArray alloc] init];
    }
    return _patientsArray;
}

@end
