//
//  NYRuler.m
//  NYRuler
//
//  Created by Akries.Ni on 2017/2/23.
//  Copyright © 2017年 Akries.NY. All rights reserved.
//

#import "NYRuler.h"

#define SHEIGHT 40 // 中间指示器顶部闭合三角形高度
#define INDICATORCOLOR [UIColor redColor].CGColor // 中间指示器颜色

@implementation NYRuler {
    NYRuleScrollView * rulerScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        rulerScrollView = [self rulerScrollView];
        rulerScrollView.rulerHeight = frame.size.height;
        rulerScrollView.rulerWidth = frame.size.width;
    }
    return self;
}

- (void)showRulerScrollViewWithCount:(NSUInteger)count
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode {
    NSAssert(rulerScrollView != nil, @"***** 调用此方法前，请先调用 initWithFrame:(CGRect)frame 方法初始化对象 rulerScrollView\n");
//    NSAssert(currentValue <= [average floatValue] * count, @"***** currentValue 不能大于直尺最大值（count * average）\n");
    rulerScrollView.rulerAverage = average;
    rulerScrollView.rulerCount = count;
    rulerScrollView.rulerValue = currentValue;
    rulerScrollView.mode = mode;
    [rulerScrollView drawRuler];
    [rulerScrollView drawRulerCount];
    [self addSubview:rulerScrollView];
    [self drawRacAndLine];
}

- (void)setCurrentRulerValue:(CGFloat)ruleValue
{
    rulerScrollView.rulerValue = ruleValue;
    [rulerScrollView drawRuler];
}

