//
//  UserHelper.h
//  AccountBook
//
//  Created by caohouhong on 2018/6/20.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHelper : NSObject
+ (BOOL)isLogin;
/* 1-登录 其他-未登录*/
+ (void)setLoginWithString:(NSString *)login;
@end
