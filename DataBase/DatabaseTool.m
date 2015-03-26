//
//  DataBaseTool.m
//  DataBase
//
//  Created by medicool on 15/3/23.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "DatabaseTool.h"

#ifndef kDatabaseName
#define kDatabaseName @"myDatabase.db"
#endif

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

@implementation DatabaseTool

-(instancetype)sharedTool{
    
    static DatabaseTool *tool = nil;
    dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        tool = [[DatabaseTool alloc]init];
        if (tool) {
            [tool openDb:kDatabaseName];
        }
    });
    return tool;
}

#pragma mark - 打开数据库
- (void)openDb:(NSString *)dbName
{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",directory);
    NSString *filePath = [directory stringByAppendingPathComponent:dbName];
    if (SQLITE_OK ==sqlite3_open(filePath.UTF8String, &_database)) {
        NSLog(@"数据库打开成功!");
    }else{
        NSLog(@"数据库打开失败!");
    }
    
}

#pragma mark - 执行无返回值的sql
- (void)executeNonQuery:(NSString *)sql
{
    char *error;
    if (SQLITE_OK != sqlite3_exec(_database, sql.UTF8String, NULL, NULL, &error)) {
        NSLog(@"执行SQL语句过程中发生错误！错误信息：%s",error);
    }
}

#pragma mark - 执行有返回值的sql
- (NSArray *)executeQuery:(NSString *)sql
{
    NSMutableArray *rows = [NSMutableArray array];
    //评估语法正确性
    sqlite3_stmt *stmt;
    //检查语法正确性
    if (SQLITE_OK == sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL)) {
        //单步执行sql语句
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            int columnCount = sqlite3_column_count(stmt);
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int i = 0; i < columnCount; i++) {
                const char *name= sqlite3_column_name(stmt, i);//取得列名
                const unsigned char *value= sqlite3_column_text(stmt, i);//取得某列的值
                dic[[NSString stringWithUTF8String:name]]=[NSString stringWithUTF8String:(const char *)value];
            }
                [rows addObject:dic];
            }
        }
    //释放句柄
    sqlite3_finalize(stmt);
    return rows;
}
@end
