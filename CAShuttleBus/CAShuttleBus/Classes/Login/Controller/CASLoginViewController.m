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
#import "CASNetwork.h"
#import <AFNetworking.h>
#import <JCAlertController.h>
#import "CASDriverItem.h"

typedef NS_ENUM(NSUInteger, LoginStatus) {
    LoginStatusUnKnown,
    LoginStatusMiddleSuccess,//条款和网络监测成功 半成功登录状态
    LoginStatusSuccess,
    LoginStatusFailed,
    LoginStatusUserNameError,
    LoginStatusPassWordError,
    LoginStatusUserNameOrPassWordError,
    LoginStatusTermsError,//条款没勾选
    LoginStatusNetworkError
};

@interface CASLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, assign, getter=isTermsOfServiceBtnSelected) BOOL termsOfServiceBtnSelected;
@property (nonatomic, strong) NSMutableArray *keychainWrappers;
//@property (nonatomic, assign) LoginStatus loginStatus;

@end

@implementation CASLoginViewController

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    [self dealAccountAndPwdTextF];
    [self dealTouchUpInside];
    //网络相关
    [CASNetwork openLog];
    //监测登录的状态
    //*****进入程序过快，会有显示网络不可用bug，在这里延时0.5秒判断***
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkingLoginStatus];
    });
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
    //自定义alertViewStyle
    [self customAlertStyle];
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
        
        //登录按钮点击事件
        [loginV.loginBtn addActionHandler:^(UIButton *btn) {
            //网络状态判定+++用户协议勾选状态判定，无网络提醒+return，有网络继续执行
            if ([self checkingLoginStatus] != LoginStatusMiddleSuccess) return;
            
            //**判断用户名密码**
            //先遍历keychain中是否有值，若有值最后一个赋值给accountTextF和pwdTextF
            NSString *userAccount = weakLoginV.accountTextF.text;
            NSString *passWord = weakLoginV.pwdTextF.text;
            //网络请求
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"entity.driver_mobile"] = userAccount;
            parameters[@"entity.driver_password"] = passWord;
            [CASNetwork setAFHTTPSessionManagerProperty:^(AFHTTPSessionManager *sessionManager) {
                //允许无效证书
                sessionManager.securityPolicy.allowInvalidCertificates = YES;
                //不验证域名
                sessionManager.securityPolicy.validatesDomainName = NO;
            }];
            
            [CASNetwork POST:k_DRIVER_LOGIN_URL parameters:parameters success:^(NSDictionary *responseObject, REQUEST_RESULT_STATE resultState) {
                switch (resultState) {
                    case REQUEST_RESULT_STATE_SUCCEED_WITH_DATA: {
                        //self.loginStatus = LoginStatusSuccess;
                        //keychain
                        CASKeychainWrapper *keychainWrapper = [[CASKeychainWrapper alloc] initWithSevice:kKeychainService account:userAccount  accessGroup:kKeychainAccessGroup];
                        [keychainWrapper savePassword:passWord];
                        
                        //driver信息存储
                        CASDriverItem *driver = [CASDriverItem sharedDriver];
                        driver.driver_id = responseObject[@"resultObject"][@"driver_id"];
                        driver.city = responseObject[@"resultObject"][@"city"];
                        driver.driver_sex = responseObject[@"resultObject"][@"driver_sex"];
                        driver.driver_remark = responseObject[@"resultObject"][@"driver_remark"];
                        driver.driver_mobile = responseObject[@"resultObject"][@"driver_mobile"];
                        driver.driver_birthday = responseObject[@"resultObject"][@"driver_birthday"];
                        driver.driver_status = [responseObject[@"resultObject"][@"driver_status"] integerValue];
                        driver.driver_name = responseObject[@"resultObject"][@"driver_name"];
                        driver.driver_account = responseObject[@"resultObject"][@"driver_account"];
                        
                        //登录成功跳转
                        CASRootTabBarControllerViewController *rootTabBarVC = [[CASRootTabBarControllerViewController alloc] init];
                        [UIApplication sharedApplication].keyWindow.rootViewController = rootTabBarVC;
                    }
                        break;
                    case REQUEST_RESULT_STATE_SUCCEED_WITHOUT_DATA: {
                        //self.loginStatus = LoginStatusUserNameOrPassWordError;
                        //用户名或密码错误alert
                        [self showUserNameOrPassWordErrorAlertView];
                    }
                        break;
                    default:
                        break;
                }
                                
            } failure:^(NSError *error) {
//                self.loginStatus = LoginStatusFailed;
                //请求失败alert
            }];
        }];
    }
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

//此方法仅仅判断勾选协议与网络状态
- (LoginStatus)checkingLoginStatus {
    //需先要判断是否勾选用户协议
    if (!self.isTermsOfServiceBtnSelected) {
        //提示用户没有勾选协议
        [self showTermsOfServiceAlertView];
        //        self.loginStatus =  LoginStatusFailed;
        return LoginStatusTermsError;
    }
    
    //*****进入程序过快，会有显示网络不可用bug，在这里延时0.5秒判断***
    //判断网络
    if (![CASNetwork isNetwork]) {
        //提示用户网络不可用
        [self showBadNetworkAlertView];
        //        self.loginStatus = LoginStatusFailed;
        return LoginStatusNetworkError;
    }
    
    return LoginStatusMiddleSuccess;
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

#pragma mark - alertView
- (void)showTermsOfServiceAlertView {
    JCAlertController *alert = [JCAlertController alertWithTitle:nil message:@"请勾选用户协议"];
    [alert addButtonWithTitle:@"知道了" type:JCButtonTypeNormal clicked:^{
        
    }];
    
    [self jc_presentViewController:alert presentCompletion:^{
        
    } dismissCompletion:^{
        
    }];
}

- (void)showBadNetworkAlertView {
    JCAlertController *alert = [JCAlertController alertWithTitle:nil message:@"网络无法连接"];
    [alert addButtonWithTitle:@"知道了" type:JCButtonTypeNormal clicked:^{
        
    }];
    
    [self jc_presentViewController:alert presentCompletion:^{
        
    } dismissCompletion:^{
        
    }];
}

- (void)showUserNameOrPassWordErrorAlertView {
    JCAlertController *alert = [JCAlertController alertWithTitle:nil message:@"用户名或密码错误"];
    [alert addButtonWithTitle:@"知道了" type:JCButtonTypeNormal clicked:^{
        
    }];
    
    [self jc_presentViewController:alert presentCompletion:^{
        
    } dismissCompletion:^{
        
    }];
}

//提示用户勾选允许访问位置和远程push，体验完整信息
- (void)showPushAndLocationAlertView {
    
}

//自定义alertStyle
- (void)customAlertStyle {
    JCAlertStyle *style = [JCAlertStyle shareStyle];
    style.background.blur = YES;
    style.background.alpha = 0.65;
    style.background.canDismiss = YES;
    style.alertView.cornerRadius = 20;
}


@end
