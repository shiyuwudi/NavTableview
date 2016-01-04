//
//  ViewController.m
//  导航视图配合tableview
//
//  Created by apple2 on 15/11/28.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "ViewController.h"
#import "SYObject.h"
#import <Contacts/Contacts.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //step 1:
    SYObject *obj;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addressBook];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //step 2:
//    NSArray *arr = @[@"首页",@"购物车11",@"晒单11111",@"商品分类22222222222222",@"个人主页",@"moreTest"];
    NSArray *arr = @[@"首页",@"购物车11"];
    obj = [[SYObject alloc]init];
    [obj sy_addHeadNaviTitleArray:arr toContainerViewWithFrameSetted:self.view];
    
    for (UITableView *tv in obj.tableViewArray) {
        tv.delegate = self;
        tv.dataSource = self;
    }
    
}
-(void)addressBook{
    CNContactStore *cs = [[CNContactStore alloc]init];
    [cs requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"授权成功!");
        }else{
            NSLog(@"授权失败!");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [obj.tableViewArray indexOfObject:tableView]+1;
//    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",[obj.tableViewArray indexOfObject:tableView]+1];
    return cell;
}

@end
