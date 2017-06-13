//
//  JACarouselView.m
//  Carousel
//
//  Created by Jason on 14/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import "JACarouselView.h"
#import "JACarouselViewCell.h"

@interface JACarouselView()  <UIScrollViewDelegate> {
    NSTimeInterval _timeInterval;
    BOOL _autoPlay;
    BOOL _hiddenPageControl;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic) NSUInteger cols;
@property (nonatomic) NSUInteger offset;
@property (nonatomic,strong) UIImageView *bitImageView;

// - JATimer
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) NSUInteger page;

@end

@implementation JACarouselView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI {
    [self addSubview:[self scrollView]];
    self.type = JACarouselTypeBanner;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = false;
        _scrollView.pagingEnabled = true;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.showsVerticalScrollIndicator = false;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 2 4
    _scrollView.frame = self.bounds;

    if (self.type == JACarouselTypeBanner) {
        
        _scrollView.contentSize = CGSizeMake((_cols + 2) * _scrollView.frame.size.width,_scrollView.frame.size.height);
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
        
    }else if (self.type == JACarouselTypeGuide) {
        
        _scrollView.contentSize = CGSizeMake(_cols * _scrollView.frame.size.width,_scrollView.frame.size.height);
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    if (self.isHiddenPageControl == false) {
        [self pageControl];
        // 排除x对center.x产生的影响
        _pageControl.center = CGPointMake(self.center.x - self.frame.origin.x, self.frame.size.height - 10 + self.pageOffset.y);
        _pageControl.numberOfPages = _cols;
        
        if (self.type == JACarouselTypeBanner) {
            _pageControl.currentPage = 0;
            _pageControl.hidesForSinglePage = true;
            _offset = 1;
        }else if (self.type == JACarouselTypeGuide) {
            _offset = 0;
            _pageControl.currentPage = 0;
        }
        
        _page = _pageControl.currentPage + _offset;
        [self addSubview:_pageControl];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        // 1
        if (_bitImage == nil && self.type != JACarouselTypeGuide) {
            NSString *imagesBundlePath = [[NSBundle mainBundle] pathForResource:@"JACarouselView" ofType:@"bundle"];
            NSBundle *imagesBundle = [NSBundle bundleWithPath:imagesBundlePath];
            NSString *placeHolderPath = [imagesBundle pathForResource:@"holder@2x" ofType:@"png"];
            NSData *placeHodlerData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:placeHolderPath]];
            _bitImage = [UIImage imageWithData:placeHodlerData];
            
            _bitImageView = [[UIImageView alloc] initWithImage:_bitImage];
            _bitImageView.frame = self.bounds;
            _bitImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:_bitImageView];
        }
        [self reloadData];
    }else {
        [self stop];
    }
}

- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 数据刷新
- (void)reloadData {
    // 3
    if (self.dataSource == nil) {return;}

    dispatch_async(dispatch_get_main_queue(), ^{        
        if ([self.dataSource respondsToSelector:@selector(numberOfColInCarouselView:)]) {
            _cols = [self.dataSource numberOfColInCarouselView:self];
        }
        
        if(_cols == 0) {return;}
        
        // 避免重复添加
        __block NSUInteger cols = 0;
        [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[JACarouselViewCell class]]) {
                cols++;
            }
        }];
        CGFloat extraCellNums = self.type == JACarouselTypeBanner ? 2 : 0;
        if (cols >= _cols + extraCellNums) {return;}
        
        [self allCheckerDataSource];
        
        for (int i = 0; i < _cols; ++i) {
            JACarouselViewCell *cell = [self createCellWithCol:i];
            [_scrollView addSubview:cell];
            if (cell.imageView.image) {
                [self.bitImageView removeFromSuperview];
            }else {
                [cell addObserver:self forKeyPath:@"imageView.image" options:NSKeyValueObservingOptionNew context:NULL];
            }
        }
        
        
        if (self.type == JACarouselTypeBanner) {
            JACarouselViewCell *firstCell = [self.dataSource carouselView:self cellForCol:0];
            [self setCellFrame:firstCell withCol:_cols];
            [_scrollView addSubview:firstCell];
            
            JACarouselViewCell *lastCell = [self.dataSource carouselView:self cellForCol:_cols - 1];
            [self setCellFrame:lastCell withCol:-1];
            [_scrollView addSubview:lastCell];
        }
        // 实际开发中,数据源开始时一般为空,等网络请求后才获得数据源，
        // 先add 走了 setLayoutSubview
        // 后reload也需要重新走 setLayoutSubview
        // 否则_cols值就不对了,因此加了这句话。
        [self setNeedsLayout];
        
        if ([self canAutoPlay] && self.bitImageView.superview == nil) {
            [self fire];
        }
    });
    
}

