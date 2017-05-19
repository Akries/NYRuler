//
//  NYRuler.h
//  NYRuler
//
//  Created by Akries.Ni on 2017/2/23.
//  Copyright © 2017年 Akries.NY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYRuleScrollView.h"

@protocol NYRulerDelegate <NSObject>

- (void)txhRrettyRuler:(NYRuleScrollView *)ruleScrollView;

@end

@interface NYRuler : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, assign) id <NYRulerDelegate> rulerDeletate;

/*
 *  count * average = 刻度最大值
 *  @param count        10个小刻度为一个大刻度，大刻度的数量
 *  @param average      每个小刻度的值，最小精度 0.1
 *  @param currentValue 直尺初始化的刻度值
 *  @param mode         是否最小模式
 */
- (void)showRulerScrollViewWithCount:(NSUInteger)count
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode;

- (void)setCurrentRulerValue:(CGFloat )ruleValue;
@end
