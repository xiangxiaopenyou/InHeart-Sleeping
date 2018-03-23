//
//  XJSAddPatientViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSAddPatientViewController.h"
#import "XJSPatientCommonInfomationCell.h"

@interface XJSAddPatientViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation XJSAddPatientViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)addAction:(id)sender {
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientCommonInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJSPatientCommonInfomationCell" forIndexPath:indexPath];
    if (tableView == self.leftTableView) {
        [cell setupContentView:1 index:indexPath.row];
    } else {
        [cell setupContentView:2 index:indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientCommonInfomationCell *cell = (XJSPatientCommonInfomationCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (tableView == self.leftTableView) {
        if (indexPath.row == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:maleAction];
            [alert addAction:femaleAction];
            UIPopoverPresentationController *popover = alert.popoverPresentationController;
            if (popover) {
                popover.sourceView = cell.contentView;
                popover.sourceRect = cell.contentView.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
            }
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
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
