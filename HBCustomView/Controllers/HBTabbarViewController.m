//
//  HBTabbarViewController.m
//  HBCustomView
//
//  Created by knight on 15/4/14.
//  Copyright (c) 2015年 knight. All rights reserved.
//

#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabbarHeight 49
#define kNavHeight 44
#define kStatusBarHeight 20
#define kBarBtnStateChanged @"tabBarButtonStateChanged"
#import "HBTabbarViewController.h"
#import "HBBarButton.h"

@implementation HBTabbarViewController

- (id)initWithViewcontrollers:(NSMutableArray *)controllers animated:(BOOL)animated
{
    if (self = [super init]) {
        self.viewControllers = controllers;
        self.animated = animated;
        self.selectedIndex = 0;
        if ([[self.viewControllers objectAtIndex:self.selectedIndex] isKindOfClass:[UIViewController class]]) {
            self.currentController = [self.viewControllers objectAtIndex:self.selectedIndex];
        }else{
            self.currentController = nil;
        }
        _tabBarBtns = [[NSMutableArray alloc] initWithCapacity:[self.viewControllers count]];
        for (UIViewController * vc in self.viewControllers) {
            [self addChildViewController:vc];
        }
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavHeight, kScreenWidth, kScreenHeight-80-80)];
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)initTopBarWithColor:(UIColor *) color
                           title:(NSString *) title{
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight+kStatusBarHeight)];
    _topBar.backgroundColor = color;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_topBar.center.x-20, _topBar.center.y-10, 40, 20)];
    titleLabel.text = title;
    titleLabel.backgroundColor = color;
    titleLabel.textColor = [UIColor whiteColor];
    [_topBar addSubview:titleLabel];
    [self.view addSubview:_topBar];
}

- (void)initBottomBarWithColor:(UIColor *) color
                         title:(NSString *) title{
    NSInteger index = 0;
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabbarHeight, kScreenWidth, kTabbarHeight)];
    _bottomBar.backgroundColor = color;
    for (UIViewController * controller in self.viewControllers) {
        index = [self.viewControllers indexOfObject:controller];
        NSInteger count = [self.viewControllers count];
        
        HBBarButton * button = [[HBBarButton alloc] initWithFrame:CGRectMake(index*kScreenWidth/count, 0, kScreenWidth/count, kTabbarHeight)];
        HBBarButton * btn = [[HBBarButton alloc] initWithFrame:CGRectMake(index*kScreenWidth/count, 0, kScreenWidth/count, kTabbarHeight)];
        btn.titleLabel.text = title;
        btn.tag = index;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"hehe" forState:UIControlStateNormal];
        if (index==0){
            [btn setImage:[UIImage imageNamed:@"daijia.bundle/images/订单选中.png"] forState:UIControlStateNormal];
            btn.btnState = TabItemSelected;
        }
        else{
            [btn setImage:[UIImage imageNamed:@"daijia.bundle/images/订单.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"daijia.bundle/images/订单选中.png"]forState:UIControlStateHighlighted];
            btn.btnState = TabItemUnSelected;

        }
        [btn addTarget:self action:@selector(transfer2ViewController:) forControlEvents:UIControlEventTouchUpInside];
        [btn setExclusiveTouch:YES];
        [_tabBarBtns addObject:btn];
        [[NSNotificationCenter defaultCenter] addObserver:btn selector:@selector(btnStateDidChanged:) name:kBarBtnStateChanged object:nil];

    }
    for (NSInteger i = 0; i<[_tabBarBtns count]; i++) {
        [_bottomBar addSubview:[_tabBarBtns objectAtIndex:i]];
    }
    [self.view addSubview:_bottomBar];
}




- (IBAction)transfer2ViewController:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        HBBarButton * btn = (HBBarButton *) sender;
        if (btn.btnState == TabItemSelected) return;//如果是已选中的按钮则不跳转
        UIViewController * toVc = (UIViewController *)[self.viewControllers objectAtIndex:btn.tag];
          __typeof (*&self) __weak weakSelf = self;
        [self transitionFromViewController:self.currentController toViewController:toVc duration:3.5 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setValue:[_tabBarBtns objectAtIndex:weakSelf.selectedIndex] forKey:kPreviousBtn];//存放的是之前的btn
            self.selectedIndex = btn.tag;
            self.currentController = toVc;
            NSNotification * notification = [[NSNotification alloc] initWithName:kBarBtnStateChanged object:btn userInfo:userInfo];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
             NSLog(@"transfer to %ld controller!",(long)btn.tag);
        }];
    }
}
- (void) viewDidLoad{
    [super viewDidLoad];
    [self initTopBarWithColor:[UIColor orangeColor] title:self.currentController.tabBarItem.title];
    //默认显示展示第0个viewcontroller的view
    [self.contentView addSubview:self.currentController.view];
    [self.view addSubview:self.contentView];
    [self initBottomBarWithColor:[UIColor whiteColor] title:@"hehe"];
    
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

@end
