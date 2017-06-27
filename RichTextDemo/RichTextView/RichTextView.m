//
//  RichTextView.m
//  RichTextDemo
//
//  Created by 杨春至 on 2017/6/27.
//  Copyright © 2017年 com.hofon.www. All rights reserved.
//

#import "RichTextView.h"
#import "RichElementModel.h"
#import "RichTextAttachment.h"
#import "CHReturnObjc.h"

static const CGFloat BASIC_FONT = 20.0f;
@interface RichTextView ()<UITextViewDelegate>
@property (nonatomic,assign) CGFloat keyBoardHeight;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation RichTextView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configSelf];
        [self addObserver];
    }
    return self;
}
- (void)configSelf{
    self.textContainerInset = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.layoutManager.allowsNonContiguousLayout = NO;
    self.delegate = self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self performSelector:@selector(textViewDidChange:) withObject:textView afterDelay:0.1f];
}

- (void)textViewDidChange:(UITextView *)textView {

    CGFloat cursorPosition;
    if (textView.selectedTextRange) {
        cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
    } else {
        cursorPosition = 0;
    }
    CGRect cursorRowFrame = CGRectMake(0, cursorPosition, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
//    CGRect textViewFrame = [self convertRect:cursorRowFrame fromView:textView];
    
//    [self scrollRectToVisible:cursorRowFrame animated:YES];
    NSLog(@"contentSize____%@",NSStringFromCGSize(self.contentSize));
    if (cursorPosition<self.frame.size.height - self.keyBoardHeight ) {
        
    }else{
        self.contentOffset = CGPointMake(0, cursorPosition+self.keyBoardHeight-self.frame.size.height+40);
    }
    [self resetTextStyle];
}

#pragma mark ------插入图片
- (void)inserImageByPath:(NSString *)aPath{
    
    
}
- (void)inserImageByImage:(UIImage *)aImage{
    
    RichTextAttachment *attach;
    RichElementModel *model = [[RichElementModel alloc]init];
    attach = [self creatImageAttributedStringBy:aImage];
    [self.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:attach]atIndex:self.selectedRange.location];
    model.type = Article_Element_Type_Image;
    model.image = attach.image;
    //设置光标位置
    self.selectedRange = NSMakeRange(self.selectedRange.location + 1, self.self.selectedRange.length);
    //设置样式
    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height + model.hegight);
    [self resetTextStyle];
}

#pragma mark================根据传入obj返回对应==NSAttributedString=====================
- (RichTextAttachment *)creatImageAttributedStringBy:(NSObject *)obj{
    RichTextAttachment *attach = [[RichTextAttachment alloc] init];
    if ([obj isKindOfClass:[NSString class]]) {
        
        if ([(id)obj hasPrefix:@"http://"]||[(id)obj hasPrefix:@"https://"]) {
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:(id)obj]];
            attach.image = [[UIImage alloc]initWithData:data];
            attach.url = (NSString *)obj;
        }else{
            attach.image = [UIImage imageNamed:(id)obj];
        }
    }
    else if ([obj isKindOfClass:[NSData class]]){
        attach.image = [UIImage imageWithData:(id)obj];
    }
    else if ([obj isKindOfClass:[UIImage class]]){
        attach.image = (id)obj;
    }
    else{
        return nil;
    }
    CGFloat skwidth = [UIScreen mainScreen].bounds.size.width;
    attach.bounds = CGRectMake(5,0,skwidth-20,attach.image.size.height*(skwidth/attach.image.size.width));
    return attach;
}
#pragma mark 重置text样式
- (void)resetTextStyle {
    //After changing text selection, should reset style.
//    NSRange wholeRange = NSMakeRange(0, self.self.textStorage.length);
//    [self.self.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
//    [self.self.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:BASIC_FONT] range:wholeRange];
}
#pragma mark -- 载入数据源
- (void)loadMainTextViewData{
    [self resetTextStyle];
    for (RichElementModel *model in self.dataSource) {
        if (model.type == Article_Element_Type_Image) {
            RichTextAttachment *attach = [self creatImageAttributedStringBy:model.content];
            attach.url = model.content;
            [self.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:attach]atIndex:model.location];
        }
    }
}


#pragma mark -对storage 转成model数组
- (NSArray *)setDataSourceFromMainTextAttributeStr{
    NSDictionary *templeDict = @{};
    NSInteger perLength = 1;
    
    NSMutableArray *attributeArray = [[NSMutableArray alloc]init];
    //content内容
    NSString *contentStr = @"";
    
    for (NSInteger location = 0; location <self.textStorage.length; location ++ ,perLength ++) {
        NSRange startRange;
        startRange.location = location;
        startRange.length = 1;
        NSDictionary *attriDict = [self.textStorage attributesAtIndex:location effectiveRange:&startRange];
        
        RichElementModel *textModel = [[RichElementModel alloc]init];
        
        if ([attriDict isKindOfClass:NSClassFromString(@"NSAttributeDictionary")]) {
            
            RichElementModel *model = [[RichElementModel alloc]init];
            if ([attriDict.allKeys containsObject:@"NSAttachment"]) {
                if (templeDict != attriDict) {
                    textModel.type = Article_Element_Type_Text;
                    textModel.content = contentStr;
                    textModel.location = location - textModel.content.length;
                    [attributeArray addObject:textModel];
                }
                model.type = Article_Element_Type_Image;
                
                long long Address = (long long)[attriDict valueForKey:@"NSAttachment"];
                RichTextAttachment *attach = (id)[CHReturnObjc getObjcBy:Address];
                model.image = attach.image;
                model.content = attach.url;
                model.length = 1;
                [attributeArray addObject:model];
                contentStr = @"";
                perLength = 0;
                
            }else{
                templeDict = attriDict;
                contentStr =  [contentStr stringByAppendingString:[self.text substringWithRange:NSMakeRange(location, 1)]];
                if (location==self.textStorage.length-1) {
                    textModel.type = Article_Element_Type_Text;
                    textModel.content = contentStr;
                    textModel.location = location - textModel.content.length;
                    [attributeArray addObject:textModel];
                }
            }
        }
    }
    self.dataSource = [attributeArray mutableCopy];
    NSArray *templeArray = [self.dataSource copy];
    NSLog(@"%@",templeArray);
    return templeArray;
}


-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginediting:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endediting:) name:UITextViewTextDidEndEditingNotification object:self];
}
-(void)beginediting:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    self.keyBoardHeight = 400;
    CGFloat duration = [info [@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height + self.keyBoardHeight);
}

-(void)endediting:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height -self.keyBoardHeight);

}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
