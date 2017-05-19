//
//  NYRuleScrollView.h
//  NYRuler
//
//  Created by Akries.Ni on 2017/2/15.
//  Copyright © 2017年 Ak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DistanceLeftAndRight 8.f // 标尺左右距离
#define DistanceValue 8.f // 每隔刻度实际长度8个点
#define DistanceTopAndBottom 14.f // 标尺上下距离



@interface NYRuleScrollView : UIScrollView

@property (nonatomic) NSUInteger rulerCount;

@property (nonatomic) NSNumber * rulerAverage;

@property (nonatomic) NSUInteger rulerHeight;

@property (nonatomic) NSUInteger rulerWidth;

@property (nonatomic) CGFloat rulerValue;

@property (nonatomic) BOOL mode;

- (void)drawRuler;
- (void)drawRulerCount;
@end
