//
//  MZBannerView.h
//  StudyDemo
//
//  Created by 曾龙 on 2018/8/27.
//  Copyright © 2018年 曾龙. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MZBannerView;
@protocol MZBannerViewDelegate<NSObject>
@optional
- (void)bannerView:(MZBannerView *)bannerView didSelectedIndex:(NSInteger)index data:(id)data;
@end

@interface MZBannerView : UIView

/**
 占位图
 */
@property (nonatomic, strong) UIImage *placeholder;

/**
 网络图片链接数组
 */
@property (nonatomic, strong) NSArray *imageUrls;

/**
 本地图片名称数组
 */
@property (nonatomic, strong) NSArray *imageNames;

/**
 数据数组，用于点击后返回对应数据
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 pageControl未选中颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 pageControl选中颜色
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 是否自动轮播
 */
@property (nonatomic, assign) BOOL autoScroll;

/**
 轮播间隔时间
 */
@property (nonatomic, assign) NSTimeInterval interval;

/**
 是否隐藏pageControl
 */
@property (nonatomic, assign) BOOL hidePageControl;
@property (nonatomic, weak) id<MZBannerViewDelegate> delegate;
@end
