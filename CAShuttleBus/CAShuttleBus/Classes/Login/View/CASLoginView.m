//
//  CASLoginView.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/16.
//  Copyright © 2017年 zjairchina. All rights reserved.
//


#import "CASLoginView.h"
#import "CASLoginViewController.h"

@interface CASLoginView ()

@property (nonatomic, strong) UIImageView *headPortraitImageView;
@property (nonatomic, strong) UIImageView *accountImageV;
@property (nonatomic, strong) UIImageView *pwdImageV;
@end

@implementation CASLoginView


#pragma mark - UI

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor orangeColor];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self setUpHeadPortraitView];
    [self setUpLoginMiddleView];
    [self setUpTermsOfServiceView];
}

//设置头像
- (void)setUpHeadPortraitView {
    UIImage *originImage = [UIImage imageNamed:@"login_head_portrait"];
    UIImage *headPortraitImage = [UIImage imageWithRoundCut:originImage
                                               imageContext:originImage.size];
    UIImageView *headPortraitImageView = [[UIImageView alloc] initWithImage:headPortraitImage];
    [self addSubview:headPortraitImageView];
    self.headPortraitImageView = headPortraitImageView;
    [self.headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(85);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70);
    }];
}

//设置账号、密码、登录按钮
- (void)setUpLoginMiddleView {
//账号模块
    UIImage *accountImage = [UIImage imageNamed:@"login_user"];
    UIImageView *accountImageV = [[UIImageView alloc]initWithImage:accountImage];
    [self addSubview:accountImageV];
    self.accountImageV = accountImageV;
    [accountImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPortraitImageView.mas_bottom).offset(75);
        make.left.equalTo(self.mas_left).offset(25);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    
    //账号输入框
    UITextField *accountTextF = [[UITextField alloc] init];
    accountTextF.textColor = CASARGBColor(1.0, 253, 255, 62);
    accountTextF.font = [UIFont systemFontOfSize:18];
    accountTextF.textColor = [UIColor blackColor];
    accountTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextF.keyboardType = UIKeyboardTypeNumberPad;
    accountTextF.placeholder = @"请输入员工号";
    [self addSubview:accountTextF];
    self.accountTextF = accountTextF;
    [accountTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountImageV.mas_top);
        make.left.equalTo(self.accountImageV.mas_right).offset(50);
        make.bottom.equalTo(self.accountImageV.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-51);
        
    }];
    //分割线
    UIView *accountSplitLine = [[UIView alloc] init];
    accountSplitLine.backgroundColor = [UIColor grayColor];
    accountSplitLine.alpha = 0.5;
    [self addSubview:accountSplitLine];
    [accountSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountImageV.mas_bottom).offset(12);
        make.left.equalTo(self.accountImageV.mas_left);
        make.right.equalTo(self.mas_right).offset(- 25);
        make.height.mas_equalTo(1.0);
    }];
    
//密码模块
    UIImage *pwdImage = [UIImage imageNamed:@"login_password"];
    UIImageView *pwdImageV = [[UIImageView alloc]initWithImage:pwdImage];
    pwdImageV.alpha = 0.7;
    self.pwdImageV = pwdImageV;
    [self addSubview:pwdImageV];
    [pwdImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountSplitLine.mas_bottom).offset(30);
        make.left.equalTo(self.accountImageV.mas_left);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    //密码输入框
    UITextField *pwdTextF = [[UITextField alloc] init];
    pwdTextF.textColor = CASARGBColor(1.0, 253, 255, 62);
    pwdTextF.font = [UIFont systemFontOfSize:18];
    pwdTextF.textColor = [UIColor blackColor];
    pwdTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTextF.returnKeyType = UIReturnKeyDone;
    pwdTextF.secureTextEntry = YES;
    pwdTextF.placeholder = @"请输入登录密码";
    [self addSubview:pwdTextF];
    self.pwdTextF = pwdTextF;
    [pwdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdImageV.mas_top);
        make.left.equalTo(self.pwdImageV.mas_right).offset(50);
        make.right.equalTo(self.accountTextF.mas_right);
    }];
    
    //眼睛（显示与不显示密码）
    UIButton *showOrHidePwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showOrHidePwdBtn setImage:[UIImage imageNamed:@"login_close_eye"] forState:UIControlStateNormal];
    [showOrHidePwdBtn setImage:[UIImage imageNamed:@"login_open_eye"] forState:UIControlStateSelected];
    showOrHidePwdBtn.selected = NO;
    [self addSubview:showOrHidePwdBtn];
    self.showOrHidePwdBtn = showOrHidePwdBtn;
    [showOrHidePwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdImageV.mas_top).offset(5);
        make.bottom.equalTo(self.pwdImageV.mas_bottom).offset(-5);
        make.right.equalTo(accountSplitLine.mas_right);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(16);
        
    }];
    
    //分割线
    UIView *pwdSplitLine = [[UIView alloc] init];
    pwdSplitLine.backgroundColor = [UIColor grayColor];
    pwdSplitLine.alpha = 0.5;
    [self addSubview:pwdSplitLine];
    [pwdSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdImageV.mas_bottom).offset(12);
        make.left.equalTo(self.accountImageV.mas_left);
        make.right.equalTo(self.mas_right).offset(- 25);
        make.height.mas_equalTo(1.0);
    }];
    

//登录模块
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.textColor = [UIColor whiteColor];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn setBackgroundColor:CASARGBColor(1,62, 142, 226)];
    loginBtn.layer.cornerRadius = 5.0;
    [self addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdSplitLine.mas_bottom).offset(45);
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-25);
        make.height.mas_equalTo(50);
    }];
}

//设置服务条款
- (void)setUpTermsOfServiceView {
    //设置富文本
    YYLabel *TermsOfServiceLabel = [[YYLabel alloc] init];
    TermsOfServiceLabel.userInteractionEnabled = YES;
    TermsOfServiceLabel.frame = CGRectMake(0, CASScreenHight - 30, CASScreenWith, 30);
    
    NSString *policyText = @"我已阅读并同意隐私条款";
    NSMutableAttributedString *normalText = [[NSMutableAttributedString alloc] initWithString:policyText];
    NSRange policyRange = [policyText rangeOfString:@"隐私条款"];
    NSDictionary *attrsDict = @{
                               NSForegroundColorAttributeName : [UIColor blueColor],
                               NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle]
                               };
    [normalText addAttributes:attrsDict range:policyRange];
    [normalText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[policyText rangeOfString:@"我已阅读并同意"]];
    
    [normalText yy_setTextHighlightRange:policyRange color:[UIColor blueColor] backgroundColor:[UIColor redColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //添加隐私条款跳转链接或者界面
    }];
   
    //设置勾选按钮
    UIButton *termsOfServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    termsOfServiceBtn.bounds = CGRectMake(0, 0, 30, 30);
    termsOfServiceBtn.selected = YES;
    [termsOfServiceBtn setImage:[UIImage imageNamed:@"comment_checkbox_normal"] forState:UIControlStateNormal];
    [termsOfServiceBtn setImage:[UIImage imageNamed:@"comment_checkbox_selected_red"] forState:UIControlStateSelected];
    self.termsOfServiceBtn = termsOfServiceBtn;
    
    //attachment
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:termsOfServiceBtn contentMode:UIViewContentModeLeft attachmentSize:CGSizeMake(30, 30) alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
    [attachment appendAttributedString:normalText];
    
    TermsOfServiceLabel.attributedText = attachment;
    TermsOfServiceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:TermsOfServiceLabel];
    
}

@end
