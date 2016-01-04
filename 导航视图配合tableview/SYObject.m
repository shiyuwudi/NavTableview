//
//  SYView.m
//  导航视图配合tableview
//
//  Created by apple2 on 15/11/28.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYObject.h"
#import "SYTableView.h"

@interface SYObject ()<UIScrollViewDelegate>

@property (nonatomic,weak)UIButton *currentBtn;
@property (nonatomic,weak)UIScrollView *headNaviView;
@property (nonatomic,weak)UIScrollView *bottomScrollView;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,assign)CGFloat w;
@property (nonatomic,strong)NSMutableArray *btnArr;
@property (nonatomic,weak)UIView *orangeBar;
@property (nonatomic,strong)NSArray *btnWArr;
@property (nonatomic,strong)NSArray *btnXArr;
@property (nonatomic,assign)BOOL isFewTitle;
@property (nonatomic,assign)CGFloat ratio;
@property (nonatomic,assign)CGFloat normalFontSize;
@property (nonatomic,assign)CGFloat selectedFontSize;

@end

@implementation SYObject
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView{
    [self sy_addHeadNaviTitleArray:titleArr toContainerViewWithFrameSetted:containerView headerHeight:44.f topMargin:64.f testColor:NO normalFontSize:15.f selectedFontSize:17.f];
}
-(void)sy_setSelectColor:(UIColor *)color{
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:color forState:UIControlStateSelected];
    }
}
-(void)sy_setNormalColor:(UIColor *)color{
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
-(void)sy_setScrollIndicatorColor:(UIColor *)color{
    _orangeBar.backgroundColor = color;
}
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView headerHeight:(CGFloat)headerHeight topMargin:(CGFloat)topMargin testColor:(BOOL)testColor normalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize{
    _normalFontSize = normalFontSize;
    _selectedFontSize = selectedFontSize;
    _titleArr = titleArr;
    CGRect frame = containerView.frame;
    CGFloat w = frame.size.width;
    _w = w;
    CGFloat h = frame.size.height;
    //控件创建，设置frame
    UIScrollView *headNaviView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topMargin, w, headerHeight)];
    UIScrollView *bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headerHeight+topMargin, w, h - headerHeight)];
    _bottomScrollView = bottomScrollView;
    
    _headNaviView = headNaviView;
    headNaviView.showsHorizontalScrollIndicator = NO;
    headNaviView.showsVerticalScrollIndicator = NO;
    
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.contentSize = CGSizeMake(w * titleArr.count, h - headerHeight);
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.showsVerticalScrollIndicator = NO;
    bottomScrollView.delegate = self;
    
    NSMutableArray *btnArr = [NSMutableArray array];
    CGFloat headScrollViewW = 0;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:selectedFontSize]};
    NSMutableArray *btnWArr = [NSMutableArray array];
    NSMutableArray *btnXArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i ++) {
        //计算按钮宽度
        NSString *btnTitle = titleArr[i];
        CGSize maxSize = CGSizeMake(CGFLOAT_MAX, headerHeight);
        CGFloat btnW = [btnTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
        btnW = btnW + 20;
        [btnWArr addObject:@(btnW)];
        if (i==titleArr.count-1) {
            //多加一个元素防止数组越界崩溃......
            [btnWArr addObject:@(btnW)];
        }
        [btnXArr addObject:@(headScrollViewW)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (testColor) {
            CGFloat g = 255.f/(float)titleArr.count;
            CGFloat f = g*(i+1);
            btn.backgroundColor = [UIColor colorWithRed:0 green:f/255.f blue:0 alpha:1];
        }
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:normalFontSize];
        [btnArr addObject:btn];
        _btnArr = btnArr;
        CGRect btnFrame = CGRectMake(headScrollViewW, 0, btnW, headerHeight);
        btn.frame = btnFrame;
        [headNaviView addSubview:btn];
        [btn addTarget:self action:@selector(naviBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
            _currentBtn = btn;
            btn.titleLabel.font = [UIFont systemFontOfSize:selectedFontSize];
        }
        headScrollViewW += btnW;
    }
    //按钮数量很少的情况
    if (headScrollViewW<_w) {
        _isFewTitle = YES;
        //只能在这里重新布局按钮
        CGFloat bX = 0;
        for (UIButton *btn in _btnArr) {
            //等比例放大宽度即可
            CGFloat ratio = _w / headScrollViewW;
            _ratio = ratio;
            CGRect fr = btn.frame;
            fr.size.width *= ratio;
            fr.origin.x = bX;
            btn.frame = fr;
            bX += fr.size.width;
        }
        headScrollViewW = w;
    }
    headNaviView.contentSize = CGSizeMake(headScrollViewW, headerHeight);
    _btnWArr = btnWArr;
    _btnXArr = btnXArr;
    
    NSMutableArray *tableViewArr = [NSMutableArray array];
    _tableViewArray = tableViewArr;
    for (int i = 0; i < titleArr.count; i ++) {
        UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(i * w, 0, w, h - headerHeight) style:UITableViewStylePlain];
//        SYTableView *tv = [[SYTableView alloc]initWithFrame:CGRectMake(i * w, 0, w, h - headerHeight) style:UITableViewStylePlain];
        [tableViewArr addObject:tv];
        if (testColor) {
            CGFloat g = 255.f/(float)titleArr.count;
            CGFloat f = g*(i+1);
            tv.backgroundColor = [UIColor colorWithRed:0 green:f/255.f blue:0 alpha:1];
        }
        [bottomScrollView addSubview:tv];
    }
    
    UIView *orangeBar = [[UIView alloc]init];
    orangeBar.backgroundColor = [UIColor orangeColor];
    _orangeBar = orangeBar;
    UIButton *btn0 = btnArr[0];
    CGFloat btn0H = btn0.frame.size.height;
    CGFloat btn0W = btn0.frame.size.width;
    orangeBar.frame = CGRectMake(0, 0.95*btn0H, btn0W, 0.05*btn0H);
    
    //添加到父视图
    [headNaviView addSubview:orangeBar];
    [containerView addSubview:headNaviView];
    [containerView addSubview:bottomScrollView];
    
}
-(IBAction)naviBtnClicked:(id)sender{
    _currentBtn.selected = NO;
    _currentBtn = sender;
    _currentBtn.selected = YES;
    
    NSInteger index = [_btnArr indexOfObject:sender];
    CGPoint p = CGPointMake(_w * index, 0);
    [_bottomScrollView  setContentOffset:p animated:YES];

    UIButton *btn = sender;
    //当前按钮居中
    CGFloat centerX = btn.frame.origin.x + 0.5 * btn.frame.size.width;
    CGFloat offX = centerX - _w * 0.5;
    [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    //如果滚多了.....那就滚回去！
    if (offX<=0) {
        offX = 0;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    }
    if (offX+_w>=_headNaviView.contentSize.width) {
        offX = _headNaviView.contentSize.width - _w;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_bottomScrollView) {
        if (_isFewTitle) {
            CGRect frame = _orangeBar.frame;
            CGFloat x = scrollView.contentOffset.x;
            NSInteger index = x / _w;
            CGFloat btnW = [_btnWArr[index] floatValue];
            CGFloat btnW1 = [_btnWArr[index+1] floatValue];
            CGFloat changeW = btnW1 - btnW;
            CGFloat sX = x - index * _w;
            CGFloat rX = sX * btnW / _w;
            CGFloat rRatio = rX / btnW;
            CGFloat btnW2 =btnW + changeW * rRatio;
            CGFloat bbW=0;
            for (int i=0; i<index; i++) {
                CGFloat bW = [_btnWArr[i] floatValue];
                bbW += bW;
            }
            CGFloat realX = bbW + rX;
            frame.origin.x = realX;
            frame.size.width = btnW2;
            //如果按钮较少,按比例放大指示条
            frame.origin.x *= _ratio;
            frame.size.width *= _ratio;
            _orangeBar.frame = frame;
            //调整字体大小
            CGFloat nFontSize = _normalFontSize + (_selectedFontSize - _normalFontSize) * rRatio;
            UIButton *pBtn = _btnArr[index];
            //假按钮，防止数组越界
            [_btnArr addObject:pBtn];
            UIButton *nBtn = _btnArr[index + 1];
            pBtn.titleLabel.font = [UIFont systemFontOfSize:(_selectedFontSize + _normalFontSize) - nFontSize];
            nBtn.titleLabel.font = [UIFont systemFontOfSize:nFontSize];
        }else{
            CGRect frame = _orangeBar.frame;
            CGFloat x = scrollView.contentOffset.x;
            NSInteger index = x / _w;
            CGFloat btnW = [_btnWArr[index] floatValue];
            CGFloat btnW1 = [_btnWArr[index+1] floatValue];
            CGFloat changeW = btnW1 - btnW;
            CGFloat sX = x - index * _w;
            CGFloat rX = sX * btnW / _w;
            CGFloat rRatio = rX / btnW;
            CGFloat btnW2 = btnW + changeW * rRatio;
            CGFloat bbW=0;
            for (int i=0; i<index; i++) {
                CGFloat bW = [_btnWArr[i] floatValue];
                bbW += bW;
            }
            CGFloat realX = bbW + rX;
            frame.origin.x = realX;
            frame.size.width = btnW2;
            _orangeBar.frame = frame;
            //调整字体大小
            CGFloat nFontSize = _normalFontSize + (_selectedFontSize - _normalFontSize) * rRatio;
            UIButton *pBtn = _btnArr[index];
            //假按钮，防止数组越界
            [_btnArr addObject:pBtn];
            UIButton *nBtn = _btnArr[index + 1];
            pBtn.titleLabel.font = [UIFont systemFontOfSize:(_selectedFontSize + _normalFontSize) - nFontSize];
            nBtn.titleLabel.font = [UIFont systemFontOfSize:nFontSize];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_bottomScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger index = x / _w;
        UIButton *btn = [_btnArr objectAtIndex:index];
        [self naviBtnClicked:btn];
        //当前按钮居中
        CGFloat centerX = btn.frame.origin.x + 0.5 * btn.frame.size.width;
        CGFloat offX = centerX - _w * 0.5;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        //如果滚多了.....那就滚回去！
        if (offX<=0) {
            offX = 0;
            [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        }
        if (offX+_w>=_headNaviView.contentSize.width) {
            offX = _headNaviView.contentSize.width - _w;
            [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        }
    }
}

@end
