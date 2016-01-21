//
//  ViewController.m
//  03-FMDB(掌握)
//
//  Created by jiaguanglei on 15/9/29.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "ViewController.h"
#import "PPFMDBTool.h"
#import "PPShop.h"
#import "UIView+Extension.h"

#import "FMEncryptDatabase.h"
typedef NS_ENUM(NSInteger, ViewControllerBtnType) {
    ViewControllerBtnTypeInsert = 10,
    ViewControllerBtnTypeSelect,
    ViewControllerBtnTypeDelete,
    ViewControllerBtnTypeUpdate
};

@interface ViewController ()
//@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    // 1. insert
    [self setupBtnWithTitle:@"insert" backgroundColor:[UIColor redColor] frameY:100 type:ViewControllerBtnTypeInsert action:@selector(insert)];
    // 2. select
    [self setupBtnWithTitle:@"select" backgroundColor:[UIColor greenColor] frameY:200 type:ViewControllerBtnTypeSelect action:@selector(query)];
    // 3. delete
    [self setupBtnWithTitle:@"delete" backgroundColor:[UIColor blueColor] frameY:300 type:ViewControllerBtnTypeDelete action:@selector(delete)];
    // 4. update
    [self setupBtnWithTitle:@"update" backgroundColor:[UIColor yellowColor] frameY:400 type:ViewControllerBtnTypeUpdate action:@selector(update)];

    
    [self setupBtnWithTitle:@"encry" backgroundColor:[UIColor blackColor] frameY:500 type:20 action:@selector(changeKey)];
    
    [FMEncryptDatabase setEncryptKey:@"111111"];
    
}

- (void)changeKey{
    
    [FMEncryptDatabase setEncryptKey:@"22222222"];
    NSLog(@"changekey ---- ");
}

- (UIButton *)setupBtnWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor frameY:(CGFloat)y type:(ViewControllerBtnType)type action:(SEL)selector
{
    UIButton *insert = [UIButton buttonWithType:UIButtonTypeCustom];
    [insert setTitle:title forState:UIControlStateNormal];
    insert.frame = CGRectMake(0, y, 200, 60);
    insert.centerX = self.view.centerX;
    insert.backgroundColor = bgColor;
    insert.tag = type;
    [insert addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insert];
    return insert;
}


#pragma mark -  查询数据
- (void)delete{
    // 删除 价格低于500 的记录
    [PPFMDBTool deleteShop];
    
    // 查询
    [self query];
}

- (void)update
{
//    PPShop *shop = [[PPShop alloc] init];
//    shop.price = 10000000;
//    PPShop *fromShop = [[PPShop alloc] init];
//    fromShop.name = @"iphone -- 0";
    
    [PPFMDBTool update:1 toShop:10000];
    
    [self query];
}

#pragma mark -  查询数据
- (void)query{
    [[PPFMDBTool shops] enumerateObjectsUsingBlock:^(PPShop *shop, NSUInteger idx, BOOL *stop) {
        LogMagenta(@"%@ -- %.lf", shop.name, shop.price);
    }];
}


#pragma mark -  插入数据
- (void)insert{
    for (int i = 0; i < 100; i++){
        PPShop *shop = [[PPShop alloc] init];
        shop.name = [NSString stringWithFormat:@"iphone -- %d",i / 10];
        shop.price = arc4random() % 10;
        
        [PPFMDBTool insertShop:shop];
    }
    LogRed(@"插入数据");
}
@end