- (NYRuleScrollView *)rulerScrollView {
    NYRuleScrollView * rScrollView = [NYRuleScrollView new];
    rScrollView.delegate = self;
    rScrollView.showsHorizontalScrollIndicator = NO;
    return rScrollView;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(NYRuleScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DistanceLeftAndRight;
    NSInteger ruleValue = (offSetX / DistanceValue) * [scrollView.rulerAverage floatValue];
    ruleValue = ruleValue/100;
    ruleValue = ruleValue * 100;
//    AkrLog(@"----------------------------------------%.4f   %.4f",ruleValue,DistanceValue * (ruleValue /  [scrollView.rulerAverage floatValue]) - SCREEN_WIDTH / 2.f + DistanceLeftAndRight);
    
    if (ruleValue < 0.f) {
        return;
    } else if (ruleValue > scrollView.rulerCount * [scrollView.rulerAverage floatValue]) {
        return;
    }
    if (self.rulerDeletate) {
        if (!scrollView.mode) {
            scrollView.rulerValue = ruleValue;
        }
        scrollView.mode = NO;
        [self.rulerDeletate txhRrettyRuler:scrollView];
    }
}



- (void)scrollViewDidEndDecelerating:(NYRuleScrollView *)scrollView {
    [self animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(NYRuleScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self animationRebound:scrollView];
}

- (void)animationRebound:(NYRuleScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DistanceLeftAndRight;
    CGFloat oX = (offSetX / DistanceValue) * [scrollView.rulerAverage floatValue];

    
    if ([self valueIsInteger:scrollView.rulerAverage]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
    
    int temp = oX/[scrollView.rulerAverage floatValue];
    oX = temp * [scrollView.rulerAverage floatValue];
    
    CGFloat offX = (oX / ([scrollView.rulerAverage floatValue])) * DistanceValue + DistanceLeftAndRight - self.frame.size.width / 2;
    
    [UIView animateWithDuration:.2f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
//        NYAudioTool *tool = [[NYAudioTool alloc] initSystemSoundWithName:@"Tock" SoundType:@"caf"];
//        [tool play];
    }];
}

- (void)drawRacAndLine {
    // 圆弧  虚线
    CAShapeLayer *shapeLayerArc = [CAShapeLayer layer];
    shapeLayerArc.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayerArc.fillColor = [UIColor clearColor].CGColor;
    shapeLayerArc.lineWidth = 0.5f;
    shapeLayerArc.lineCap = kCALineCapButt;
    shapeLayerArc.frame = self.bounds;
    
    CGMutablePathRef pathArcDash = CGPathCreateMutable();
    //  设置线宽，线间距，虚线
    [shapeLayerArc setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:4], nil]];
    //虚线
    CGPathMoveToPoint(pathArcDash, NULL, self.frame.size.width/2 - 40, DistanceTopAndBottom/4);
    CGPathAddQuadCurveToPoint(pathArcDash, NULL, self.frame.size.width / 2, DistanceTopAndBottom/4, self.frame.size.width/2 + 40, DistanceTopAndBottom/4);
    //圆弧
    //    CGPathMoveToPoint(pathArc, NULL, self.frame.size.width/2 - 40, DistanceTopAndBottom/2);
    //    CGPathAddQuadCurveToPoint(pathArc, NULL, self.frame.size.width / 2, -DistanceTopAndBottom/2, self.frame.size.width/2, DistanceTopAndBottom);
    
    //    CGPathMoveToPoint(pathArc, NULL, self.frame.size.width/2 + 40, DistanceTopAndBottom/2);
    //    CGPathAddQuadCurveToPoint(pathArc, NULL, self.frame.size.width / 2, -DistanceTopAndBottom/2, self.frame.size.width/2, DistanceTopAndBottom);
    
    shapeLayerArc.path = pathArcDash;
    [self.layer addSublayer:shapeLayerArc];
    
    
    
    // 横线
    CAShapeLayer *shapeLayerNormolLine = [CAShapeLayer layer];
    shapeLayerNormolLine.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayerNormolLine.fillColor = [UIColor clearColor].CGColor;
    shapeLayerNormolLine.lineWidth = 0.5f;
    shapeLayerNormolLine.lineCap = kCALineCapButt;
    shapeLayerNormolLine.frame = self.bounds;
    
    CGMutablePathRef pathArcNormol = CGPathCreateMutable();
    //横线
    CGPathMoveToPoint(pathArcNormol, NULL, 0, self.frame.size.height - 1);
    CGPathAddLineToPoint(pathArcNormol, NULL, self.frame.size.width, self.frame.size.height);
    
    shapeLayerNormolLine.path = pathArcNormol;
    [self.layer addSublayer:shapeLayerNormolLine];

    

    
    // 渐变
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor];
    
    gradient.locations = @[[NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.6f]];
    
    gradient.startPoint = CGPointMake(0, .5);
    gradient.endPoint = CGPointMake(1, .5);

    [self.layer addSublayer:gradient];
    
    // 红色指示器
    CAShapeLayer *shapeLayerLine = [CAShapeLayer layer];
    shapeLayerLine.strokeColor = [UIColor redColor].CGColor;
    shapeLayerLine.fillColor = INDICATORCOLOR;
    shapeLayerLine.lineWidth = 0.5f;
    shapeLayerLine.lineCap = kCALineCapSquare;
    
//    NSUInteger ruleHeight = 20; // 文字高度
    CGMutablePathRef pathLine = CGPathCreateMutable();
    CGPathMoveToPoint(pathLine, NULL, self.frame.size.width / 2,self.frame.size.height - SHEIGHT);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height);
    
    //    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 - SHEIGHT / 2, DISTANCETOPANDBOTTOM);
    //    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 + SHEIGHT / 2, DISTANCETOPANDBOTTOM);
    //    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, DISTANCETOPANDBOTTOM + SHEIGHT);
    
    shapeLayerLine.path = pathLine;
    [self.layer addSublayer:shapeLayerLine];
}

#pragma mark - tool method

- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler*roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber*ouncesDecimal;
    NSDecimalNumber*roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces floatValue];
}

- (BOOL)valueIsInteger:(NSNumber *)number {
    NSString *value = [NSString stringWithFormat:@"%f",[number floatValue]];
    if (value != nil) {
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *temp = nil;
        for(int i =0; i < [valueEnd length]; i++)
        {
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}

@end
