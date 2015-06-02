//
//  HBTabbarViewController.h
//  HBCustomView
//
//  Created by knight on 15/4/14.
//  Copyright (c) 2015年 knight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HBTabbarViewController : UIViewController
{
    NSMutableArray * _tabBarBtns;
    UIView * _topBar;
    UIView * _bottomBar;
    UILabel * _titleLabel;
}
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIBarButtonItem * barBtnItem;
@property (nonatomic, strong) NSMutableArray * viewControllers;
@property (nonatomic, strong) UIViewController * currentController;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong) UIView * contentView;
- (id) initWithViewcontrollers:(NSMutableArray *) controllers
                      animated:(BOOL) animated;


@end
