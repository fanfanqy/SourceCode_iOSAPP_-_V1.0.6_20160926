//
//  SoftwareVersionViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/20.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "SoftwareVersionViewController.h"
#define APP_URL  @"https://itunes.apple.com/lookup?bundleId=com.falv.xjkj"
@interface SoftwareVersionViewController ()

@property (nonatomic , strong) UILabel * software;
@property (nonatomic , strong) UIView * navigationBackView;
@end

@implementation SoftwareVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"app version", nil);
    [self setNavigationIteam];
    [self creatImageView];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)creatImageView
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 100, 100, 100)];
    [self.view addSubview:imageView];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"jyjslogo.png" ofType:nil];
    imageView.image = [UIImage imageWithContentsOfFile:path];
    imageView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height, self.view.frame.size.width, 80)];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    label.text = [NSLocalizedString(@"app version", nil) stringByAppendingString:[NSString stringWithFormat:@": %@",infoDic[@"CFBundleShortVersionString"]]];;

    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;

}
- (void)setNavigationIteam
{
    self.navigationBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [self.view addSubview:_navigationBackView];
    _navigationBackView.backgroundColor = [UIColor whiteColor];
    
    UIImage *leftimage = [UIImage imageNamed:@"back_Black"];
    UIButton * leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0, 22, 22);
    [leftButton setImage:leftimage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];

}

- (void)goBackViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
