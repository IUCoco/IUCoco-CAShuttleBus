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
#import "CASKeychainWrapper.h"
#import "CASKeychainConfiguration.h"

typedef NS_ENUM(NSUInteger, LoginStatus) {
    LoginStatusUnKnown,
    LoginStatusSuccess,
    LoginStatusFailed,
    LoginStatusUserNameError,
    LoginStatusPassWordError,
    LoginStatusNetworkError
};

@interface CASLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, assign, getter=isTermsOfServiceBtnSelected) BOOL termsOfServiceBtnSelected;
@property (nonatomic, strong)NSMutableArray *keychainWrappers;

@end

@implementation CASLoginViewController

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    [self dealAccountAndPwdTextF];
    [self dealTouchUpInside];
}

/**
 * 功能：禁止横屏
 */

- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - setUpUI
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
        self.termsOfServiceBtnSelected = loginV.termsOfServiceBtn.selected;
        
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
            if (btn.selected) {
                self.termsOfServiceBtnSelected = YES;
            }else {
                self.termsOfServiceBtnSelected = NO;
            }
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
                case LoginStatusFailed:
                    
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
    if (!self.isTermsOfServiceBtnSelected) {
        //提示用户没有勾选协议
        [self showTermsOfServiceAlertView];
        return LoginStatusFailed;
    }
    //判断用户名密码
    if ([self.view.subviews[0] isMemberOfClass:[CASLoginView class]]) {
        //先遍历keychain中是否有值，若有值最后一个赋值给accountTextF和pwdTextF
        CASLoginView *loginV = self.view.subviews[0];
        NSString *userAccount = loginV.accountTextF.text;
        NSString *passWord = loginV.pwdTextF.text;
        if ([userAccount isEqualToString:@"0000099512"] && [passWord isEqualToString:@"0000099512"]) {
            //keychain
            if (userAccount.length > 0) {
                CASKeychainWrapper *keychainWrapper = [[CASKeychainWrapper alloc] initWithSevice:kKeychainService account:userAccount accessGroup:kKeychainAccessGroup];
                [keychainWrapper savePassword:passWord];
            }
            
        }
    }
    
    return LoginStatusSuccess;
}

- (void)showTermsOfServiceAlertView {
    
}

/**
 先遍历keychain中是否有值，若有值最后一个赋值给accountTextF和pwdTextF
 */
- (void)dealAccountAndPwdTextF {
    if ([self.view.subviews[0] isMemberOfClass:[CASLoginView class]]) {
        CASLoginView *loginV = self.view.subviews[0];
        NSArray *keychains = [CASKeychainWrapper passwordItemsForService:kKeychainService accessGroup:kKeychainAccessGroup];
        if (keychains != nil && keychains.count != 0) {
            CASKeychainWrapper *keychainWrapper = keychains.lastObject;
            loginV.accountTextF.text = keychainWrapper.account;
            loginV.pwdTextF.text = [keychainWrapper readPassword];
        }
    }
}

@end
