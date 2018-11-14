//
//  ZLPolygonView.h
//  ZLPolygonViewDemo
//
//  Created by zhaoliang chen on 2018/11/7.
//  Copyright © 2018 yungj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZLPolygonView;
@protocol ZLPolygonViewDelegate <NSObject>

- (void)polygonView:(ZLPolygonView *)polygonView onTouchPoint:(CGPoint)point indexOfPolygon:(NSInteger)index;

@end

@interface ZLPolygonView : UIView

@property(nonatomic,strong)UIColor* innerColor;
@property(nonatomic,strong)UIColor* lineColor;      //
@property(nonatomic,assign)CGFloat lineWidth;      //线条粗细       默认1
@property(nonatomic,assign)NSInteger dividerNumber; //分割线的数量    默认4

@property(nonatomic,strong)NSArray<NSNumber*>* arrayPolygons;
@property(nonatomic,strong)NSArray<NSString*>* arrayLabels;

@property(nonatomic,assign)id <ZLPolygonViewDelegate> delegate;

- (instancetype)initWithLabels:(NSArray<NSString*>*)labels;
- (instancetype)initWithLabels:(NSArray<NSString*>*)labels polygons:(NSArray<NSNumber*>*)polygons;

/**
 json格式：
  [
    {
       text:0,
       value:0.3
    },
    {
       text:1,
       value:0.5
    }
  ]
 **/
- (void)setJsonValue:(NSString*)jsonStr;

@end

NS_ASSUME_NONNULL_END
