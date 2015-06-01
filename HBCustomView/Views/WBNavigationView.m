//
//  WBNavigationView.m
//  Picasso
//
//  Created by knight on 15/4/24.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "WBNavigationView.h"

@interface WBNavigationView ()
@property (nonatomic , assign) NSInteger selectedIndex;
@property (nonatomic , assign) NSInteger currentIndex;
@end

@implementation WBNavigationView

- (id) init
{
    if (self = [super init]) {
        _selectedIndex = -1;
        _currentIndex = 0;
        _direction = WBNavHorizon;
        _separateMargin = 0.f;
    }
    return self;
}

- (id) initWithNavgationViewItems:(NSArray *) items
{
    //该方法未测试 慎用
    if (items) {
        if (self = [super init]){
            _selectedIndex = -1;
            _currentIndex = 0;
            _direction = WBNavHorizon;
            _separateMargin = 30.f;
            [self setNavItems:items];
        }
    }
    return self;
}
- (void) setNavItems:(NSArray *)navItems
{
    if (!_navItems)
        _navItems = [[NSArray alloc] initWithArray:navItems ];
    if (_direction == WBNavHorizon) {
        [self createHorizonView:navItems];
    }else if (_direction == WBNavVertical) {
        [self createVerticalView:navItems];
    }
}


- (void)createHorizonView:(NSArray *) navItems
{
    if (!navItems) {
        return;
    }
    CGPoint origin = self.frame.origin;
    CGFloat y = 0.0f;
    CGFloat width= 0.0f;
    int i = 0;
    for (WBNavgationViewItem * item in navItems) {
        item.button.frame = CGRectMake(width, y, item.button.frame.size.width, item.button.frame.size.height);
        item.button.titleLabel.numberOfLines = 2;
        item.button.index = item.button.tag = [navItems indexOfObject:item];
        [item.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        width += item.button.frame.size.width;
        [self addSubview:item.button];
        
        if (i == 0) {
            item.button.buttonState = Selected;
            [item.button setBackgroundImage:item.button.selectedBackgroundImage forState:UIControlStateNormal];
        }
        if (i < [navItems count]-1) {
            width += self.separateMargin;
        }
        [[NSNotificationCenter defaultCenter] addObserver:item.button selector:@selector(changePage:) name:kChangePage object:nil];
        i++;
    }
    self.frame = CGRectMake(origin.x, origin.y, width, self.frame.size.height);
}

- (void)createVerticalView:(NSArray *) navItems
{
    if (!navItems) return;
    CGPoint origin = self.frame.origin;
    CGFloat height = 10.0f;
    int i = 0;
    for (WBNavgationViewItem * item in navItems) {
        item.button.frame = CGRectMake(5, height, item.button.frame.size.width, item.button.frame.size.height);
        item.button.titleLabel.numberOfLines = 2;
        [item.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        height += item.button.frame.size.height;
        [self addSubview:item.button];
        if (i == 0) {
            item.button.buttonState = Selected;
            [item.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        if (i < [navItems count]-1) {
            height += self.separateMargin;
        }
        [[NSNotificationCenter defaultCenter] addObserver:item.button selector:@selector(changePage:) name:kChangePage object:nil];
        i++;
    }
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, height);
}

- (IBAction)buttonClicked:(id)sender
{
    WBNaVItemBtn * btn = nil ;
    if ([sender isKindOfClass:[UIButton class]]){
        btn = (WBNaVItemBtn *) sender;
    }
    if (btn) {
        if (btn.buttonState == Selected) {
            return ;
        }
        self.selectedIndex = btn.index;
        NSMutableDictionary * dic  =  [[NSMutableDictionary  alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%d",self.currentIndex] forKey:kPrevNavItemBtn];
        NSNotification * notification = [[NSNotification alloc] initWithName:kChangePage object:[NSString stringWithFormat:@"%d",self.selectedIndex] userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    [self.delegate transformFrom:self.currentIndex to:self.selectedIndex];
    self.currentIndex = self.selectedIndex;
}

- (void)willRightSwipe:(senderSource) source;
{
    //向右滑 往前翻 self.currentIndex--
    if (self.currentIndex>0) { //大于0才可以往右翻
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%d",self.currentIndex] forKey:kPrevNavItemBtn];
        if (source==WBTransFormViewSource) {
            self.selectedIndex--;
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangePage object:[NSString stringWithFormat:@"%ld",(long)self.selectedIndex] userInfo:dic];
        self.currentIndex = self.selectedIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:kValueChangePage object:[NSString stringWithFormat:@"%ld",self.selectedIndex] userInfo:dic];
    }
}

- (void)willLeftSwipe:(senderSource) source
{
    //向左滑 往后翻 self.currentIndex++
    if (self.currentIndex<[self.navItems count]-1) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%d",self.currentIndex] forKey:kPrevNavItemBtn];
        if (source==WBTransFormViewSource) {
            self.selectedIndex++;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangePage object:[NSString stringWithFormat:@"%d",self.selectedIndex] userInfo:dic];
        self.currentIndex = self.selectedIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:kValueChangePage object:[NSString stringWithFormat:@"%ld",self.selectedIndex] userInfo:dic];
    }
    
}

#pragma mark WBTransformViewDelegate
- (void)leftGestureHandler:(senderSource) source
{
    [self willLeftSwipe:source];
}

-(void)rightGestureHandler:(senderSource) source
{
    [self willRightSwipe:source];
}

@end
