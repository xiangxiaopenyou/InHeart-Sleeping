//
//  XJSTrainingCenterViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSTrainingCenterViewController.h"

#import "XJSTherapyTitleCell.h"
#import "XJSSceneCollectionViewCell.h"

#import "XJSTherapyModel.h"
#import "XJSSceneModel.h"
#import "XJSPatientModel.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define kXJSSceneCollectionCellWidth (XJSScreenWidth - 480) / 3.0


@interface XJSTrainingCenterViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *scenesCollectionView;
@property (weak, nonatomic) IBOutlet UIView *viewOfTherapies;

@property (strong, nonatomic) UITableView *therapyTableView;

@property (copy, nonatomic) NSArray *therapiesArray;
@property (strong, nonatomic) NSIndexPath *selectedTherapyIndexPath;
@property (strong, nonatomic) NSMutableArray *scenesArray;
@property (nonatomic) NSInteger scenePaging;

@end

@implementation XJSTrainingCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewOfTherapies addSubview:self.therapyTableView];
    self.therapyTableView.frame = CGRectMake(50, 0, XJSScreenWidth - 400.f, 80.f);
    
    self.recordButton.layer.masksToBounds = YES;
    self.recordButton.layer.cornerRadius = 10.f;
    self.recordButton.layer.borderWidth = 1.f;
    self.recordButton.layer.borderColor = XJSHexRGBColorWithAlpha(0x559bf5, 1).CGColor;
    
    _selectedTherapyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    [self setupUserInformations];
    
    [self fetchTherapyList];
    
    [self addRefreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)addRefreshView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _scenePaging = 1;
        [self fetchSceneList];
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.scenesCollectionView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchSceneList];
    }];
    footer.stateLabel.hidden = YES;
    self.scenesCollectionView.mj_footer = footer;
}
- (void)setupUserInformations {
    self.nameLabel.text = self.patientModel.realname;
    self.genderLabel.text = self.patientModel.gender.integerValue == 1 ? @"男" : @"女";
    self.avatarImageView.image = self.patientModel.gender.integerValue == 1 ? [UIImage imageNamed:@"head_boy"] : [UIImage imageNamed:@"head_girl"];
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁", self.patientModel.age];
}
- (void)setupTherapyInformations {
    XJSTherapyModel *therapyModel = _therapiesArray[_selectedTherapyIndexPath.row];
    self.instructionsLabel.text = therapyModel.instructions;
    self.attentionLabel.text = therapyModel.attention;
}

#pragma mark - Requests
- (void)fetchTherapyList {
    [XJSTherapyModel therapiesList:^(id object, NSString *msg) {
        if (object) {
            _therapiesArray = [(NSArray *)object copy];
            _scenePaging = 1;
            [self fetchSceneList];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupTherapyInformations];
                [self.therapyTableView reloadData];
            });
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}
- (void)fetchSceneList {
    XJSTherapyModel *therapyModel = _therapiesArray[_selectedTherapyIndexPath.row];
    NSString *therapyId = therapyModel.id;
    [XJSSceneModel scenesList:therapyId page:@(_scenePaging) handler:^(id object, NSString *msg) {
        [self.scenesCollectionView.mj_header endRefreshing];
        [self.scenesCollectionView.mj_footer endRefreshing];
        if (object) {
            NSArray *resultArray = [(NSArray *)object copy];
            if (_scenePaging == 1) {
                self.scenesArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.scenesArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.scenesArray = [tempArray mutableCopy];
            }
            if (resultArray.count < 10) {
                self.scenesCollectionView.mj_footer.hidden = YES;
                [self.scenesCollectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.scenesCollectionView.mj_footer.hidden = NO;
                _scenePaging += 1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.scenesCollectionView reloadData];
            });
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _therapiesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJSTherapyTitleCell *cell = [[XJSTherapyTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TherapyTitleCell"];
    if (indexPath == _selectedTherapyIndexPath) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    cell.transform = CGAffineTransformMakeRotation(- M_PI * 1.5);
    XJSTherapyModel *model = _therapiesArray[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.nameLabel.frame = CGRectMake(0, 0, 80, 80);
    cell.pointImageView.frame = CGRectMake(34, 68, 12, 12);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath != _selectedTherapyIndexPath) {
        _selectedTherapyIndexPath = indexPath;
        [self fetchSceneList];
    }
}

#pragma mark - Table view delegate

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.scenesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJSSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJSSceneCollectionViewCell" forIndexPath:indexPath];
    XJSSceneModel *model = self.scenesArray[indexPath.row];
    cell.sceneNameLabel.text = model.name;
    cell.sceneInstructionsLabel.text = model.introduction;
    [cell.sceneImageView sd_setImageWithURL:[NSURL URLWithString:model.coverPictureUrl]];
    return cell;
}

#pragma mark - Collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){kXJSSceneCollectionCellWidth, kXJSSceneCollectionCellWidth};
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.f;
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
- (UITableView *)therapyTableView {
    if (!_therapyTableView) {
        _therapyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _therapyTableView.showsVerticalScrollIndicator = NO;
        _therapyTableView.showsHorizontalScrollIndicator = NO;
        _therapyTableView.backgroundColor = [UIColor clearColor];
        _therapyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _therapyTableView.bounces = NO;
        _therapyTableView.delegate = self;
        _therapyTableView.dataSource = self;
        _therapyTableView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
    }
    return _therapyTableView;
}
- (NSMutableArray *)scenesArray {
    if (!_scenesArray) {
        _scenesArray = [[NSMutableArray alloc] init];
    }
    return _scenesArray;
}

@end
