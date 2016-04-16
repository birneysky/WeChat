//
//  CoreDataHelper.h
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject

/*Entity 实体 可以在.xcdatamodeld中创建，可以为其添加属性和关系，每一个实体对应着一个托管对象*/

/*NSManagedObject 对应数据库中的某一条记录，也对应xcdatamodeld中的某一个实体，具有唯一id，一般通过实体对象描述创建
 [NSEntityDescription insertNewObjectForEntityForName: inManagedObjectContext:]
 */
/*NSEntityDescription 实体对象描述，描述了一个实体的基本属性，包括，实体名，类名，属性，关系等，可以通过实体描述
 来实例化托管对象。*/

/*托管对象模型,是实体描述对象的集合,持久化协调器需要知道所有实体对象描述的信息*/
@property (nonatomic,readonly) NSManagedObjectModel* model;

/*UI层托管对象上下文，上下文中包含有若干个托管对象。托管上下文负责管理其中托管对象的生命周期。
 托管上下文可以工作在主线程队列，可以工作在后台线程队列。托管上下文还负责监听托管对象的变化，并将这些改变提交给
 持久化存储协调器，协调器与存储区打交道实现数据同步。托管上下文持有一个持久化协调器的实例*/
@property (nonatomic,readonly) NSManagedObjectContext* defaultContext;

/*持久化存储协调器，是通过托管对象模型进行实例化的，这主要是由于协调器需要和托管上下文还有存储区交互，所以需要知道实体描述信息，才能正确传达信息。还有是因为协调器在初始化时会检测指定路径下的存储区有没有创建，如果没有则进行创建
 协调器中可以包含多个持久化存储区（数据库）
 */
@property (nonatomic,readonly) NSPersistentStoreCoordinator* coordinator;




- (void)saveDefaultContext;

@end
