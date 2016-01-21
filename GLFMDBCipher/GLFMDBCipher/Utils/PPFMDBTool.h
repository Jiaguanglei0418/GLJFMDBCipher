//
//  PPFMDBTool.h
//  03-FMDB(掌握)
//
//  Created by jiaguanglei on 15/9/29.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPShop;
@interface PPFMDBTool : NSObject

SingletonH(fmdbTool)

// 查询
+ (NSArray *)shops;

// 修改
+ (void)update:(double)from toShop:(double)to;

// 插入
+ (void)insertShop:(PPShop *)shop;


// 删除
+ (void)deleteShop;

@end
