//
//  WBTransFormView+animation.m
//  Picasso
//
//  Created by knight on 15/5/6.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "WBTransFormView+animation.h"
#import "WBNaVItemBtn.h"

@implementation WBTransFormView (animation)
- (void) swipeGesture:(UIPanGestureRecognizer *) gestureRecognizer
{
    static NSTimeInterval startTime = 0;
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval interval = currentTime - startTime;
        startTime = currentTime;
        if (interval <= kTimeDuration) {
            self.overSpeed = YES;
            NSLog(@"OVER SPEED");
            return;
        }else self.overSpeed = NO;
        
        if (velocity.x > 0) {
            self.direction = WBDragRight;
            if (self.currentIndex > 0) {
               long result = dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
                if (result==0) {
                    self.isBegin = YES;
                    NSLog(@"STARTING...");
                }else {
                    NSLog(@"%ld thread is waiting...",result);
                }
                #pragma mark - 如果手势滑动需要的效果不是滑动到当前的下一个界面，则需要修改此处
                self.selectedRestoreIndex = self.selectedIndex;
                self.selectedIndex--;
            }
        }else if (velocity.x < 0){
            self.direction = WBDragLeft;
            if (self.currentIndex < [self.contentViews count]-1) {
               long result = dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
                if (result==0) {
                    self.isBegin = YES;
                    NSLog(@"STARTING...");
                }else {
                    NSLog(@"%ld thread is waiting...",result);
                }
                self.selectedRestoreIndex = self.selectedIndex;
                self.selectedIndex++;
            }
        }
    }
    
    if (((self.direction==WBDragRight && self.currentIndex >0)
        || (self.direction == WBDragLeft && self.currentIndex < [self.contentViews count]-1) )){
        if (!self.overSpeed){
            [self showAnimation:gestureRecognizer];
        }
    }
}

- (void)showAnimation:(id)sender
{
     NSLog(@"SHOWING...");
    if (!self.isBegin) {
        //排除手势结束后，重新识别手势没有识别为UIGestureRecognizerStateBegan的情况
        return;
    }
    if (self.contentViews == nil || [self.contentViews count]<1
        || (self.currentIndex < 0 && self.currentIndex > [self.contentViews count]-1)
        || (self.selectedIndex <0 && self.selectedIndex > [self.contentViews count]-1)) {
        return;
    }
    self.currentView = [self.contentViews objectAtIndex:self.currentIndex];
    self.selectedView = [self.contentViews objectAtIndex:self.selectedIndex];
    [self insertSubview:self.selectedView aboveSubview:self.currentView];
    [self bringSubviewToFront:self.leftMaskView];
    [self bringSubviewToFront:self.rightMaskView];
    self.selectedView.hidden = NO;
    self.currentView.hidden = NO;
    if ([sender isKindOfClass:[WBNaVItemBtn class]]) {
        [self willTransition];
        [self transitioning];
        [self didTransition];
    }
    
    UIPanGestureRecognizer * recognizer = nil;
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        recognizer = (UIPanGestureRecognizer *)sender;
    }
    if (recognizer) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            [self willTransition];
        }
        
        if(recognizer.state == UIGestureRecognizerStateChanged){
            [self gestureStateWillChange:recognizer];
            [self gestureStateChanging:recognizer];
            [self gestureStateDidChange:recognizer];
        }
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            [self willTransitionUseGesture:recognizer];
            [self transitioningUserGesture:recognizer];
            [self didTransitionUseGesture:recognizer];
        }
    }
}

- (void)willTransition
{
    static CGFloat startOpacity = 0.5;
    static CGFloat endOpacity = 0.3;
    if (self.currentView.hidden) {
        self.currentView.hidden = NO;
    }
    CGRect frame = self.currentView.frame;
    if (self.direction == WBDragLeft) {
        frame.origin.x += self.frame.size.width;
        self.selectedView.layer.opacity = (1-startOpacity)*(1-frame.origin.x/frame.size.width)+startOpacity;
        self.currentView.layer.opacity = 1-(1-frame.origin.x/frame.size.width)*(1-endOpacity);
    }else if(self.direction==WBDragRight){
        frame.origin.x -= self.frame.size.width;
        self.selectedView.layer.opacity = (1-startOpacity)*(1+frame.origin.x/frame.size.width)+startOpacity;
        self.currentView.layer.opacity = 1-(1+frame.origin.x/frame.size.width)*(1-endOpacity);
    }
    self.selectedView.frame = frame;
}

- (void)gestureStateWillChange:(UIPanGestureRecognizer *) recognizer
{
    //此处空实现，子类可以重写
}

