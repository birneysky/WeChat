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
#import "ChatExpressionPanel.h"
#import "TEChatMessage.h"
#import "MessageSession+CoreDataProperties.h"
#import "Message+CoreDataProperties.h"
#import "NSString+UUID.h"
#import "TEExpressionNamesManager.h"


@interface ChatViewController () <TEChatExpressionPannelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *expressionBtn;
@property (weak, nonatomic) IBOutlet UIButton *pressTalkBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (strong, nonatomic) IBOutlet ChatTableViewController *chatTVC;

@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) ChatExtraPanel* extraPanel;
@property (nonatomic, strong) ChatExpressionPanel* expressionPanel;

@end
//static UIWindow* _window;

@implementation ChatViewController
{
    //UIWindow* _window;
}
- (void)dealloc
{
    NSLog(@"ChatViewController dealloc");
}

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

- (ChatExpressionPanel*)expressionPanel
{
    if (!_expressionPanel) {
        _expressionPanel = [[ChatExpressionPanel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240)];
    }
    return _expressionPanel;
}

#pragma mark - *** Init ***

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self addChildViewController:self.chatTVC];
    //[self.chatTVC didMoveToParentViewController:self];
    self.expressionPanel.delegate = self;
    [self.view addSubview:self.extraPanel];
    [self.view addSubview:self.expressionPanel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.chatTVC.session = self.session;
}

#pragma mark - *** Target Action ***
- (IBAction)moreBtnClicked:(id)sender {
    
    if (LCBottomBarStateExtraPanel == self.bottomState) {
        [self.textView becomeFirstResponder];
        self.bottomState = LCBottomBarStateInputText;
    }
    else{
        [self.textView resignFirstResponder];
        self.bottomState = LCBottomBarStateExtraPanel;
    }
    
}

- (IBAction)expressionBtnClicked:(UIButton*)sender {
    if (LCBottomBarStateExpressionPanel == self.bottomState) {
        [self.textView becomeFirstResponder];
        self.bottomState = LCBottomBarStateInputText;
    }
    else{
        [self.textView resignFirstResponder];
        self.bottomState = LCBottomBarStateExpressionPanel;
    }
}

