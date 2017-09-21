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
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, 300, 40)];
    btn.backgroundColor = [UIColor colorWithRed:.15 green:.67 blue:.88 alpha:1];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"减少一次上个界面的消息数" forState:UIControlStateNormal];

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
