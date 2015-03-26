//
//  DataBaseTool.h
//  DataBase
//
//  Created by medicool on 15/3/23.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DatabaseTool : NSObject

#pragma mark - 属性
#pragma mark 数据库引用，使用它进行数据库操作
@property (nonatomic) sqlite3 *database;

#pragma mark - 共有方法

#pragma mark - 单例
-(instancetype)sharedTool;
/**
 *  打开数据库
 *
 *  @param dbName 数据库名称
 */
- (void)openDb:(NSString *)dbName;

/**
 *  执行无返回值的sql
 *
 *  @param sql sql语句
 */
- (void)executeNonQuery:(NSString *)sql;

/**
 *  执行有返回值的sql
 *
 *  @param sql sql语句
 *
 *  @return 查询结果
 */
- (NSArray *)executeQuery:(NSString *)sql;

@end
