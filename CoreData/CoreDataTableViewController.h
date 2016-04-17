//
//  CoreDataTableViewController.h
//  Grocery Dude
//
//  Created by birneysky on 16/2/16.
//  Copyright © 2016年 com.v2tech. All rights reserved.
//


@class NSFetchedResultsController;

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSFetchedResultsController* frc;

/*负责获取数据，并刷新tableview*/
- (void)performFetch;

@end
