//
//  WBTransFormView+animation.h
//  Picasso
//
//  Created by knight on 15/5/6.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "WBTransFormView.h"

@interface WBTransFormView (animation)
//以下方法也可以放到protocol里

- (void)swipeGesture:(UIPanGestureRecognizer *) gestureRecognizer;

- (void)showAnimation:(id)sender;

- (void)gestureStateWillChange:(UIPanGestureRecognizer *) recognizer;

- (void)gestureStateChanging:(UIPanGestureRecognizer *) recognizer;

- (void)gestureStateDidChange:(UIPanGestureRecognizer *) recognizer;

- (void)willTransition;

- (void)transitioning;

- (void)didTransition;

- (void)willTransitionUseGesture:(UIPanGestureRecognizer *) gestureRecognizer;

- (void)transitioningUserGesture:(UIPanGestureRecognizer *) gestureRecognizer;

- (void)didTransitionUseGesture:(UIPanGestureRecognizer *) gestureRecognizer;

@end
