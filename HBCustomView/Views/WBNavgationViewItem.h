//
//  WBNavgationView.h
//  Picasso
//
//  Created by knight on 15/4/23.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBNaVItemBtn.h"

@interface WBNavgationViewItem : NSObject
@property (nonatomic , strong) WBNaVItemBtn * button;
@property (nonatomic , strong) UIImage * img;
@property (nonatomic , assign) NSInteger index;

- (id) initWithButton:(WBNaVItemBtn *) btn
                Image:(UIImage *) img
                index:(NSInteger) index;
@end
