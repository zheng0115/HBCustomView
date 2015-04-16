//
//  HBBarButton.h
//  HBCustomView
//
//  Created by knight on 15/4/16.
//  Copyright (c) 2015年 knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPreviousBtn @"previousBtn"

typedef enum {
    TabItemUnSelected,
    TabItemSelected
} TabState;
@interface HBBarButton : UIButton
@property (nonatomic, readwrite, assign) TabState btnState;

- (void)btnStateDidChanged:(NSNotification *) noticifation;
@end
