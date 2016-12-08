//
//  CoreDataHelper.m
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "CoreDataHelper.h"

#define STOREFILENAME @"WeChat.sqlite"

static CoreDataHelper* helper;

@interface CoreDataHelper ()

@property (nonatomic,strong) NSPersistentStore* sotre;

@end

@implementation CoreDataHelper

#pragma mark - *** Initializers ***
+ (CoreDataHelper*)defaultHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CoreDataHelper alloc] init];
        [helper loadStore];
    });
    return helper;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (!helper) {
       return  helper = [super allocWithZone:zone];
    }
    return nil;
}

- (void)loadStore
{
    if (_sotre) {
        return;
    }
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    

    _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backgroundContext performBlockAndWait:^{
        [_backgroundContext setPersistentStoreCoordinator:_coordinator];
        [_backgroundContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        //[_backgroundContext setUndoManager:nil];
    }];

//    [_defaultContext setPersistentStoreCoordinator:_coordinator];
//    _defaultContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    //[_defaultContext setParentContext:_backgroundContext];
//    [_defaultContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    
    
    NSDictionary* options = @{NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"},
                             NSMigratePersistentStoresAutomaticallyOption:@YES,
                             NSInferMappingModelAutomaticallyOption:@YES
                             };
    NSError* error;
    _sotre = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:options
                                                error:&error];
}

#pragma mark - *** Path Helpers ***

- (NSString*)appDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSURL*)appStorePath
{
    NSURL* storeURL = [[NSURL fileURLWithPath:[self appDocumentPath]] URLByAppendingPathComponent:@"Stores"];
    
    //如果没有该目录，创建该目录
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storeURL.path ]) {
        NSError* error;
        if ( [fileManager createDirectoryAtURL:storeURL
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:&error]) {
            TRACE(@"成功创建stores目录");
        }
        else{
            DebugLog(@"创建stores目录失败: %@",error);
        }
    }
    
    return storeURL;
}

- (NSURL*) storeURL
{
    return [[self appStorePath] URLByAppendingPathComponent:STOREFILENAME];
}


#pragma mark - *** Saving ***

- (void)saveContext:(NSManagedObjectContext*)context
{
    if ([context hasChanges]) {
        NSError* error;
        if ([context save:&error]) {
           // TRACE(@"保存改变的数据到持久化存储区");
        }
        else{
            DebugLog(@"默认托管上下文保存失败:%@",error);
        }
    }
    else{
        TRACE(@"数据没有变化，不需要保存");
    }
}

- (void)saveDefaultContext
{
    [self saveContext:self.defaultContext];
}

- (void)saveBackgroundContext{
    //[self saveDefaultContext];
    //[_backgroundContext performBlock:^{
        if ([_backgroundContext hasChanges]) {
            NSError* error;
            if ([_backgroundContext save:&error]) {
                // TRACE(@"保存改变的数据到持久化存储区");
            }
            else{
                DebugLog(@"默认托管上下文保存失败:%@",error);
            }
        }
        else{
            TRACE(@"数据没有变化，不需要保存");
        }
    //}];
    //[self saveContext:self.backgroundContext];
}

@end
