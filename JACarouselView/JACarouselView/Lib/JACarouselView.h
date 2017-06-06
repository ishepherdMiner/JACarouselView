//
//  JACarouselView.h
//  Carousel
//
//  Created by Jason on 14/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JACarouselDelegate,JACarouselDatasource;

@class JACarouselView,JACarouselViewCell;

typedef NS_ENUM(NSUInteger,JACarouselType) {
    JACarouselTypeBanner,  // Banner 可以滚动
    JACarouselTypeGuide,   // 引导页
};

@protocol JACarouselDatasource <NSObject>

@required

- (JACarouselViewCell *)carouselView:(JACarouselView *)carouselView
                          cellForCol:(NSInteger)col;

@optional

// Default is 1 column
- (NSInteger)numberOfColInCarouselView:(JACarouselView *)carouselView;

@end

@protocol JACarouselDelegate <NSObject>

@optional

- (void)carouseView:(JACarouselView *)carouselView didSelectCol:(NSInteger)col;
- (void)carouseView:(JACarouselView *)carouselView willMoveToCol:(NSInteger)col;
- (void)carouseView:(JACarouselView *)carouselView didMoveToCol:(NSInteger)col;

@end

@interface JACarouselView : UIView

@property (nonatomic,strong,readonly) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,weak) id<JACarouselDatasource> dataSource;
@property (nonatomic,weak) id<JACarouselDelegate> delegate;
@property (nonatomic,strong) UIImage *bitImage;

/// 分页视图的偏移量
@property (nonatomic,assign) CGPoint pageOffset;
@property (nonatomic,assign) JACarouselType type;

- (void)reloadData;

@end

@interface JACarouselView (JATimer)

/// 时间间隔
@property (nonatomic) IBInspectable NSTimeInterval timeInterval;
/// 是否自动轮播 默认自动
@property (nonatomic,getter=isAutoPlay) IBInspectable BOOL autoPlay;
@property (nonatomic,getter=isHiddenPageControl) IBInspectable BOOL hiddenPageControl;

- (void)fire;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
