//
//  UIButton+Block.h
//  docotor
//
//  Created by 杨春至 on 16/7/20.
//  Copyright © 2016年 com.hofon.www. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock)();
@interface UIButton (Block)
//@property (nonatomic,copy,readonly)ActionBlock block;
-(void)handleClickEvent:(UIControlEvents)aEvent withClickBlick:(ActionBlock)buttonClickEvent;
//block
- (void)setBlock:(ActionBlock)block;
@end
