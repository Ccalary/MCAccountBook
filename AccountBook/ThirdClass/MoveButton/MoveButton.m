//
//  MoveButton.m
//  JingJinSuo
//
//  Created by 曹后红 on 16/6/6.
//  Copyright © 2016年 jingjinsuo. All rights reserved.
//
//  主界面安全保障按钮拖动

#import "MoveButton.h"

@implementation MoveButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dragEnable = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    beginPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    
    if (self.center.y < self.frame.size.height/2)
    {
        self.center = CGPointMake(self.center.x, self.frame.size.height/2) ;
    }else if(self.center.y > ScreenHeight - (TopFullHeight + TabBarHeight + self.frame.size.height/2))
    {
        self.center = CGPointMake(self.center.x, ScreenHeight - (TopFullHeight + TabBarHeight + self.frame.size.height/2));
    }
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGRect rect = self.frame;
    [UIView animateWithDuration:0.5 animations:^{
        if (self.center.x <= ScreenWidth/2) {
            self.center = CGPointMake(rect.size.width/2,self.center.y );
        }else
        {
            self.center = CGPointMake(ScreenWidth -  rect.size.width/2,self.center.y);
        }
}];
    
}

@end
