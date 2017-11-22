//
//  CASDriverViewController.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/17.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASDriverViewController.h"
#import "CASShuttleBusRouteViewController.h"

#define Y1               50
#define Y2               self.view.frame.size.height - 250
#define Y3               self.view.frame.size.height - 64

@interface CASDriverViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CASShuttleBusRouteViewController *shuttleBusRouteVC;

// 用来显示阴影的view，里面装的是self.shuttleBusRouteVC.view
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipe1;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation CASDriverViewController

#pragma mark - lazyload

- (CASShuttleBusRouteViewController *)shuttleBusRouteVC {
    if (!_shuttleBusRouteVC) {
        _shuttleBusRouteVC = [[CASShuttleBusRouteViewController alloc] init];
        
        
        // -------------- 添加手势 轻扫手势  -----------
        self.swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        self.swipe1.direction = UISwipeGestureRecognizerDirectionDown ; // 设置手势方向
        //    [self.view addGestureRecognizer:swipe];
        
        self.swipe1.delegate = self;
        [_shuttleBusRouteVC.myTab addGestureRecognizer:self.swipe1];
        
        UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipe2.direction = UISwipeGestureRecognizerDirectionUp; // 设置手势方向
        //    [self.view addGestureRecognizer:swipe];
        swipe2.delegate = self;
        [_shuttleBusRouteVC.myTab addGestureRecognizer:swipe2];
    }
    return _shuttleBusRouteVC;
}

-(UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.frame = CGRectMake(0, Y1, self.view.frame.size.width, self.view.frame.size.height);//设置展示初始位置
        //        _shadowView.backgroundColor = [UIColor clearColor];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowRadius = 10;
        _shadowView.layer.shadowOffset = CGSizeMake(5, 5);
        _shadowView.layer.shadowOpacity = 0.8;                       //      不透明度
    }
    return _shadowView;
}

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    //隐藏nav+tabBar
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self addChildViewController:self.shuttleBusRouteVC];
    [self.shadowView addSubview:self.shuttleBusRouteVC.view];
    [self.view addSubview:self.shadowView];
    
    [self.shuttleBusRouteVC didClickTextField:^{//点击了TextField直接上升至最高点
        [UIView animateWithDuration:0.4 animations:^{
            self.shadowView.frame = CGRectMake(0, 50, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        } completion:^(BOOL finished) {
            [self.shuttleBusRouteVC.searchController.searchBar becomeFirstResponder];
        }];
        // 更新offsetY
        self.shuttleBusRouteVC.offsetY = self.shadowView.frame.origin.y;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"-----------  ------------");
    // searchBar收起键盘
    UIButton *cancelBtn = [self.shuttleBusRouteVC.searchController.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    // 代码触发Button的点击事件
    [cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 手势判断
// table可滑动时，swipe默认不再响应 所以要打开
- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    float stopY = 0;     // 停留的位置
    float animateY = 0;  // 做弹性动画的Y
    float margin = 10;   // 动画的幅度
    float offsetY = self.shadowView.frame.origin.y; // 这是上一次Y的位置
    //    NSLog(@"==== === %f == =====",self.vc.table.contentOffset.y);
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        //        NSLog(@"==== down =====");
        
        // 当vc.table滑到头 且是下滑时，让vc.table禁止滑动
        if (self.shuttleBusRouteVC.myTab.contentOffset.y == 0) {
            self.shuttleBusRouteVC.myTab.scrollEnabled = NO;
        }
        
        if (offsetY >= Y1 && offsetY < Y2) {//最上面Y50，最下Y250，即搜索条在secondV的bottom值，最下再向下滑直接最上
            // 停在y2的位置
            stopY = Y2;
        }else if (offsetY >= Y2 ){//最高点继续向下，第一个阶段停留在中部Y3位置
            // 停在y3的位置
            stopY = Y3;
        }else{//滑到最底
            stopY = Y1;
        }
        animateY = stopY + margin;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        //        NSLog(@"==== up =====");
        
        if (offsetY <= Y2) {//中间段位直接上滑动至最上
            // 停在y1的位置
            stopY = Y1;
            // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
            self.shuttleBusRouteVC.myTab.scrollEnabled = YES;
        }else if (offsetY > Y2 && offsetY <= Y3 ){//中间和最下的位置段，直接最下，动画下移也最下
            // 停在y2的位置
            stopY = Y2;
        }else{//中间
            stopY = Y3;
        }
        animateY = stopY - margin;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.shadowView.frame = CGRectMake(0, animateY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        }];
    }];
    // 记录shadowView在第一个视图中的位置
    self.shuttleBusRouteVC.offsetY = stopY;
}

/**
 返回值为NO  swipe不响应手势 table响应手势
 返回值为YES swipe、table也会响应手势, 但是把table的scrollEnabled为No就不会响应table了
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //    NSLog(@"----------- table =  %f ------------",self.vc.table.contentOffset.y);
    // 触摸事件，一响应 就把searchBar的键盘收起来
    // searchBar收起键盘
    UIButton *cancelBtn = [self.shuttleBusRouteVC.searchController.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    // 代码触发Button的点击事件
    [cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    // 当table Enabled且offsetY不为0时，让swipe响应
    if (self.shuttleBusRouteVC.myTab.scrollEnabled == YES && self.shuttleBusRouteVC.myTab.contentOffset.y != 0) {
        return NO;
    }
    if (self.shuttleBusRouteVC.myTab.scrollEnabled == YES) {
        return YES;
    }
    return NO;
}


@end
