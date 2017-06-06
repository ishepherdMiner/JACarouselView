//
//  JACarouselViewCell.m
//  Carousel
//
//  Created by Jason on 14/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import "JACarouselViewCell.h"
#import "JACarouselView.h"

@interface JACarouselViewCell() {
    UIImageView *_imageView;
}

@property (nonatomic,strong) UITapGestureRecognizer *tap;

@end

@implementation JACarouselViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTap];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTap];
}

- (void)addTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCell:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_imageView) {
        [self addSubview:_imageView];
    }
}

- (void)clickCell:(JACarouselViewCell *)cell {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}


@end
