//
//  WBTransFormView.m
//  Picasso
//
//  Created by knight on 15/5/4.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "WBTransFormView.h"
#import "WBNaVItemBtn.h"

@interface WBTransFormView()
@end

@implementation WBTransFormView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _selectedIndex = 0;
        _currentIndex = 0;
        _selectedRestoreIndex = 0;
        _overSpeed =  NO;
        _pinchable = NO;
        _semaphore = dispatch_semaphore_create(1);
        [self setUp];
    }
    return self;
}

-(IBAction)handlePinch:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded) {
        CGFloat currentScale = self.frame.size.width/self.bounds.size.width;
        CGFloat  newScale = currentScale*sender.scale;
        if (newScale < 1) {
            newScale = 1;
        }
        if (newScale > 1.3) {
            newScale = 1.3;
        }
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        self.transform = transform;
    }
}

- (void) swipeGesture:(UIPanGestureRecognizer *) gestureRecognizer
{
    
}
- (void)setUp
{
    _currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _currentView.contentMode = UIViewContentModeCenter;
    _selectedView.contentMode = UIViewContentModeCenter;
    _currentView.hidden = NO;
    _selectedView.hidden = NO;
    [self addSubview:_selectedView];
    [self addSubview:_currentView];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    _panGestureRecognizer.minimumNumberOfTouches = 1;
//    _panGestureRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)setMaskViewColor
{
    _leftMaskView = [[UIView alloc] initWithFrame:CGRectMake(-self.frame.origin.x, 0, self.frame.origin.x, self.frame.size.height)];
    _rightMaskView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0,self.superview?self.superview.bounds.size.width-self.frame.size.width-self.frame.origin.x:self.frame.size.width,self.frame.size.height)];
    _leftMaskView.layer.borderWidth = 0.0f;
    _rightMaskView.layer.borderWidth = 0.0f;
    [self addSubview:_leftMaskView];
    [self addSubview:_rightMaskView];
    [_leftMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview.mas_left);
        make.right.equalTo(_currentView.mas_left);
        make.height.equalTo(_currentView.mas_height);
        make.top.equalTo(_currentView.mas_top);
    }];
    [_rightMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currentView.mas_right);
        make.right.equalTo(self.superview.mas_right);
        make.height.equalTo(_currentView.mas_height);
        make.top.equalTo(_currentView.mas_top);
    }];
    CGRect leftSplitArea = CGRectMake(0, self.frame.origin.y, _leftMaskView.frame.size.width, _leftMaskView.frame.size.height);
    CGRect rightSplitArea = CGRectMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y, _rightMaskView.frame.size.width, _rightMaskView.frame.size.height);
    _leftMaskView.backgroundColor = [self colorWithRect:leftSplitArea];
    _rightMaskView.backgroundColor = [self colorWithRect:rightSplitArea];
}

- (UIColor *)colorWithRect:(CGRect) area {
    if (self.superview) {
//        CGSize size = self.superview.superview.bounds.size;
//        UIGraphicsBeginImageContext(size);
//        [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        UIImage * img = [UIImage imageNamed:@"Picasso.bundle/loginBackGround.png"];
        UIImage * splitedImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], area)];
        if (splitedImg) {
            UIColor * color = [UIColor colorWithPatternImage:splitedImg];
            return color;
        }else
            return [UIColor clearColor];
    }
    return [UIColor clearColor];
}

- (void)setContentViews:(NSArray *)contentViews
{
    if (!_contentViews) {
        _contentViews = [[NSArray alloc] init];
    }
    if (contentViews) {
        _contentViews = contentViews;
    }
    if (_contentViews && [_contentViews count] > 0)
        [_currentView addSubview:[_contentViews objectAtIndex:0]];
}

- (void)setPinchable:(BOOL)pinchable {
    _pinchable =  pinchable;
    if (self.gestureRecognizers) {
        for (UIGestureRecognizer * recognizer in self.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
                [self removeGestureRecognizer:recognizer];
            }
        }
    }
    if (_pinchable) {
        UIPinchGestureRecognizer * pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
    }
}

- (void)hiddenMaskView
{
    _currentView.hidden = YES;
    _selectedView.hidden = YES;
}

- (void)dealloc {
    self.semaphore = nil;
}

@end
