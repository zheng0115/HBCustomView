//
//  WBNaVItemBtn.m
//  Picasso
//
//  Created by knight on 15/4/24.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "WBNaVItemBtn.h"

@implementation WBNaVItemBtn


- (void)changePage:(NSNotification *) notification
{
    if (notification && [kChangePage isEqualToString:notification.name]) {
        NSDictionary * userInfo = notification.userInfo;
        NSInteger prevIndex = [[userInfo objectForKey:kPrevNavItemBtn] integerValue];
        NSInteger currentIndex = [notification.object integerValue];
        if (self.index == prevIndex) {
            self.buttonState = UnSelected;
            [self setBackgroundImage:self.normalBackgroundImage forState:UIControlStateNormal];
//            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else if (self.index == currentIndex){
            self.buttonState = Selected;
            [self setBackgroundImage:self.selectedBackgroundImage forState:UIControlStateNormal];
//            [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
    }
}

@end
