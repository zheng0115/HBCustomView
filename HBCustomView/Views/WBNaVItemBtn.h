//
//  WBNaVItemBtn.h
//  Picasso
//
//  Created by knight on 15/4/24.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kChangePage @"changepagebybutton"
#define kValueChangePage @"kValueChangePage"
#define kPrevNavItemBtn @"prevNavItemBtn"

typedef NS_ENUM(NSInteger, BtnState) {
    UnSelected = 0,
    Selected =1 ,
    
};

@interface WBNaVItemBtn : UIButton
@property (nonatomic , assign) BtnState buttonState;
@property (nonatomic , assign) NSInteger index;
@property (nonatomic , strong) UIImage * normalBackgroundImage;
@property (nonatomic , strong) UIImage * selectedBackgroundImage;

- (void)changePage:(NSNotification *) notification;

@end
