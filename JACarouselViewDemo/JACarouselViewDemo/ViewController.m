//
//  ViewController.m
//  JACarouselView
//
//  Created by Jason on 06/06/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "ViewController.h"
#import "JACarouselView.h"
#import "JACarouselViewCell.h"
#import "BannerViewController.h"
#import "GuideViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,weak) JACarouselView *carouselView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[@"Banner",@"Guide"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 1.req...
    [self datas];
    // 2.completed block exec reload
    [self.carouselView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JACarouselCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JACarouselCell"];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            BannerViewController *vc = [[BannerViewController alloc] init];
            vc.title = self.datas[indexPath.row];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 1:
        {
            GuideViewController *vc = [[GuideViewController alloc] init];
            vc.title = self.datas[indexPath.row];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
