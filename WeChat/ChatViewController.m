//
//  ViewController.m
//  WeChat
//
//  Created by birneysky on 16/3/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewController.h"
#import "ChatExtraPanel.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (strong, nonatomic) IBOutlet ChatTableViewController *chatTVC;

@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) ChatExtraPanel* extraPanel;

@end

@implementation ChatViewController

#pragma mark - *** Properties ***
- (void)setBottomState:(LCBottomBarState)bottomState
{
    _bottomState = bottomState;
    [self updateBottomViewState];
}

- (ChatExtraPanel*)extraPanel
{
    if (!_extraPanel) {
        _extraPanel = [[ChatExtraPanel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240)];
    }
    return _extraPanel;
}

#pragma mark - *** Init ***

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.chatTVC];
    [self.view addSubview:self.extraPanel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - *** Target Action ***
- (IBAction)moreBtnClicked:(id)sender {
    
    self.bottomState = LCBottomBarStateExtraPanel;
}

- (IBAction)expressionBtnClicked:(id)sender {
}

- (IBAction)voiceBtnClicked:(id)sender {
}
#pragma mark - *** Helper ***
- (void)updateBottomViewState
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:7];
    switch (self.bottomState) {
        case LCBottomBarStateNormal:
            self.bottomViewBottomConstraint.constant = 0 ;
            self.tableViewBottomConstraint.constant = 0;
            self.extraPanel.y = SCREENHEIGHT;
            break;
        case LCBottomBarStateAudioRecord:
            break;
        case LCBottomBarStateExpressionPanel:
            break;
        case LCBottomBarStateExtraPanel:
            self.extraPanel.y = SCREENHEIGHT - self.extraPanel.height;
            self.bottomViewBottomConstraint.constant = self.extraPanel.height;
            break;
        case LCBottomBarStateInputText:
            self.bottomViewBottomConstraint.constant = self.keyboardHeight ;
            self.tableViewBottomConstraint.constant = self.keyboardHeight;
            break;
        default:
            break;
    }
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    
}

#pragma mark - *** Notification Selector ***

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardRect;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    

    self.keyboardHeight = keyboardRect.size.height;
    self.bottomState = LCBottomBarStateInputText;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
}

@end
