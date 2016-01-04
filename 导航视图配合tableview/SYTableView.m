//
//  SYTableView.m
//  导航视图配合tableview
//
//  Created by apple2 on 15/11/28.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYTableView.h"

@implementation SYTableView

-(void)reloadData{
    [super reloadData];
    if ([self numberOfRowsInSection:0]==0) {
        self.backgroundView = [self bgView];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}
-(UIView *)bgView{
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beauty"]];
    return bgView;
}

@end
