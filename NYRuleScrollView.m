//
//  NYRuleScrollView.m
//  NYRuler
//
//  Created by Akries.Ni on 2017/2/15.
//  Copyright © 2017年 Ak. All rights reserved.
//

#import "NYRuleScrollView.h"

@implementation NYRuleScrollView

- (void)setRulerValue:(CGFloat)rulerValue
{
    _rulerValue = rulerValue;
}

- (void)drawRuler {
    
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 0.5f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 0.5f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    for (int i = 0; i <= self.rulerCount; i++) {
        UILabel *rule = [[UILabel alloc] init];
        rule.textColor = [UIColor lightGrayColor];
        rule.text = [NSString stringWithFormat:@"%.0f",i * [self.rulerAverage floatValue]];
        CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];

        if (i % 10 == 0) {
            CGPathMoveToPoint(pathRef2, NULL, DistanceLeftAndRight + DistanceValue * i , self.rulerHeight - 20);
            CGPathAddLineToPoint(pathRef2, NULL, DistanceLeftAndRight + DistanceValue * i, self.rulerHeight);
            rule.frame = CGRectMake(DistanceLeftAndRight + DistanceValue * i - textSize.width / 2,  DistanceTopAndBottom , 0, 0);
            [rule sizeToFit];
//            [self addSubview:rule];
        }
        else
        {
            CGPathMoveToPoint(pathRef1, NULL, DistanceLeftAndRight + DistanceValue * i , self.rulerHeight - 10);
            CGPathAddLineToPoint(pathRef1, NULL, DistanceLeftAndRight + DistanceValue * i, self.rulerHeight);
        }
    }
    
    shapeLayer1.path = pathRef1;
    shapeLayer2.path = pathRef2;
    
    [self.layer addSublayer:shapeLayer1];
    [self.layer addSublayer:shapeLayer2];
    
    self.frame = CGRectMake(0, 0, self.rulerWidth, self.rulerHeight);
    
    // 开启最小模式
    if (_mode) {
        UIEdgeInsets edge = UIEdgeInsetsMake(0, self.rulerWidth / 2.f - DistanceLeftAndRight, 0, self.rulerWidth / 2.f - DistanceLeftAndRight);
        self.contentInset = edge;
        self.contentOffset = CGPointMake(DistanceValue * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth + (self.rulerWidth / 2.f + DistanceLeftAndRight), 0);
    }
    else
    {
//        AkrLog(@"%.4f   %.4f",self.rulerValue,DistanceValue * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + DistanceLeftAndRight);
        self.contentOffset = CGPointMake(DistanceValue * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + DistanceLeftAndRight, 0);

//        CGFloat offSetX = self.contentOffset.x + self.frame.size.width / 2 - DistanceLeftAndRight;
//        CGFloat ruleValue = (offSetX / DistanceValue) * [self.rulerAverage floatValue];
//        AkrLog(@"%.4f",ruleValue);
//        
//        AkrLog(@"%.4f   %.4f",self.rulerValue,DistanceValue * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + DistanceLeftAndRight);
        
        
//            NYAudioTool *tool = [[NYAudioTool alloc] initSystemSoundWithName:@"Tock" SoundType:@"caf"];
//            [tool play];
    }
    
    self.contentSize = CGSizeMake(self.rulerCount * DistanceValue + DistanceLeftAndRight * 2.f, self.rulerHeight);
}

- (void)drawRulerCount {

    for (int i = 0; i <= self.rulerCount; i++) {
        UILabel *rule = [[UILabel alloc] init];
        rule.textColor = [UIColor lightGrayColor];
        rule.text = [NSString stringWithFormat:@"%.0f",i * [self.rulerAverage floatValue]];
        CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
        
        if (i % 10 == 0) {
            rule.frame = CGRectMake(DistanceLeftAndRight + DistanceValue * i - textSize.width / 2,  DistanceTopAndBottom , 0, 0);
            [rule sizeToFit];
            [self addSubview:rule];
        }
    }
}

@end
