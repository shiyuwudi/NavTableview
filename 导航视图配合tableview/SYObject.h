//
//  SYObject.h
//  导航视图配合tableview
//
//  Created by apple2 on 15/11/28.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SYObject : NSObject
/**
 ****个性版||创建之后要保存为strong属性或者成员变量!表视图用tableViewArray属性访问****
 */
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView headerHeight:(CGFloat)headerHeight topMargin:(CGFloat)topMargin testColor:(BOOL)testColor normalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize;
/**
 ****精简版||创建之后要保存为strong属性或者成员变量!表视图用tableViewArray属性访问****
 */
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView;
/**
 设置当前按钮的颜色，默认是橙色
 */
-(void)sy_setSelectColor:(UIColor *)color;
/**
 设置非当前按钮的颜色，默认是灰色
 */
-(void)sy_setNormalColor:(UIColor *)color;
/**
 设置提示条的颜色，默认是橙色
 */
-(void)sy_setScrollIndicatorColor:(UIColor *)color;

@property(nonatomic,strong,readonly)NSMutableArray *tableViewArray;

@end
