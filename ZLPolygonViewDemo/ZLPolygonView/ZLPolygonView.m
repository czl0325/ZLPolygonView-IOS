//
//  ZLPolygonView.m
//  ZLPolygonViewDemo
//
//  Created by zhaoliang chen on 2018/11/7.
//  Copyright © 2018 yungj. All rights reserved.
//

#import "ZLPolygonView.h"

#define kCosValue(Angle) cos(M_PI / 180 * (Angle))
#define kSinValue(Angle) sin(M_PI / 180 * (Angle))

@interface ZLPolygonView()

@property(nonatomic,strong)NSMutableArray* arrayOuterPoints;
@property(nonatomic,strong)NSMutableArray* arrayInnerPoints;
@property(nonatomic,strong)NSMutableArray* arrayTextPoint;

@property(nonatomic,assign)CGFloat labelSize;

@end

@implementation ZLPolygonView


- (instancetype)init {
    if (self == [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithLabels:(NSArray<NSString*>*) labels {
    return [self initWithLabels:labels polygons:[NSMutableArray new]];
}

- (instancetype)initWithLabels:(NSArray<NSString*>*)labels polygons:(NSArray<NSNumber*>*)polygons {
    if (self == [self init]) {
        self.arrayLabels = labels;
        self.arrayPolygons = polygons;
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    self.arrayOuterPoints = [NSMutableArray new];
    self.arrayInnerPoints = [NSMutableArray new];
    self.arrayTextPoint = [NSMutableArray new];
    self.innerColor = [UIColor orangeColor];
    self.lineColor = [UIColor grayColor];
    self.dividerNumber = 4;
    self.lineColor = [UIColor grayColor];
    self.lineWidth = 1.f;
    self.innerColor = [UIColor orangeColor];
    self.labelSize = 20.f;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setInnerColor:(UIColor *)innerColor {
    _innerColor = innerColor;
    [self setNeedsDisplay];
}

- (void)setDividerNumber:(NSInteger)dividerNumber {
    _dividerNumber = dividerNumber;
    [self setNeedsDisplay];
}

- (void)setArrayPolygons:(NSArray *)arrayPolygons {
    _arrayPolygons = arrayPolygons;
    [self setNeedsDisplay];
}

- (void)setArrayLabels:(NSArray *)arrayLabels {
    _arrayLabels = arrayLabels;
    [self setNeedsDisplay];
}

- (void)setJsonValue:(NSString*)jsonStr {
    NSArray* array = [self arrayWithJsonString:jsonStr];
    if (array.count >= 3) {
        NSMutableArray* texts = [NSMutableArray new];
        NSMutableArray* values = [NSMutableArray new];
        for (NSDictionary* dic in array) {
            [texts addObject:dic[@"text"]];
            [values addObject:dic[@"value"]];
        }
        self.arrayLabels = texts;
        self.arrayPolygons = values;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.arrayOuterPoints removeAllObjects];
    [self.arrayInnerPoints removeAllObjects];
    [self.arrayTextPoint removeAllObjects];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGFloat innerAngle = 360.f / self.arrayPolygons.count;
    CGFloat radius = MIN(rect.size.width/2, rect.size.height/2) - self.labelSize;
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.height/2);
    
    //画内圈
    for (int i=0; i<self.arrayPolygons.count; i++) {
        CGFloat current = [self.arrayPolygons[i] floatValue];
        if (current > 1) {
            current = 1;
        }
        CGPoint inPoint = CGPointMake(centerPoint.x - (kCosValue(90 - innerAngle * i) * (radius*current)),centerPoint.y - (kSinValue(90 - innerAngle * i) * radius*current));
        [self.arrayInnerPoints addObject:[NSValue valueWithCGPoint:inPoint]];
        if (i==0) {
            CGContextMoveToPoint(context, inPoint.x, inPoint.y);
        } else {
            CGContextAddLineToPoint(context, inPoint.x, inPoint.y);
        }
    }
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, self.innerColor.CGColor);
    CGContextFillPath(context);
    
    //画外圈
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    
    for (int j=0; j<self.dividerNumber; j++) {
        for (int i=0; i<self.arrayPolygons.count; i++) {
            CGPoint outPoint = CGPointMake(centerPoint.x - (kCosValue(90 - innerAngle * i) * (radius*(j+1)*(1.0/self.dividerNumber))),centerPoint.y - (kSinValue(90 - innerAngle * i) * (radius*(j+1)*(1.0/self.dividerNumber))));
            if ((j+1)*(1.0/self.dividerNumber) >= 1) {
                [self.arrayOuterPoints addObject:[NSValue valueWithCGPoint:outPoint]];
                CGFloat x = centerPoint.x - (kCosValue(90 - innerAngle * i) * (radius+self.labelSize/2));
                CGFloat y = centerPoint.y - (kSinValue(90 - innerAngle * i) * (radius+self.labelSize/2));
                CGPoint textPoint = CGPointMake(x,y);
                [self.arrayTextPoint addObject:[NSValue valueWithCGPoint:textPoint]];
            }
            if (i==0) {
                CGContextMoveToPoint(context, outPoint.x, outPoint.y);
            } else {
                CGContextAddLineToPoint(context, outPoint.x, outPoint.y);
            }
        }
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    //画中间线
    for (int i=0; i<self.arrayOuterPoints.count; i++) {
        CGPoint outPoint = [self.arrayOuterPoints[i] CGPointValue];
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
        CGContextAddLineToPoint(context, outPoint.x, outPoint.y);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    UIFont *font = [UIFont boldSystemFontOfSize:10.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    for (int i=0; i<self.arrayTextPoint.count; i++) {
        CGPoint pt = [self.arrayTextPoint[i] CGPointValue];
        CGRect rect = CGRectMake(pt.x-self.labelSize/2, pt.y-self.labelSize/2, self.labelSize, self.labelSize);
        NSString* str1 = @"空";
        if (i<self.arrayLabels.count) {
            str1 = self.arrayLabels[i];
        }
        //获得size
        CGSize strSize = [str1 sizeWithAttributes:attributes];
        CGFloat marginTop = (rect.size.height - strSize.height)/2;
        //垂直居中要自己计算
        CGRect r = CGRectMake(rect.origin.x, rect.origin.y + marginTop,rect.size.width, strSize.height);
        [str1 drawInRect:r withAttributes:attributes];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    //[self showValueWithTouchPoint:touchPoint];
    for (int i=0; i<self.arrayInnerPoints.count; i++) {
        CGPoint point = [self.arrayInnerPoints[i] CGPointValue];
        if (fabs(touchPoint.x - point.x) < 10 && fabs(touchPoint.y - point.y) < 10) {
            if ([_delegate respondsToSelector:@selector(polygonView:onTouchPoint:indexOfPolygon:)]) {
                [_delegate polygonView:self onTouchPoint:point indexOfPolygon:i];
            }
            break;
        }
    }
}

- (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"json解析失败：%@",error.localizedDescription);
        return nil;
    }
    return array;
}

@end
