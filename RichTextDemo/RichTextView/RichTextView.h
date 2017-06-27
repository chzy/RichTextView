//
//  RichTextView.h
//  RichTextDemo
//
//  Created by 杨春至 on 2017/6/27.
//  Copyright © 2017年 com.hofon.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichTextView : UITextView

//文件路径插入图片
- (void)inserImageByPath:(NSString *)aPath;
//UIImage插入图片
- (void)inserImageByImage:(UIImage *)aImage;
//返回当前富文本的data
- (NSArray *)setDataSourceFromMainTextAttributeStr;
@end
