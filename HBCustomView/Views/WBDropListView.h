//
//  WBDropListView.h
//  Picasso
//
//  Created by knight on 15/5/8.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kListSize 8
#define kDropListCellHeight 20

typedef NS_ENUM(NSInteger, DropListState){
    WBDropListViewOpen = 1,
    WBDropListViewClose = 0
};
typedef NS_ENUM(NSInteger, DropListRelation){
    WBDropListViewShou = 1,
    WBDropListViewWei = 0
};
@protocol WBDropListViewCasecadeDelegate <NSObject>
/**
 *  下拉列表上面的按钮点击事件
 *
 *  @param sender 事件触发者
 */
- (IBAction)buttonClicked:(id)sender;

/**
 *  为级联的下拉列表准备数据
 *
 *  @param data 级联下拉列表可能需要用到的数据
 */
- (void)prepareCasecateDropListWithData:(NSArray *)data;

@end


@protocol WBDropListViewDelegate <NSObject>
@required
-(NSArray *)cascateData:(NSArray *) data
            atIndexPath:(NSIndexPath *) indexPath;
@optional

/**
 *  点击下拉列表某行的后续处理流程在这个里面实现,最末级的下拉列表有用
 *
 *  @param data 可能需要用到的数据
 */
-(void) didSelectedData:(id) data atIndexPath:(NSIndexPath*) indexPath;

@end

@protocol WBDropListViewDataSource <NSObject>

/**
 * 自定义下拉列表要展示的cell样式
 * @param cell:自定义cell时cell参数可以不用
 * @param data:自定义cell样式时需要的数据源
 * @param indexPath:自定义cell所在的indexPath
 * @return UITableViewCell *:返回自定义cell
 **/
@required
- (UITableViewCell *)customDropListCell:(UITableViewCell *) cell
                               WithData:(NSArray *) data
                            atIndexPath:(NSIndexPath *)indexPath;


@end

@interface WBDropListView : UIView<UITableViewDataSource, UITableViewDelegate,WBDropListViewCasecadeDelegate>
@property (nonatomic , strong) NSArray * data;
@property (nonatomic , strong) NSArray * cascadeData;//级联数据
@property (nonatomic , strong) UIButton * topBtn;
@property (nonatomic , strong) UILabel * topLB;
@property (nonatomic , strong) UITableView * listView;
@property (nonatomic , weak) id<WBDropListViewDataSource> dataSouce;
@property (nonatomic , weak) id<WBDropListViewDelegate> delegate;
@property (nonatomic , strong) id<WBDropListViewCasecadeDelegate>  cascadeDelegate;//级联关系时需要用到这个代理

-(instancetype)initWithFrame:(CGRect) frame
                        data:(NSArray *) data title:(NSString*)disTitle;
- (void)closeDropList;
- (NSInteger)computeShowCount;
@end
