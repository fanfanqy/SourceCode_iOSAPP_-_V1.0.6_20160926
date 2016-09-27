//
//  CityNameTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/27.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "CityNameTableViewCell.h"
@implementation CityNameTableViewCell
CGFloat labelwidth = 80;
CGFloat labelwidth1 = 105;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cityName = [[UILabel alloc]init];
        [self.contentView addSubview:self.cityName];

        self.comment = [[UILabel alloc]init];
        [self.contentView addSubview:self.comment];
        self.comment.textColor = [UIColor grayColor];

        self.comment.textAlignment = NSTextAlignmentRight;
        self.addButton = [[UIButton alloc]init];
        [self.contentView addSubview:self.addButton];
        [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addButton setBackgroundColor:[UIColor lightGrayColor]];
        self.addButton.layer.cornerRadius = 5;
        self.addButton.layer.masksToBounds = YES;




    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.comment.text isEqualToString:@""]) {
        self.cityName.frame = CGRectMake(10, 0, self.contentView.frame.size.width-labelwidth-20, self.contentView.frame.size.height);
        self.comment.frame = CGRectMake(0, 0, 0, 0);
        self.addButton.frame = CGRectMake(ScreenWidth-80, 5, 70, 30);
    }else if([self.comment.text isEqualToString:@" "]){
        self.cityName.frame = CGRectMake(10, 0, self.contentView.frame.size.width-labelwidth-20, self.contentView.frame.size.height);
        self.comment.frame   = CGRectMake(0, 0, 0, 0);
        self.addButton.frame = CGRectMake(0, 0, 0, 0);
    }else{
        self.cityName.frame = CGRectMake(10, 0, self.contentView.frame.size.width-labelwidth1-20, self.contentView.frame.size.height);
        self.comment.frame = CGRectMake(self.cityName.frame.size.width+10, 0, labelwidth1, 40);
        self.addButton.frame = CGRectMake(0, 0, 0, 0);

    }

    /****/
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end