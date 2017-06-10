//
//  BannerlViewController.m
//  JACarouselView
//
//  Created by Jason on 09/06/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "BannerViewController.h"
#import "JACarouselView.h"
#import "JACarouselViewCell.h"
#import "UIImageView+WebCache.h"

@interface BannerViewController () <JACarouselDelegate,JACarouselDatasource>

@property (nonatomic,weak) JACarouselView *carouselView;
@property (nonatomic,strong) NSArray *dataList;

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    JACarouselView *carouselView = [[JACarouselView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 160)];
    carouselView.dataSource = self;
    carouselView.delegate = self;
    carouselView.timeInterval = 2.0;
    carouselView.autoPlay = true;
    [self.view addSubview:_carouselView = carouselView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 1.req...
    [self dataList];
    // 2.completed block exec reload
    [self.carouselView reloadData];
}

- (NSInteger)numberOfColInCarouselView:(JACarouselView *)carouselView {
    // simulate
    if (_dataList.count == 0) {
        return 0;
    }
    return self.dataList.count;
}

- (JACarouselViewCell *)carouselView:(JACarouselView *)carouselView cellForCol:(NSInteger)col {
    JACarouselViewCell *cell = [[JACarouselViewCell alloc] initWithFrame:self.carouselView.bounds];
    // SDWebImage
    [cell.imageView sd_setImageWithURL:self.dataList[col] placeholderImage:nil];
    return cell;
}

- (NSArray *)dataList {
    if (_dataList == nil) {
        _dataList = @[
                      @"http://imgsrc.baidu.com/forum/pic/item/4ec2d5628535e5dd55d2464876c6a7efcf1b62af.jpg",
                      @"http://desk.fd.zol-img.com.cn/t_s960x600c5/g3/M03/0D/03/Cg-4V1S_EOWIMyUCAAhG5zFfIHUAATsVQNFKM0ACEb_770.jpg",
                      @"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/01/0E/ChMkJlbKwaOIN8zJAAs5DadIS-IAALGbQPo5ngACzkl365.jpg",
                      ];
    }
    return _dataList;
}

- (void)carouseView:(JACarouselView *)carouselView didSelectCol:(NSInteger)col {
    NSLog(@"%s,%ld",__func__,(long)col);
}

- (void)carouseView:(JACarouselView *)carouselView didMoveToCol:(NSInteger)col {
    NSLog(@"%s,%ld",__func__,(long)col);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
