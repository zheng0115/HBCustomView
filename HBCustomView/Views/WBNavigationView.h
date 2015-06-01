//
//  WBNavigationView.h
//  Picasso
//
//  Created by knight on 15/4/24.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBNavgationViewItem.h"
#import "WBTransformViewDelegate.h"


typedef NS_ENUM(NSInteger, WBNavViewDirection)
{
    WBNavHorizon = 0,//水平
    WBNavVertical = 1//垂直
};

@protocol NavigationViewDelegate <NSObject>

- (void) transformFrom:(NSInteger) fromIndex
                    to:(NSInteger) toIndex;

@end


@interface WBNavigationView : UIView<WBTransformViewDelegate>
@property (nonatomic , strong , readonly) NSArray * navItems;
//@property (nonatomic , assign) NSInteger selectedIndex;
//@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , assign) WBNavViewDirection direction;
@property (nonatomic , assign) NSInteger separateMargin;
@property (nonatomic , weak) id<NavigationViewDelegate> delegate;

- (id) initWithNavgationViewItems:(NSArray *) items;

- (void) setNavItems:(NSArray *)navItems ;

//将向左划时要做的处理，子类重写
- (void)willLeftSwipe:(senderSource) source;

//将向右划时要做的处理，子类重写
- (void)willRightSwipe:(senderSource) source;

@end
