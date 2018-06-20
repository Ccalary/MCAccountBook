
//
//  UserHelper.m
//  AccountBook
//
//  Created by caohouhong on 2018/6/20.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "UserHelper.h"

@implementation UserHelper
+ (BOOL)isLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *login = [defaults objectForKey:@"isLogin"];
    return [@"1" isEqualToString:login];
}

/* 1-登录 其他-未登录*/
+ (void)setLoginWithString:(NSString *)login {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:login forKey:@"isLogin"];
    [defaults synchronize];
}
@end
