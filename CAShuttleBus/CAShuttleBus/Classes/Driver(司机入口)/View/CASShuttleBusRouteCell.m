//
//  CASShuttleBusRouteCell.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/21.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASShuttleBusRouteCell.h"
#import "CASShuttleBusRouteItem.h"

@interface CASShuttleBusRouteCell()

@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *startPointLab;
@property (nonatomic, strong) UIImageView *startIconView;
@property (nonatomic, strong) UIImageView *endPointIconView;
@property (nonatomic, strong) UILabel *endPointLab;
@property (nonatomic, strong) UIImageView *busTypeIconView;
@property (nonatomic, strong) UILabel *busTypeLab;
@property (nonatomic, strong) UIButton *lineDepartureBtn;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIView *stripView;

@end

@implementation CASShuttleBusRouteCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //出发时间label
        UILabel *startTimeLabel = [[UILabel alloc] init];
        startTimeLabel.textColor = [UIColor blackColor];
        startTimeLabel.font = [UIFont boldSystemFontOfSize:20];
//        startTimeLabel.text = @"12:12";
        [self.contentView addSubview:startTimeLabel];
        self.startTimeLabel = startTimeLabel;
        //始点icon
        UIImage *startIcon = [UIImage imageNamed:@"starting_point"];
        UIImageView *startIconView = [[UIImageView alloc] initWithImage:startIcon];
        [self.contentView addSubview:startIconView];
        self.startIconView = startIconView;
        //始点label
        UILabel *startPointLab = [[UILabel alloc] init];
        startPointLab.textColor = [UIColor blackColor];
        startPointLab.font = [UIFont systemFontOfSize:15];
//        startPointLab.text = @"机场大道口";
        [self.contentView addSubview:startPointLab];
        self.startPointLab = startPointLab;
        //终点icon
        UIImage *endPointIcon = [UIImage imageNamed:@"end_point"];
        UIImageView *endPointIconView = [[UIImageView alloc] initWithImage:endPointIcon];
        [self.contentView addSubview:endPointIconView];
        self.endPointIconView = endPointIconView;
        //终点label
        UILabel *endPointLab = [[UILabel alloc] init];
        endPointLab.textColor = [UIColor blackColor];
        endPointLab.font = [UIFont systemFontOfSize:15];
//        endPointLab.text = @"京明凤凰家园";
        [self.contentView addSubview:endPointLab];
        self.endPointLab = endPointLab;
        //大巴类型icon
        UIImage *busTypeIcon = [UIImage imageNamed:@"bus_type"];
        UIImageView *busTypeIconView = [[UIImageView alloc] initWithImage:busTypeIcon];
        [self.contentView addSubview:busTypeIconView];
        self.busTypeIconView = busTypeIconView;
        //大巴类型label
        UILabel *busTypeLab = [[UILabel alloc] init];
        busTypeLab.textColor = CASARGBColor(1.0, 165, 165, 165);
        busTypeLab.font = [UIFont systemFontOfSize:15];
//        busTypeLab.text = @"大巴";
        [self.contentView addSubview:busTypeLab];
        self.busTypeLab = busTypeLab;
        //线路发车button
        UIButton *lineDepartureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lineDepartureBtn.backgroundColor = CASARGBColor(1.0, 97, 211, 111);
        lineDepartureBtn.titleLabel.textColor = [UIColor whiteColor];
        lineDepartureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        lineDepartureBtn.layer.cornerRadius = 5.0;
        [lineDepartureBtn setTitle:@"线路发车" forState:UIControlStateNormal];
        [self.contentView addSubview:lineDepartureBtn];
        self.lineDepartureBtn = lineDepartureBtn;
        //线路时长label
        UILabel *totalTimeLabel = [[UILabel alloc] init];
        totalTimeLabel.textColor = CASARGBColor(1.0, 165, 165, 165);
        totalTimeLabel.font = [UIFont systemFontOfSize:12];
//        totalTimeLabel.text = @"约06h06m";
        [self.contentView addSubview:totalTimeLabel];
        self.totalTimeLabel = totalTimeLabel;
        //cell间的分割线
        UIView *stripView = [[UIView alloc] initWithFrame:CGRectZero];
        stripView.backgroundColor = CASARGBColor(1.0, 246, 246, 246);
        [self.contentView addSubview:stripView];
        self.stripView = stripView;
       //设置layout
        [self layoutUI];
    }
    return self;
}

#pragma mark - layout
- (void)layoutUI {
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-55);
        make.width.mas_equalTo(55);
    }];
    
    [self.startIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.startTimeLabel.mas_right).offset(30);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    [self.startPointLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startIconView.mas_right).offset(10);
        make.centerY.equalTo(self.startIconView.mas_centerY);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(15);
    }];
    
    [self.endPointIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startIconView.mas_bottom).offset(15);
        make.left.equalTo(self.startIconView.mas_left);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    [self.endPointLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startPointLab.mas_left);
        make.centerY.equalTo(self.endPointIconView.mas_centerY);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(15);
    }];
    
    [self.busTypeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endPointIconView.mas_bottom).offset(15);
//        make.left.equalTo(self.endPointIconView.mas_left);
        make.centerX.equalTo(self.startIconView.mas_centerX);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.busTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startPointLab.mas_left);
        make.centerY.equalTo(self.busTypeIconView.mas_centerY);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(15);
    }];
    
    [self.lineDepartureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineDepartureBtn.mas_right);
        make.centerY.equalTo(self.busTypeIconView.mas_centerY);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(10);
    }];
    
    [self.stripView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - setItem
- (void)setItem:(CASShuttleBusRouteItem *)item {
    _item = item;
    self.startTimeLabel.text = item.startTime;
    self.startPointLab.text = item.startPoint;
    self.endPointLab.text = item.endPoint;
    self.busTypeLab.text = item.busType;
    self.totalTimeLabel.text = item.LineTime;
}

@end
