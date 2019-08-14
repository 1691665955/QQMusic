//
//  MZBannerView.m
//  StudyDemo
//
//  Created by 曾龙 on 2018/8/27.
//  Copyright © 2018年 曾龙. All rights reserved.
//

#import "MZBannerView.h"
#import "UIImageView+WebCache.h"

#define DefaultTimeInterval 4

@interface MZBannerView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation MZBannerView
{
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.autoScroll = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.contentSize = CGSizeMake(0, 0);
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width-100)/2, self.frame.size.height-25, 100,15)];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:90/255.0 green:160/255.0 blue:245/255.0 alpha:1];
    self.pageControl.hidesForSinglePage = YES;
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.pageControl.frame = CGRectMake((self.frame.size.width-100)/2, self.frame.size.height-25, 100,15);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*self.scrollView.subviews.count, 0);
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIView *view = [self.scrollView viewWithTag:999+i];
        view.frame = CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height);
    }
    if (self.scrollView.subviews.count >= 3) {
        self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
}

- (void)setDelegate:(id<MZBannerViewDelegate>)delegate {
    _delegate = delegate;
    if ([delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)delegate;
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            vc.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

- (void)setImageUrls:( NSArray *)imageUrls {
    _imageUrls = imageUrls;
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    if (imageUrls.count == 0) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 0);
        self.scrollView.contentOffset = CGPointMake(0, 0);
        if (self.placeholder) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            imageView.image = self.placeholder;
            [self.scrollView addSubview:imageView];
        }
    } else {
        for (int i = 0; i < imageUrls.count+2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            NSString *url;
            if (i == imageUrls.count+1) {
                url = imageUrls[0];
            } else if (i == 0) {
                url = imageUrls[imageUrls.count-1];
            } else {
                url = imageUrls[i-1];
            }
            if (self.placeholder) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.placeholder];
            } else {
                [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            }
            imageView.tag = 999+i;
            [self.scrollView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
        }
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*(imageUrls.count+2), 0);
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
    self.pageControl.numberOfPages = imageUrls.count;
    self.pageControl.currentPage = 0;
    [self autoPlay];
}

- (void)setImageNames:(NSArray *)imageNames {
    _imageNames = imageNames;
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    if (imageNames.count == 0) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 0);
        self.scrollView.contentOffset = CGPointMake(0, 0);
        if (self.placeholder) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            imageView.image = self.placeholder;
            [self.scrollView addSubview:imageView];
        }
    } else {
        for (int i = 0; i < imageNames.count+2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            NSString *imageName;
            if (i == imageNames.count+1) {
                imageName = imageNames[0];
            } else if (i == 0) {
                imageName = imageNames[imageNames.count-1];
            } else {
                imageName = imageNames[i-1];
            }
            imageView.image = [UIImage imageNamed:imageName];
            imageView.tag = 999+i;
            [self.scrollView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
        }
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*(imageNames.count+2), 0);
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
    self.pageControl.numberOfPages = imageNames.count;
    self.pageControl.currentPage = 0;
    [self autoPlay];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    self.pageControl.pageIndicatorTintColor = normalColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.pageControl.currentPageIndicatorTintColor = tintColor;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (autoScroll) {
        [self autoPlay];
    } else {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        if (self.scrollView.subviews.count > 0) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
        }
    }
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    _hidePageControl = hidePageControl;
    self.pageControl.hidden = hidePageControl;
}

- (void)tapImageView:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    if (index == 999) {
        index = 999+self.scrollView.subviews.count;
    } else if (index == 1000+self.scrollView.subviews.count) {
        index = 1000;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectedIndex:data:)]) {
        [self.delegate bannerView:self didSelectedIndex:index-1000 data:self.dataArray?self.dataArray[index-1000]:nil];
    }
}

- (void)autoPlay {
    if (!self.autoScroll) {
        return;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (self.interval == 0) {
        _interval = DefaultTimeInterval;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(timeFun) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    [self autoPlay];
}

- (void)timeFun {
    CGPoint point = self.scrollView.contentOffset;
    point.x += self.scrollView.frame.size.width;
//    [self.scrollView setContentOffset:point animated:YES];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = point;
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_timer isValid]) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_timer isValid]) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.interval]];
    }
    
    if ([_timer isValid] && [[_timer fireDate] timeIntervalSinceDate:[NSDate date]] < 1000000000) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.x <= 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*self.scrollView.frame.size.width, 0);
        } else if(offset.x+1 >= scrollView.contentSize.width-self.scrollView.frame.size.width) {
            scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
        }
    }
    
    NSInteger page = (NSInteger)((scrollView.contentOffset.x+1)/self.scrollView.frame.size.width);
    self.pageControl.currentPage = page-1;
    scrollView.contentOffset = CGPointMake((self.pageControl.currentPage+1)*self.scrollView.frame.size.width, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_timer isValid] && [[_timer fireDate] timeIntervalSinceDate:[NSDate date]] > 1000000000) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.x <= 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*self.scrollView.frame.size.width, 0);
        } else if(offset.x+1 >= scrollView.contentSize.width-self.scrollView.frame.size.width) {
            scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
        }
    }
    NSInteger page = (NSInteger)(scrollView.contentOffset.x/scrollView.frame.size.width);
    self.pageControl.currentPage = page-1;
}

@end
