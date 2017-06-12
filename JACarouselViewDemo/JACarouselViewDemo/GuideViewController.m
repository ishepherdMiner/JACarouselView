//
//  GuideViewController.m
//  JACarouselView
//
//  Created by Jason on 10/06/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "GuideViewController.h"
#import "JACarouselView.h"
#import "JACarouselViewCell.h"

@interface GuideViewController () <JACarouselDelegate,JACarouselDatasource>

@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,weak) JACarouselView *carouselView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    JACarouselView *carouselView = [[JACarouselView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, UIScreen.mainScreen.bounds.size.height - 64)];
    carouselView.dataSource = self;
    carouselView.type = JACarouselTypeGuide;
    carouselView.delegate = self;    
    [self.view addSubview:_carouselView = carouselView];
}

- (NSInteger)numberOfColInCarouselView:(JACarouselView *)carouselView {
    return self.dataList.count;
}

- (JACarouselViewCell *)carouselView:(JACarouselView *)carouselView cellForCol:(NSInteger)col {
    JACarouselViewCell *cell = [[JACarouselViewCell alloc] initWithFrame:self.view.bounds];
    cell.imageView.image = [UIImage imageNamed:self.dataList[col]];
    cell.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

- (NSArray *)dataList {
    if (_dataList == nil) {
        if (UIScreen.mainScreen.bounds.size.width == 320) {
            _dataList = @[@"4_welcome1",@"4_welcome2",@"4_welcome3"];
        }else if (UIScreen.mainScreen.bounds.size.width >= 375) {
            _dataList = @[@"6_welcome1",@"6_welcome2",@"6_welcome3"];
        }
    }
    return _dataList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
