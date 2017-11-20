//
//  CASLoginViewController.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/16.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASLoginViewController.h"
#import "CASLoginView.h"
#import "CASRootTabBarControllerViewController.h"

typedef NS_ENUM(NSUInteger, LoginStatus) {
    LoginStatusUnKnown,
    LoginStatusSuccess,
    LoginStatusUserNameError,
    LoginStatusPassWordError,
    LoginStatusNetworkError
};
@interface CASLoginViewController ()<UITextFieldDelegate>

@end

@implementation CASLoginViewController

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    [self dealTouchUpInside];
}

- (void)setUpUI {
    UIView *CASLoginV = [[CASLoginView alloc] init];
    CASLoginV.frame = self.view.frame;
    [self.view addSubview:CASLoginV];
}

#pragma mark - dealEvent
- (void)dealTouchUpInside {
    if ([self.view.subviews[0] isMemberOfClass:[CASLoginView class]]) {
        CASLoginView *loginV = self.view.subviews[0];
        loginV.pwdTextF.delegate = self;
        
        typeof(loginV) __weak weakLoginV = loginV;
        [loginV.showOrHidePwdBtn addActionHandler:^(UIButton *btn) {
            btn.selected = !btn.selected;
            if (!btn.selected) {//默认暗文模式
                NSString *tempPwdStr = weakLoginV.pwdTextF.text;
                weakLoginV.pwdTextF.text = @"";
                weakLoginV.pwdTextF.secureTextEntry = YES;
                weakLoginV.pwdTextF.text = tempPwdStr;
            }else {//明文模式
                NSString *tempPwdStr = weakLoginV.pwdTextF.text;
                weakLoginV.pwdTextF.text = @""; // 这句代码可以防止切换的时候光标偏移
                weakLoginV.pwdTextF.secureTextEntry = NO;
                weakLoginV.pwdTextF.text = tempPwdStr;
            }
        }];
        
        [loginV.termsOfServiceBtn addActionHandler:^(UIButton *btn) {
            btn.selected = !btn.selected;
        }];
        
        [loginV.loginBtn addActionHandler:^(UIButton *btn) {
            //验证
            LoginStatus status = [self checkingLoginStatus];
            switch (status) {
                case LoginStatusSuccess: {
                    CASRootTabBarControllerViewController *rootTabBarVC = [[CASRootTabBarControllerViewController alloc] init];
                    [UIApplication sharedApplication].keyWindow.rootViewController = rootTabBarVC;
                }
                    break;
                case LoginStatusUserNameError:
                    
                    break;
                case LoginStatusPassWordError:
                    
                    break;
                case LoginStatusNetworkError:
                    
                    break;
                case LoginStatusUnKnown:
                    
                    break;
                default:
                    break;
            }
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.view.subviews[0] isMemberOfClass:[CASLoginView class]]) {
        CASLoginView *loginV = self.view.subviews[0];
        [loginV.accountTextF resignFirstResponder];
        [loginV.pwdTextF resignFirstResponder];
    }
}

#pragma mark - 私有方法
- (LoginStatus)checkingLoginStatus {
    //需先要判断是否勾选用户协议
    //判断用户名密码
    return LoginStatusSuccess;
}

@end
