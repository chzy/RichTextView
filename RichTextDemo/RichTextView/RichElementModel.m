//
//  RichElementModel.m
//  RichTextDemo
//
//  Created by 杨春至 on 2017/6/27.
//  Copyright © 2017年 com.hofon.www. All rights reserved.
//

#import "RichElementModel.h"

@implementation RichElementModel

- (void)setContent:(NSString *)content{
    _content = content;
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]} context:nil].size;
    self.hegight = titleSize.height;
}
- (void)setImage:(UIImage *)image{
    _image = image;
    CGRect arect = CGRectMake(5,0,[UIScreen mainScreen].bounds.size.width-20,image.size.height*([UIScreen mainScreen].bounds.size.width/image.size.width));
    
    self.hegight = arect.size.height*1.5;
}
@end
