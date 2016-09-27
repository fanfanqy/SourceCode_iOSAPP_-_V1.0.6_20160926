//
//  PrivacyPolicyViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/7/22.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()
@property (nonatomic , strong) UIWebView * webView;
@property (nonatomic , strong) UIView       * navigationBackView;
@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"app privacypolicy", nil);
    [self setNavigationIteam];
    [self creatWebview];
}
- (void)creatWebview{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:_webView];
    NSURL * url = [NSURL URLWithString:PrivacyPolicyUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:request];
}
- (void)setNavigationIteam{
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
- (void)goBackViewController{
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
