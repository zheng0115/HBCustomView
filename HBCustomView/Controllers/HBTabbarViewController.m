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

#import "HBTabbarViewController.h"

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
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight-80-80)];
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)initTopBarWithColor:(UIColor *) color
                           title:(NSString *) title{
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
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
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-80, kScreenWidth, 80)];
    _bottomBar.backgroundColor = color;
    for (UIViewController * controller in self.viewControllers) {
        index = [self.viewControllers indexOfObject:controller];
        NSInteger count = [self.viewControllers count];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(index*kScreenWidth/count, 0, kScreenWidth/count, 40)];
        btn.titleLabel.text = title;
        btn.tag = index;
//        btn.set
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"hehe" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(transfer2ViewController:) forControlEvents:UIControlEventTouchUpInside];
        [btn setExclusiveTouch:YES];
        [_tabBarBtns addObject:btn];
    }
    for (NSInteger i = 0; i<[_tabBarBtns count]; i++) {
        [_bottomBar addSubview:[_tabBarBtns objectAtIndex:i]];
    }
    [self.view addSubview:_bottomBar];
}


- (IBAction)transfer2ViewController:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton * btn = (UIButton *) sender;
        
        if (btn.tag == self.selectedIndex) return;//如果是自己则不跳转
        UIViewController * toVc = (UIViewController *)[self.viewControllers objectAtIndex:btn.tag];

        [self transitionFromViewController:self.currentController toViewController:toVc duration:3.5 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            self.selectedIndex = btn.tag;
            self.currentController = toVc;
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
    [self initBottomBarWithColor:[UIColor orangeColor] title:@"hehe"];
    
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

@end
