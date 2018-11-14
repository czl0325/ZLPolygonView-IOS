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
@property(nonatomic,strong)UILabel* labelJson;

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
    
    self.labelJson = [[UILabel alloc]initWithFrame:CGRectMake(20, 480, 320, 300)];
    self.labelJson.numberOfLines = 0;
    self.labelJson.text = @"json字符串:\n[\n  {\n    text:0,\nvalue:0.3\n}\n  {\n    text:1,\nvalue:0.5\n  }\n]";
    [self.view addSubview:self.labelJson];
}

- (void)onReload {
    NSInteger number = [self.textField.text integerValue];
    //NSMutableArray* array1 = [NSMutableArray new];
    //NSMutableArray* array2 = [NSMutableArray new];
    NSMutableArray* arrayDic = [NSMutableArray new];
    for (NSInteger i=0; i<number; i++) {
        //[array1 addObject:[NSString stringWithFormat:@"%zd",i]];
        //[array2 addObject:@((arc4random()%101)/100.0f)];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%zd",i], @"text",
                             @(0.5+(arc4random()%51)/50.0f), @"value", nil];
        [arrayDic addObject:dic];
    }
    NSString *jsonStr = [self convertToJsonData:arrayDic];
    [self.polygonView setJsonValue:jsonStr];
    //self.polygonView.arrayLabels = array1;
    //self.polygonView.arrayPolygons = array2;
}

- (NSString *)convertToJsonData:(id)object {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error.localizedDescription);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"json解析失败：%@",error.localizedDescription);
        return nil;
    }
    return dic;
}

@end
