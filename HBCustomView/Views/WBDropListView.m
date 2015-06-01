//
//  WBDropListView.m
//  Picasso
//
//  Created by knight on 15/5/8.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "WBDropListView.h"

@interface WBDropListView ()
{
    UIImageView *backGroundView;
    UIImageView *imgView;
}
@property (nonatomic , assign) DropListState listState;
@property (nonatomic , assign) NSInteger dropListHeight;
@property (nonatomic , assign) CGRect oldFrame;
@end

@implementation WBDropListView

-(instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data title:(NSString*)disTitle
{
    if (self = [super initWithFrame:frame]) {
        self.oldFrame = frame;
        self.data = data;
        self.dropListHeight = [self computeShowCount]*kDropListCellHeight;
        CGSize size = frame.size;
        self.topLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width-20, size.height)];
        self.topLB.textAlignment = NSTextAlignmentCenter;
        self.topLB.font = [UIFont systemFontOfSize:19];
        self.topLB.adjustsFontSizeToFitWidth = YES;
        self.topLB.textColor = [UIColor whiteColor];
        self.topLB.text = disTitle;
        [self addSubview:self.topLB];
        self.topBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        //        self.topBtn.backgroundColor = [UIColor blueColor];
        
        [self.topBtn addTarget:self
                        action:@selector(buttonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.topBtn];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width-15, (size.height-6)/2, 10, 6)];
        imgView.image = [UIImage imageNamed:@"Picasso.bundle/arrow_down"];
        [self addSubview:imgView];

        self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, size.height+20, size.width, 100)];
        self.listView.dataSource = self;
        self.listView.tableHeaderView = nil;
        self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.listView.delegate = self;
        self.listView.backgroundColor = [UIColor clearColor];
        self.listView.showsVerticalScrollIndicator = NO;
        backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, size.height+10, size.width, 20)];
        backGroundView.image = [UIImage imageNamed:@"ploy_pop_background.png"];
        //        self.listView.backgroundView = backGroundView;
        self.listState = WBDropListViewClose;
    }
    return self;
}
-(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
    
}
-(void)exChangeIn:(UIView *)changeOutView dur:(CFTimeInterval)dur andWait:(BOOL)wait{
    
    __block BOOL done = wait;
    changeOutView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:dur animations:^{
        changeOutView.transform = CGAffineTransformMakeScale(0, 0);
        changeOutView.alpha = 0.0;
    } completion:^(BOOL finished) {
        done = YES;
    }];
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}

- (IBAction)buttonClicked:(id)sender
{
    switch (self.listState) {
        case WBDropListViewClose:
            [self openDropList];
            break;
        case WBDropListViewOpen:
            [self closeDropList];
            break;
        default:
            break;
    }
}

- (void)openDropList
{
    self.listState = WBDropListViewOpen;
    [self exChangeOut:self.listView dur:0.5];
    [self exChangeOut:backGroundView dur:0.5];

    if (self.listView) {
        if (self.cascadeDelegate) {
            WBDropListView * cascateListView = (WBDropListView *) self.cascadeDelegate;
            if (cascateListView.listView && cascateListView.listView.hidden){
                return;
            }
        }
        CGRect frame = self.listView.frame;
        frame.size.height = self.dropListHeight;
        frame.origin.y = self.topBtn.frame.size.height+20;
        self.listView.frame = frame;
        CGRect frame1 = backGroundView.frame;
        frame1.size.height = self.dropListHeight+15;
        backGroundView.frame = frame1;
        [self addSubview:backGroundView];
        self.frame = CGRectMake(self.oldFrame.origin.x,
                                self.oldFrame.origin.y,
                                frame.size.width,
                                frame.size.height+self.topBtn.frame.size.height+20);
        [self addSubview:self.listView];
        
        [self.listView reloadData];
    }
    imgView.image = [UIImage imageNamed:@"Picasso.bundle/arrow_up"];
}

- (void)closeDropList
{
    //    if (self.dropRelation == WBDropListViewWei) {
    //        if (!self.cascadeDelegate) {
    //            if (!self.listView.hidden) {
    //                self.listState = WBDropListViewOpen;
    //                return;
    //            }
    //        }
    //    }
    
    self.listState = WBDropListViewClose;
    self.frame = self.oldFrame;
    if (self.listView) {
        [self.listView removeFromSuperview];
    }
    [backGroundView removeFromSuperview];
    imgView.image = [UIImage imageNamed:@"Picasso.bundle/arrow_down"];
}

- (NSInteger)computeShowCount
{
    if (!self.data) {
        return 0;
    }
    NSInteger count = [self.data count];
    if (count >= 8) {
        return kListSize;
    }else {
        return kListSize;
    }
}

- (void)prepareCasecateDropListWithData:(NSArray *)data
{
    WBDropListView * listView = nil;
    if ([self.cascadeDelegate isKindOfClass:[WBDropListView class]]) {
        listView = (WBDropListView *)self.cascadeDelegate;
    }
    listView.data = data;
    [listView.listView reloadData];
    if ([listView respondsToSelector:@selector(buttonClicked:)]) {
        [listView openDropList];
    }
}

@end