- (IBAction)voiceBtnClicked:(UIButton*)sender {
    if (LCBottomBarStateAudioRecord == self.bottomState) {
        [self.textView becomeFirstResponder];
        self.bottomState = LCBottomBarStateInputText;
    }
    else{
        [self.textView resignFirstResponder];
        self.bottomState = LCBottomBarStateAudioRecord;
    }
}
- (IBAction)showBtnClicked:(id)sender {
//    _window = [[UIWindow alloc] initWithFrame:CGRectMake(80, 68, 100, 100)];
//    _window.windowLevel = UIWindowLevelNormal;
//    _window.backgroundColor = [UIColor redColor];
//    _window.hidden = NO;
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
            self.expressionPanel.y = SCREENHEIGHT;
            break;
        case LCBottomBarStateAudioRecord:
            self.bottomViewBottomConstraint.constant = 0 ;
            self.tableViewBottomConstraint.constant = 0;
            self.extraPanel.y = SCREENHEIGHT;
            self.expressionPanel.y = SCREENHEIGHT;
            break;
        case LCBottomBarStateExpressionPanel:
            self.expressionPanel.y = SCREENHEIGHT - self.expressionPanel.height;
            self.bottomViewBottomConstraint.constant = self.expressionPanel.height;
            self.extraPanel.y = SCREENHEIGHT;
            break;
        case LCBottomBarStateExtraPanel:
            self.extraPanel.y = SCREENHEIGHT - self.extraPanel.height;
            self.bottomViewBottomConstraint.constant = self.extraPanel.height;
            self.expressionPanel.y = SCREENHEIGHT;
            break;
        case LCBottomBarStateInputText:
            self.bottomViewBottomConstraint.constant = self.keyboardHeight ;
            self.tableViewBottomConstraint.constant = self.keyboardHeight;
            self.extraPanel.y = SCREENHEIGHT;
            self.expressionPanel.y = SCREENHEIGHT;
            break;
        default:
            break;
    }
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    
    if (LCBottomBarStateAudioRecord == self.bottomState) {
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
        self.pressTalkBtn.hidden = NO;
        self.textView.hidden = YES;

    }
    else{
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        self.pressTalkBtn.hidden = YES;
        self.textView.hidden = NO;

    }
    
    if (LCBottomBarStateExpressionPanel == self.bottomState ) {
        [self.expressionBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [self.expressionBtn setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
    }
    else{
        [self.expressionBtn setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [self.expressionBtn setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
    }
    
}


- (void)insertNewMessage:(NSArray<TEChatMessage*>*)chatMessages
{
    NSManagedObjectContext* context = [[CoreDataHelper defaultHelper] backgroundContext];
    [[[CoreDataHelper defaultHelper] backgroundContext] performBlock:^{
        for (int i =0 ; i < chatMessages.count; i++) {
            TEChatMessage* chatMessage = chatMessages[i];
            Message* message =  [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
            message.mID = chatMessage.messageID;
            message.senderID = 100001;
            message.receiverID = self.session.senderID;
            message.content = [chatMessage xmlString];
            message.sendTime = [NSDate date];
            message.recvTime = message.sendTime;
            message.type = 1;
            message.sessionID = self.session.sID;
            message.senderIsMe = YES;
            self.session.totalNumOfMessage += 1;
            [message layout];
        }
        
        if ([context hasChanges]) {
            NSError* error;
            [context save:&error];
        }
        
    }];
}


- (void)sendMessage
{
    /*
     匹配带方括号的汉字
     [[\u4e00-\u9fa5]+]
     匹配方括号中包含英文和数字
     [[a-zA-Z0-9]+]
     匹配不带http://的网址
     [a-zA-Z0-9\\.\\-]+\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?
     带http的网址
     (http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?
     */
    NSString* pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]|((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression* regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    //    NSString* text = @"http://www.baidu.comfjdkalfjdlsafjldsk[抓狂][调皮][大哭][尴尬][难过][酷],https:www.apple.com,fjdlafjdls https://www.baidu.com www.baidu.com [难过][酷] wolegequfdjlafcjdas ,,,fjdksajfdsa, [抓狂][调皮][大哭]fjdkSafjsda www.baidu.com,[尴尬][难过][酷] developer.apple.com,www.baidu.com http://www.baidu.com http://tool.oschina.net/regex/#";//self.textView.text;
    NSString* sendText = self.textView.text;
    NSArray<NSTextCheckingResult*>* result = [regularExpression matchesInString:sendText options:NSMatchingWithTransparentBounds range:NSMakeRange(0, sendText.length)];
    
    TEChatMessage* chatMessage = [[TEChatMessage alloc] init];
    chatMessage.messageID = [NSString UUID];
    chatMessage.isAutoReply = NO;
    
    if (result.count<=0) {
        TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
        textItem.textContent = sendText;
        [chatMessage addItem:textItem];
    }
    
    __block NSUInteger location = 0;
    [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.range;
        if (range.location > location) {
            //大于 说明range.location前面还有文本没有处理
            NSString* subText = [sendText substringWithRange:NSMakeRange(location, range.location - location)];
            TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
            textItem.textContent = subText;
            [chatMessage addItem:textItem];
        }
        location = NSMaxRange(range);
        NSLog(@"range %@:%@",NSStringFromRange(range),[sendText substringWithRange:range]);
        NSString* subText = [sendText substringWithRange:range];
        if ([subText characterAtIndex:0] == '[') {
            TEExpresssionSubItem* expressionItem = [[TEExpresssionSubItem alloc] initWithType:Face];
            NSString* fileName = [[TEExpressionNamesManager defaultManager] indexOfName:subText];
            assert(fileName);
            expressionItem.fileName = [[TEExpressionNamesManager defaultManager] indexOfName:subText];
            [chatMessage addItem:expressionItem];
        }
        else{
            TEMsgLinkSubItem* linkItem = [[TEMsgLinkSubItem alloc] initWithType:Link];
            linkItem.title = subText;
            linkItem.url = subText;
            [chatMessage addItem:linkItem];
        }
    }];
    
    if(location < sendText.length){
        TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
        textItem.textContent = [sendText substringWithRange:(NSRange){location,sendText.length - location}];
        [chatMessage addItem:textItem];
    }
    
    
    NSAssert(regularExpression,@"正则%@有误",pattern);
    [self insertNewMessage:@[chatMessage]];
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


#pragma mark - *** TextViewDelegate ***
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.textView.text.length > 0) {
            [self sendMessage];
            self.textView.text = nil;
        }
        return NO;
    }
    return YES;
}


#pragma mark - ***TEChatExpressionPannelDelegate ***
- (void)factButtonClickedAtIndex:(NSUInteger)index
{
    TEExpressionNamesManager* manager = [TEExpressionNamesManager defaultManager];
    
    NSString* expresssionName =  [manager nameAtIndex:index];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"[%@]",expresssionName];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
}

- (void)sendButtonClickedInPannnel
{
    if (self.textView.text.length <= 0) {
        return;
    }
    [self sendMessage];
    self.textView.text = nil;
}

@end
