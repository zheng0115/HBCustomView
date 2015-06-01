//
//  WBDropListView+dataSource.m
//  Picasso
//
//  Created by knight on 15/5/8.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "WBDropListView+dataSource.h"

@implementation WBDropListView (dataSource)

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"droplist";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:224/255.0 green:234/255.0 blue:244/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if (self.dataSouce && [self.dataSouce respondsToSelector:@selector(customDropListCell:WithData:atIndexPath:)]) {
        //自定义cell展示
        return [self.dataSouce customDropListCell:cell WithData:self.data atIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDropListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate &&self.cascadeDelegate&&[self.delegate respondsToSelector:@selector(cascateData:atIndexPath:)]){
        self.cascadeData = [self.delegate cascateData:self.data atIndexPath:indexPath];
    }
    if (self.cascadeData && self.cascadeDelegate
        && [self.cascadeDelegate respondsToSelector:@selector(prepareCasecateDropListWithData:)]) {
        [self prepareCasecateDropListWithData:self.cascadeData];
    }
    if (!self.cascadeDelegate && self.delegate && [self.delegate respondsToSelector:@selector(didSelectedData:atIndexPath:)]) {
        [self.delegate didSelectedData:self.data atIndexPath:indexPath];
    }
}

@end
