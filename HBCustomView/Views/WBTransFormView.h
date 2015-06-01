//
//  WBTransFormView.h
//  Picasso
//
//  Created by knight on 15/5/4.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTransformViewDelegate.h"
#define kTimeDuration 0.3
//dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
typedef NS_ENUM(NSInteger, WBDragDirection)
{
    WBDragLeft = 0,
    WBDragRight = 1,
    WBDragUp = 2,
    WBDragDown = 3
};
//typedef NS_ENUM(NSInteger, WBAnimationState) {
//    WBAnimationIn
//};
@interface WBTransFormView : UIView
@property (atomic , strong) UIView * currentView;
@property (atomic , strong) UIView * selectedView;
@property (nonatomic , weak) id<WBTransformViewDelegate> delegate;
@property (nonatomic , strong) NSArray * contentViews;
@property (atomic , assign) NSInteger selectedIndex;
@property (atomic , assign) NSInteger currentIndex;
@property (atomic , assign) WBDragDirection direction;
//@property (nonatomic , strong) UISwipeGestureRecognizer * gestureRecognizer;
@property (nonatomic , strong) UIView * leftMaskView;
@property (nonatomic , strong) UIView * rightMaskView;
@property (atomic , assign) NSInteger selectedRestoreIndex;
//@property (nonatomic , assign) BOOL aniationning;
@property (atomic , strong) UIPanGestureRecognizer  * panGestureRecognizer;
@property (atomic , assign) BOOL overSpeed;
@property (nonatomic , assign) BOOL pinchable;
@property (atomic , assign) BOOL isBegin;
@property (atomic , retain) dispatch_semaphore_t semaphore ;
//@property (nonatomic , assign) WBAnimationState animationState;

- (void)setContentViews:(NSArray *)contentViews;

/**
 *  设置遮罩，在addsubView之后调用
 */
- (void)setMaskViewColor;
/**
 *  隐藏遮罩，在viewWillDisappear中调用
 */
- (void)hiddenMaskView;

@end
