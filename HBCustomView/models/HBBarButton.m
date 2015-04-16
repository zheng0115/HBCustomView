//
//  HBBarButton.m
//  HBCustomView
//
//  Created by knight on 15/4/16.
//  Copyright (c) 2015年 knight. All rights reserved.
//

#import "HBBarButton.h"

@implementation HBBarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)btnStateDidChanged:(NSNotification *) noticifation{
    NSLog(@"haha");
    HBBarButton * senderBtn = nil ;
    NSDictionary * userinfos = noticifation.userInfo;
    if ([noticifation.object isKindOfClass:[HBBarButton class]]) {
        senderBtn = (HBBarButton *) noticifation.object;
    }
    if (senderBtn) {
        //如果是发送通知的button和接收通知的button是同一个按钮，则改变选中状态，展现对应的样式
        if (senderBtn.tag==self.tag) {
            senderBtn.btnState = TabItemSelected;
            [senderBtn setImage:[UIImage imageNamed:@"daijia.bundle/images/订单选中.png"] forState:UIControlStateNormal];
        }else{
            id value = [userinfos objectForKey:kPreviousBtn];
            HBBarButton * prevBtn = nil;
            if (value) {
                prevBtn =  (HBBarButton *) value;
                [prevBtn setImage:[UIImage imageNamed:@"daijia.bundle/images/订单.png"] forState:UIControlStateNormal];
                prevBtn.btnState = TabItemUnSelected;//置为未选中状态
            }
        }
    }
}

@end
