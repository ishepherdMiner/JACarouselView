//
//  JACarouselViewCell.h
//  Carousel
//
//  Created by Jason on 14/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JACarouselViewCell : UIView
@property (nonatomic,strong,readonly) UIImageView *imageView;
@property (nonatomic,copy) void (^clickBlock)(void);

// @property (nonatomic,copy) IBInspectable NSString *identifier;

@end

NS_ASSUME_NONNULL_END
