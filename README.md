# ZLPolygonView-IOS
类似六芒星的能力值控件，可自由变换点数。


![](https://github.com/czl0325/ZLPolygonView-IOS/blob/master/demo.gif?raw=true)


# 导入

支持cocoapod导入

```
pod 'ZLPolygonView' 
```

# 参数列表

| 可配置参数               | 类型      | 作用                                                    |
|------------------------|-----------|--------------------------------------------------------|
| arrayPolygons          | NSArray<NSNumber*>*      | 每个能力值的数值数组，介于0~1之间      |
| arrayLabels            | NSArray<NSString*>*      | 标签数组，没有默认显示“空”           |
| innerColor      | UIColor*      | 内部填充颜色的色值，默认为orangeColor                                 |
| lineColor            | UIColor*      | 线条的颜色，默认为grayColor     |
| lineWidth            | CGFloat      | 线条宽度，默认为1 |
| dividerNumber			| NSInteger	 |	分割线的数量，默认为4 |

# 代理方法

```Objective-C
//点击某个点的代理
- (void)polygonView:(ZLPolygonView *)polygonView onTouchPoint:(CGPoint)point indexOfPolygon:(NSInteger)index;
```

# 使用方法

```Objective-C
	self.polygonView = [[ZLPolygonView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.polygonView.arrayPolygons = @[@(0.3), @(0.8), @(0.5), @(0.2), @(1.0)];
    [self.view addSubview:self.polygonView];
```