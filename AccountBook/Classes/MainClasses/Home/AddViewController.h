//
//  AddViewController.h
//  AccountBook
//
//  Created by caohouhong on 2018/6/19.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^finishBlock)(void);
@interface AddViewController : UIViewController
@property (nonatomic, copy) finishBlock block;
@end
