//
//  CoreDataTableViewController.m
//  Grocery Dude
//
//  Created by zhangguang on 16/2/16.
//  Copyright © 2016年 com.v2tech. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController () 

@end

@implementation CoreDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.separatorColor = [UIColor redColor];
    
    //self.tableView.separatorEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.frc.sections objectAtIndex:section] numberOfObjects];
}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return [self.frc sectionForSectionIndexTitle:title atIndex:index];
//}
//
//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[[self.frc sections] objectAtIndex:section] name];
//}
//
//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [self.frc sectionIndexTitles];
//}

#pragma mark - *** Fetching ***

- (void) performFetch
{
    __weak CoreDataTableViewController* weakSelf = self;
    if (self.frc) {
        [self.frc.managedObjectContext performBlock:^{
            NSError* error = nil;
            if (![weakSelf.frc performFetch:&error]) {
                DebugLog(@"Failed to perform fetch : %@",error);
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
            });
            //NSLog(@"context managed object count = %lx",[[weakSelf.frc.managedObjectContext registeredObjects] count]);
        }];
    }
}

#pragma mark - *** DELEGATE: NSFetchedResultsController ***

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
    });
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView endUpdates];
    });
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationNone];
                
            });
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationNone];
            });
        }
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];
                
                
            });
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];
                
            });
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (!newIndexPath) {
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }
                else{
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }
            });
        }
            break;
        case NSFetchedResultsChangeMove:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];
            });
        }
            break;
        default:
            break;
    }
}

@end
