//
//  ViewController.m
//  YYRedPoint
//
//  Created by YuZhongqi on 2017/9/21.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController.h"
#import "YYRedPointTool.h"
@interface ViewController ()
@property(nonatomic,strong) YYRedPointTool *smallRedPoint;
@property(nonatomic,strong) YYRedPointTool *barPoint;
@property (weak, nonatomic)  UIBarButtonItem *barButtonItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupButton];
    [self setupBarItem];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"earth"]];
    imageView.frame = CGRectMake(self.view.frame.size.width/2 - 35, 120, 70, 70);
    [self.view addSubview:imageView];
    //小红点
    _smallRedPoint  = [[YYRedPointTool alloc]initSmallPointWithView:imageView];
    [_smallRedPoint increment];
    [_smallRedPoint moveCircleByX:-50 Y:10]; 
    [self.view addSubview:imageView];
    //数字红点
    _barPoint = [[YYRedPointTool alloc] initWithBarButtonItem: _barButtonItem];
    [_barPoint increment];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelRedPoint) name:@"cancelPoint" object:nil];
    
    [self setUptestBtn];
    
}

-(void)setupBarItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_phone_number"] style:UIBarButtonItemStyleDone target:self action:@selector(incrementRedNum)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.barButtonItem = rightItem;
}

-(void)incrementRedNum{
    [_barPoint increment];

}

-(void)setupButton
{
    UIColor* color = [UIColor colorWithRed:.15 green:.67 blue:.88 alpha:1];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 400, 200, 60)];
    button.center = self.view.center;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Increment" forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(testIncrement) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

-(void)testIncrement
{
    SubViewController *subView = [[SubViewController alloc]init];
    [self.navigationController pushViewController:subView animated:YES];
}


-(void)setUptestBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 500, 200, 40)];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(cancelSmallPoint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)cancelSmallPoint{
    [_smallRedPoint decrement];
}

-(void)cancelRedPoint{
    [_barPoint decrement];
}


@end