- (JACarouselViewCell *)createCellWithCol:(NSInteger)col {
    JACarouselViewCell *cell = [self.dataSource carouselView:self cellForCol:col];
    [self setCellFrame:cell withCol:col];
    
    __weak __typeof(&*self) weakSelf = self;
    cell.clickBlock = ^ {
        if ([weakSelf.delegate respondsToSelector:@selector(carouseView:didSelectCol:)]) {
            [weakSelf.delegate carouseView:self didSelectCol:col];
        }
    };
    
    return cell;
}

- (void)setCellFrame:(JACarouselViewCell *)cell
             withCol:(NSInteger)col {
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (self.type == JACarouselTypeBanner) {
        CGRect frame = {CGPointMake((col + 1) * width, 0),{width,height}};
        cell.frame = frame;
    }else {
        CGRect frame = {CGPointMake(col * width, 0),{width,height}};
        cell.frame = frame;
    }
}

- (void)setBitImage:(UIImage *)bitImage {
    _bitImage = bitImage;
    _bitImageView = [[UIImageView alloc] initWithImage:self.bitImage];
    _bitImageView.frame = self.bounds;
    _bitImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_bitImageView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object valueForKeyPath:@"imageView.image"]) {
        if (self.bitImageView) {
            [self setNeedsLayout];
            [self fire];
            [UIView animateWithDuration:0.5 animations:^{
                self.bitImageView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.bitImageView removeFromSuperview];                
            }];
        }
    }
}

#pragma makr - UIScrollView代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self canAutoPlay]) {
        [self stop];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    if(_page == 0) {
        if (self.type == JACarouselTypeBanner) {
            scrollView.contentOffset = CGPointMake(_cols * scrollView.frame.size.width, 0);
            _page = _cols;
        }
    }
    
    if(_page == _cols + 1) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
        _page = 1;
    }
    
    [self didMoveToCol];

    if (_hiddenPageControl == false) {
        _pageControl.currentPage = (_page - _offset) % _cols;
    }
    
    if ([self canAutoPlay]) {
        [self fire];
    }
}

#pragma mark - 其他

- (BOOL)canAutoPlay {
    if (_autoPlay && _cols > 1) {
        return true;
    }
    return false;
}

- (void)allCheckerDataSource{
    if (![self.dataSource respondsToSelector:@selector(carouselView:cellForCol:)]) {
        NSAssert(false, [NSString stringWithFormat:@"You must implement the carouselView:cellForCol: function"]);
    }
}

- (void)willMoveToCol {
    if ([self.delegate respondsToSelector:@selector(carouseView:willMoveToCol:)]) {
        [self.delegate carouseView:self willMoveToCol:(_page - _offset) % _cols];
    }
}

- (void)didMoveToCol {
    if ([self.delegate respondsToSelector:@selector(carouseView:didMoveToCol:)]) {
        [self.delegate carouseView:self didMoveToCol:(_page - _offset) % _cols];
    }
}


@end

@implementation JACarouselView (JATimer)

- (void)fire {
    if (self.isAutoPlay) {
        if (_timeInterval == 0) {_timeInterval = 2;}
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(exec) userInfo:nil repeats:true];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        
    }else {
        NSLog(@"You need be set autoPlay value equal to true");
    }
}

- (void)exec {
    [self willMoveToCol];
    CGFloat width = _scrollView.frame.size.width;
    if (_page <= _cols) {
        [_scrollView setContentOffset:CGPointMake(++_page * width, 0) animated:true];
        if (_page == _cols + 1) {
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
    }else {
         _page = 0 + _offset;
        [_scrollView setContentOffset:CGPointMake(++_page * width, 0) animated:true];
    }
    [self didMoveToCol];
    if (_hiddenPageControl == false) {
        _pageControl.currentPage = (_page - _offset) % _cols;
    }
}

- (void)stop {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        // 处理出现轮播停止时卡在中间的情况
        int offset = (int)_scrollView.contentOffset.x;
        int width = (int)_scrollView.frame.size.width;
        if (offset % width != 0) {
            BOOL moreHalf = (CGFloat)(offset - width * (_page - 1) ) / width > 0.5 ? true : false;
            if (moreHalf) {
                [_scrollView setContentOffset:CGPointMake(width * _page, 0) animated:false];
            }else {
                [_scrollView setContentOffset:CGPointMake(width * (_page - 1), 0) animated:false];
                _page -= 1;
                _pageControl.currentPage = _page;
            }
        }
    }
}

- (void)setAutoPlay:(BOOL)autoPlay {
    _autoPlay = autoPlay;
}

- (BOOL)isAutoPlay {
    return _autoPlay;
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
}

- (NSTimeInterval)timeInterval {
    return _timeInterval;
}

- (BOOL)isHiddenPageControl {
    return _hiddenPageControl;
}

- (void)setHiddenPageControl:(BOOL)hiddenPageControl {
    _hiddenPageControl = hiddenPageControl;
}
@end
