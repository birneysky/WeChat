//
//  ChatTableViewController.m
//  WeChat
//
//  Created by birneysky on 16/3/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatViewController.h"
#import "CoreDataHelper.h"
#import "Message.h"
#import "MessageSession+CoreDataProperties.h"
#import "TEBubbleCell.h"
#import "TEBubbleCellInnerLayout.h"

@interface ChatTableViewController ()

@property (nonatomic, strong) NSMutableArray* arraySource;

@property (nonatomic,assign) BOOL autoScrollToBottom;

@end

@implementation ChatTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)dealloc
{

    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    self.frc = nil;
    //[self.frc.managedObjectContext refreshAllObjects];
    NSLog(@"ChatTableViewController dealloc");
    //NSLog(@"context managed object count = %lu",[[self.frc.managedObjectContext registeredObjects] count]);
}

#pragma mark - *** Properties ***
- (NSMutableArray*)arraySource
{
    if (!_arraySource) {
        _arraySource = [[NSMutableArray alloc] initWithCapacity:100];
        for ( int i = 0; i < 8; i++) {
            [_arraySource addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _arraySource;
}

- (ChatViewController*)chatVC
{
    return (ChatViewController*)self.parentViewController;
}

#pragma mark - *** Init View ***
- (void)loadViewIfNeeded
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configureFetch];
//    [self performFetch];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.frc.delegate = self;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(performFetch)
//                                                 name:@"SomethingChanged"
//                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        self.frc.delegate = nil;
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
}

- (void)configureFetch
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
    NSPredicate* predict = [NSPredicate predicateWithFormat:@"sessionID = %lld",self.session.sID];
    [fetchRequest setPredicate:predict];
    //[fetchRequest setFetchBatchSize:100];
    [fetchRequest setFetchOffset:self.session.totalNumOfMessage - 20];
    [fetchRequest setFetchLimit:20];
    CoreDataHelper* helper = [CoreDataHelper defaultHelper];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:helper.backgroundContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.autoScrollToBottom = YES;
}


#pragma makr - *** Helper ***
- (void)setSession:(MessageSession *)session
{
    _session = session;
    [self configureFetch];
    [self performFetch];
}

//- (void) performFetch
//{
//    __weak ChatTableViewController* weakSelf = self;
//    if (self.frc) {
//        [self.frc.managedObjectContext performBlock:^{
//            NSError* error = nil;
//            if (![weakSelf.frc performFetch:&error]) {
//                DebugLog(@"Failed to perform fetch : %@",error);
//            }
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                
//                [weakSelf.tableView reloadData];
//            });
////            NSUInteger count =  [[weakSelf.frc.sections objectAtIndex:0] numberOfObjects];
////            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//             //NSLog(@"context managed object count = %lu",[[weakSelf.frc.managedObjectContext registeredObjects] count]);
//        }];
//    }
//}
#pragma mark - *** KVO ***
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"] && self.autoScrollToBottom) {
        //NSLog(@"change %@",change);
        //NSLog(@"contentSize %@, contentinset %@,",NSStringFromCGSize(self.tableView.contentSize) ,NSStringFromUIEdgeInsets(self.tableView.contentInset));
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 44, self.tableView.contentSize.width, 44) animated:NO];
    }
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];//[self.tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
//    if (!cell) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
//    }
    //cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.frc.fetchedObjects.count) {
        return;
    }
    
    
    if (indexPath.row >= [self.frc.sections.lastObject numberOfObjects]) {
        return;
    }
    
    TEBubbleCell *bulleCell = (TEBubbleCell*)cell;
    Message* message = [self.frc objectAtIndexPath:indexPath];
    //[message layoutModel];
    //cell.textLabel.text  = message.content;
    //[bulleCell setLayoutModel:message.layoutModel];
    [bulleCell setMessage:message];
    
//    Message* message = [self.frc objectAtIndexPath:indexPath];
//    cell.textLabel.text = message.content;
//    NSDateFormatter*  dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString* dateString = [dateFormatter stringFromDate:message.sendTime];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dateString];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.frc.sections.lastObject numberOfObjects]) {
        return 0;
    }
    Message* message = [self.frc objectAtIndexPath:indexPath];
    CGFloat height  = message.layout.cellHeight;
    if(height < 44){
        return 44 + 16;
    }
    return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - *** UIScrollViewDelegate ***
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.autoScrollToBottom = NO;
//    [[self chatVC] setBottomState:LCBottomBarStateNormal];
//    [[self chatVC].textView resignFirstResponder];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    NSArray<NSIndexPath *> * cellArray = [self.tableView indexPathsForVisibleRows];
    NSIndexPath* lastIndexPath =  cellArray.lastObject;
    NSIndexPath* firstIndexPath = cellArray.firstObject;
    
    NSLog(@"firstPath row:%ld,lastPath row:%ld",firstIndexPath.row,lastIndexPath.row);
    NSInteger rowCount = [self.tableView  numberOfRowsInSection:0];
    if ( rowCount - lastIndexPath.row < 5) {
        self.autoScrollToBottom = YES;
    }
    else{
        self.autoScrollToBottom = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

@end
