//
//  RichElementModel.h
//  RichTextDemo
//
//  Created by 杨春至 on 2017/6/27.
//  Copyright © 2017年 com.hofon.www. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef enum{
    //文字
    Article_Element_Type_Text ,
    //图片
    Article_Element_Type_Image,
    //空格
    Article_Element_Type_Gap,
    
}ArticleElementType;

@interface RichElementModel : NSObject

@property (nonatomic,assign) ArticleElementType type;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,assign) NSInteger length;

@property (nonatomic,assign) CGFloat hegight;

@property (nonatomic,assign) NSInteger location;

@end
