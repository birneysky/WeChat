//
//  ChatSessionViewController.m
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ChatSessionViewController.h"
#import "MessageSession.h"
#import "ChatViewController.h"

@implementation ChatSessionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFetch)
                                                 name:@"SomethingChanged"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"session view controller context managed object count = %lu",[[self.frc.managedObjectContext registeredObjects] count]);
}

#pragma mark - *** Configure ***
- (void)configureFetch
{
    CoreDataHelper* dataHelper = [CoreDataHelper defaultHelper];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"MessageSession"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timeToRecvLastMessage" ascending:NO]];
    [request setFetchBatchSize:20];
    //[request setFetchLimit:20];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:dataHelper.backgroundContext sectionNameKeyPath:nil cacheName:@"TEChatSession"];
    //self.frc.delegate = self;
}


#pragma mark - *** Table View ***
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Session Cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.frc.fetchedObjects.count) {
        return;
    }
    MessageSession* session = [self.frc objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%lld",session.senderID];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",session.overviewOfLastMessage];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"show details" sender:indexPath];
}

#pragma mark - *** ***

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChatViewController* chatVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"show details"]) {
        //NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        MessageSession* session = [self.frc objectAtIndexPath:(NSIndexPath*)sender];
        //NSOrderedSet* set = session.messages;
        chatVC.session = session;
    }
}

@end