- (void)gestureStateChanging:(UIPanGestureRecognizer *) recognizer
{
    static CGFloat startOpacity = 0.5;
    static CGFloat endOpacity = 0.3;
    CGFloat tranlationX = [recognizer translationInView:recognizer.view].x;
    CGRect selectedImgViewFrame = self.selectedView.frame;
    selectedImgViewFrame.origin.x += tranlationX;
    if (self.direction == WBDragLeft) {
        //随着拖拽两个图层的透明度渐变
        self.selectedView.layer.opacity = (1-startOpacity)*(1-selectedImgViewFrame.origin.x/selectedImgViewFrame.size.width)+startOpacity;
        self.currentView.layer.opacity = 1-(1-selectedImgViewFrame.origin.x/selectedImgViewFrame.size.width)*(1-endOpacity);
        if (self.currentView.layer.opacity < endOpacity) {
            self.currentView.layer.opacity = endOpacity;
        }
    }else if(self.direction==WBDragRight){
        self.selectedView.layer.opacity = (1-startOpacity)*(1+selectedImgViewFrame.origin.x/selectedImgViewFrame.size.width)+startOpacity;
        self.currentView.layer.opacity = 1-(1+selectedImgViewFrame.origin.x/selectedImgViewFrame.size.width)*(1-endOpacity);
        if (self.currentView.layer.opacity < endOpacity) {
            self.currentView.layer.opacity = endOpacity;
        }
    }
    self.selectedView.frame = selectedImgViewFrame;
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)gestureStateDidChange:(UIPanGestureRecognizer *) recognizer
{
    
}

- (void)transitioning
{
    __weak __typeof(self) weakSelf = self;
    self.selectedView.layer.opacity = 0.5;
    [UIView animateWithDuration:kTimeDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.selectedView.frame = weakSelf.currentView.frame;
        weakSelf.selectedView.layer.opacity = 1;
        weakSelf.currentView.layer.opacity = 0.3;
        if (weakSelf.direction == WBDragRight ) {
            [weakSelf.delegate rightGestureHandler:WBNavItemBtnSource];
        }else if (weakSelf.direction == WBDragLeft){
            [weakSelf.delegate leftGestureHandler:WBNavItemBtnSource];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentView.hidden = YES;
            weakSelf.currentIndex = weakSelf.selectedIndex ;
            weakSelf.currentView.layer.opacity = 1.0;
        }
    }];
}

- (void)didTransition
{
    
}

- (void)willTransitionUseGesture:(UIPanGestureRecognizer *) gestureRecognizer
{
    //此处空实现，子类可以重写
    
}

- (void)transitioningUserGesture:(UIPanGestureRecognizer *) gestureRecognizer
{
    CGFloat width = self.selectedView.frame.size.width;
    CGFloat x = 0.0;
    BOOL changed = NO;
    CGRect selectedFrame = self.selectedView.frame;
    if (self.direction == WBDragLeft) {
        changed = selectedFrame.origin.x <= 0.8*width;
        x = width;
    }
    if (self.direction == WBDragRight) {
        changed = fabs(width+selectedFrame.origin.x) >= 0.2*width;
        x = -width;
    }
    if (changed) {
        selectedFrame.origin.x = 0;
    }else
        selectedFrame.origin.x = x;
    __weak __typeof(self) weakSelf = self;
     NSLog(@"BEFORE ANIMATIONING...");
    [self doAnimationWithFrame:selectedFrame changed:changed];
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//         NSLog(@"BEFORE ANIMATIONING BLOCK...");
//        [weakSelf doAnimationWithFrame:selectedFrame changed:changed];
//    });
     NSLog(@"AFTER ANIMATIONING...");
}

- (void)doAnimationWithFrame:(CGRect)selectedFrame changed:(BOOL)changed {
     NSLog(@"ANIMATIONING...");
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:kTimeDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.userInteractionEnabled = NO;
        weakSelf.selectedView.frame = selectedFrame;
        if (changed) {
        }
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.userInteractionEnabled = YES;
            weakSelf.currentView.layer.opacity = 1.0;
            weakSelf.selectedView.layer.opacity = 1.0;
            if (changed) {
                weakSelf.currentView.hidden = YES;
                weakSelf.currentIndex = self.selectedIndex;
                if (weakSelf.direction == WBDragRight) {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rightGestureHandler:)]) {
                        [weakSelf.delegate rightGestureHandler:WBTransFormViewSource];
                    }
                }else if (weakSelf.direction == WBDragLeft){
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(leftGestureHandler:)]) {
                        [weakSelf.delegate leftGestureHandler:WBTransFormViewSource];
                    }
                }
            }else{
                weakSelf.currentView.hidden = NO;
                weakSelf.selectedView.hidden = YES;
                weakSelf.selectedIndex = weakSelf.selectedRestoreIndex;
            }
        }
        weakSelf.isBegin = NO;
         NSLog(@"RELEASE SEMAPHORE...");
        dispatch_semaphore_signal(weakSelf.semaphore);
    }];
}

- (void)didTransitionUseGesture:(UIPanGestureRecognizer *) gestureRecognizer
{
    
}
@end
