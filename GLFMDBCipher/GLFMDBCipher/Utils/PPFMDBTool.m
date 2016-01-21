//
//  PPFMDBTool.m
//  03-FMDB(掌握)
//
//  Created by jiaguanglei on 15/9/29.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPFMDBTool.h"
#import "PPShop.h"
#import "FMDB.h"
#import "FMEncryptDatabaseQueue.h"
//#import ""

@implementation PPFMDBTool

SingletonM(fmdbTool)

static FMDatabaseQueue *_dbQueue;

/**
 *  创建数据库
 *
 *  @param path        沙盒路径
 *  @param isEncrypted 是否加密
 *
 *  @return 数据库对象
 */
//- (FMDatabaseQueue *)initWithPath:(NSString *)path encrypt:(BOOL)isEncrypted
//{
//    if (self = [super init]) {
//        if (isEncrypted) {
//            _dbQueue = [FMEncryptDatabaseQueue databaseQueueWithPath:path];
//        } else {
//            _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
//        }
//    }
//    
//    return _dbQueue;
//}



/**
 *  1. 创建数据库
 */
+ (void)initialize
{
    // 1. 打开数据库
    _dbQueue = [FMEncryptDatabaseQueue databaseQueueWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject] stringByAppendingPathComponent:@"shop.sqilte"]];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 2. 创建表
        BOOL isSuc = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_shop (id integer PRIMARY KEY autoincrement, name text NOT NULL, price real);"];
        if (isSuc) {
            
            
        }else{
            LogGreen(@"打开数据库 -- 失败");
        }

    }];
}

+ (void)update:(double)from toShop:(double)to
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        /**
         *  2 开启事务 ----  同时执行多个任务
         */
        // 2.1. 开启事务
//        [db executeUpdate:@"begin transaction;"];
        [db  beginTransaction];
        
        // 2.2 回滚事务
        if(1){
//            [db executeUpdate:@"rollback transaction;"];
            [db rollback];
        }
        
        // 2.3. 提交事务
//        [db executeUpdate:@"commit transaction;"];
        [db commit];
        
        
//        [db executeUpdate:@"UPDATE t_shop set price = ? where price = ?;", to, from];
        // 传参数的时候一定要注意 ---
        // 方法一:
        [db executeUpdate:@"update t_shop set price = ?, name = ? where price = ?;", @200000.00, @"jafdafdaafd", @6.0];
        // 方法二:
//        [db executeUpdateWithFormat:@"update t_shop set price = %f where price = %f;", 200000.00, 6.0];
    }];
    
    // 2.4 在以下的代码块中, 可以同时开启多个事务
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdateWithFormat:@"update t_shop set price = %f where price = %f;", 200000.00, 6.0];
        [db executeUpdateWithFormat:@"update t_shop set price = %f where price = %f;", 200000.00, 6.0];
        [db executeUpdateWithFormat:@"update t_shop set price = %f where price = %f;", 200000.00, 6.0];
        
        // 设置手动 回滚 -- 将rollback的地址设置为yes;
        *rollback = YES;
        
    }];
    
    // 类似的操作
//    [[NSArray array] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        // 停止遍历
//        *stop = YES;
//        
//    }];
    
}

/**
 *  3. 插入数据
 *
 */
+ (void)insertShop:(PPShop *)shop
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdateWithFormat:@"INSERT INTO t_shop(name, price) VALUES (%@, %f);", shop.name, shop.price];
    }];
}

/**
 *  4. 查询数据
 */
+ (NSArray *)shops
{
    __block NSMutableArray *shops = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 查询 - 得到结果集
        FMResultSet *set = [db executeQuery:@"SELECT * FROM t_shop;"];
        
        // 不断往下取数据
        while ([set next]) {
            // 获得当前所指向的数据
            PPShop *shop = [[PPShop alloc] init];
            shop.name = [set stringForColumn:@"name"];
            shop.price = [set doubleForColumn:@"price"];
            
            [shops addObject:shop];
        }
    }];
    
    return shops;
}

/**
 *  5. 删除数据
 */
+ (void)deleteShop{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        // 删除 价格低于500 的记录
        [db executeUpdate:@"DELETE FROM t_shop WHERE price < 5000;"];
    }];
}


@end
