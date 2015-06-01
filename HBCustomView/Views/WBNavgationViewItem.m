//
//  WBNavgationView.m
//  Picasso
//
//  Created by knight on 15/4/23.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "WBNavgationViewItem.h"

@interface WBNavgationViewItem()
    -(void) setIndex:(NSInteger) index;
@end

@implementation WBNavgationViewItem

- (void) setIndex:(NSInteger)index
{
    _index = index;
}

-(id) initWithButton:(WBNaVItemBtn *)btn
               Image:(UIImage *)img
               index:(NSInteger) index
{
    if (self = [super init]) {
        if (self) {
            _button = btn;
            _img = img;
            [self setIndex:index];
        }
    }
    return self;
}

@end
