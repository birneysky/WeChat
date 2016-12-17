//
//  XMLReader.m
//

#import "TEChatXMLReader.h"
#import "TESizeAspect.h"

NSString *const kXMLReaderTextNodeKey = @"text";




@interface TEChatXMLReader (Internal)

- (id)initWithError:(NSError **)error;
- (TEChatMessage *)objectWithData:(NSData *)data;

@end


@implementation TEChatXMLReader
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    __autoreleasing  NSError **errorPointer;
    
    NSMutableDictionary* _teDictionary;
    NSMutableArray* _elementStack;
    //NSMutableArray* _messageSubItems;
    TEChatMessage* _chatMessage;
}

#pragma mark -
#pragma mark Public methods
+ (TEChatMessage*)messageForXmlString:(NSString*)string error:(NSError**) error;
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    TEChatXMLReader *reader = [[TEChatXMLReader alloc] initWithError:error];
    
    return [reader objectWithData:data];
}

#pragma mark -
#pragma mark Parsing

- (id)initWithError:(NSError **)error
{
    if (self = [super init])
    {
        errorPointer = error;
    }
    return self;
}

- (TEChatMessage *)objectWithData:(NSData *)data
{
    // Clear out any old data

    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    _teDictionary  =  [[NSMutableDictionary alloc] init];
    _elementStack =  [[NSMutableArray alloc] init];
    //_messageSubItems = [[NSMutableArray alloc] init];
    _chatMessage = [[TEChatMessage alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    
    // Return the stack's root dictionary on success
    if (success)
    {
        return _chatMessage;
    }
   
    return nil;
}




#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:TEChatElement]) {
        _chatMessage.isAutoReply = [attributeDict[TEAutoRelyAttribute] boolValue];
        _chatMessage.messageID = attributeDict[TEMessageIDAttribute];
    }
    else if([elementName isEqualToString:TETextElement] && attributeDict.count > 0){
        TEMsgTextSubItem* textSubItem = [[TEMsgTextSubItem alloc] initWithType:Text];
        textSubItem.textContent = attributeDict[TETextAttribute];
        [_chatMessage addItem:textSubItem];
    }
    else if ([elementName isEqualToString:TELinkElement]){
        TEMsgLinkSubItem* linkSubItem = [[TEMsgLinkSubItem alloc] initWithType:Link];
        linkSubItem.url = attributeDict[TEURLAttribute];
        linkSubItem.title = attributeDict[TEURLAttribute];
        [_chatMessage addItem:linkSubItem];
    }
    else if ([elementName isEqualToString:TEPictureElement]){
        TEMsgImageSubItem* pictureSubItem = [[TEMsgImageSubItem alloc] initWithType:Image];
        NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TEImages"];
        NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",attributeDict[TEUUIDAttribute],@"thumbnail"];
        NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];
        pictureSubItem.fileName = thumbnailImgPath;//attributeDict[TEUUIDAttribute];
        CGFloat width = [attributeDict[TEWidhtAttribute] floatValue];
        CGFloat height = [attributeDict[TEHeightAttribute] floatValue];
        aspectSizeInContainer(&width, &height, CGSizeMake(40, 40), CGSizeMake(200, 200));
        pictureSubItem.imagePosition = CGRectMake(0, 0, width, height);
        [_chatMessage addItem:pictureSubItem];
    }
    else if([elementName isEqualToString:TESysFaceElement]){
        TEExpresssionSubItem* faceItem = [[TEExpresssionSubItem alloc] initWithType:Face];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
        NSString* itemName = [NSString stringWithFormat:@"Expression_%@",attributeDict[TEFileNameAttribute]];
        //NSString* imageName = [path stringByAppendingPathComponent:itemName];
        //NSString* imagePath = [[NSBundle mainBundle] pathForResource:itemName ofType:@".png"];
        faceItem.fileName = itemName;
        faceItem.imagePosition = CGRectMake(0, 0, 20, 20);
        [_chatMessage addItem:faceItem];
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    // Set the text property
    if ([textInProgress length] > 0)
    {
        [dictInProgress setObject:textInProgress forKey:kXMLReaderTextNodeKey];

        // Reset the text
        
        textInProgress = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [dictionaryStack removeLastObject];
    [_elementStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser's error object
    *errorPointer = parseError;
}

@end
