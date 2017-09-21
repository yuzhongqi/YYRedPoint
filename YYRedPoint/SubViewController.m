//
//  SubViewController.m
//  YYRedPoint
//
//  Created by YuZhongqi on 2017/9/21.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "SubViewController.h"
#import "YYRedPointTool.h"
@interface SubViewController ()
@property(nonatomic,strong) YYRedPointTool *btnRed;

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(cancelRedPoint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    _btnRed = [[YYRedPointTool alloc]initWithView:btn];
    [_btnRed increment];
    
}

-(void)cancelRedPoint{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelPoint" object:nil];
    [_btnRed decrement];
}



@end
