//
//  ViewController.m
//  ZLPolygonViewDemo
//
//  Created by zhaoliang chen on 2018/11/7.
//  Copyright © 2018 yungj. All rights reserved.
//

#import "ViewController.h"
#import "ZLPolygonView.h"

@interface ViewController ()

@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)ZLPolygonView* polygonView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.polygonView = [[ZLPolygonView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.polygonView.arrayPolygons = @[@(0.3), @(0.8), @(0.5), @(0.2), @(1.0)];
    [self.view addSubview:self.polygonView];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 350, 200, 40)];
    self.textField.layer.cornerRadius = 20;
    self.textField.placeholder = @"请输入列数";
    [self.view addSubview:self.textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 420, 200, 40);
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onReload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)onReload {
    NSInteger number = [self.textField.text integerValue];
    NSMutableArray* array1 = [NSMutableArray new];
    NSMutableArray* array2 = [NSMutableArray new];
    for (NSInteger i=0; i<number; i++) {
        [array1 addObject:[NSString stringWithFormat:@"%zd",i]];
        [array2 addObject:@((arc4random()%101)/100.0f)];
    }
    self.polygonView.arrayLabels = array1;
    self.polygonView.arrayPolygons = array2;
}

@end
