//
//  AboutUsViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/19.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SoftwareVersionViewController.h"
#import "SoftwareIntroduceViewController.h"
#import "PrivacyPolicyViewController.h"

@interface AboutUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , strong) UIView * navigationBackView;

@end

@implementation AboutUsViewController
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [@[NSLocalizedString(@"app guide", nil), NSLocalizedString(@"app version", nil), NSLocalizedString(@"app privacypolicy", nil)] mutableCopy] ;
    }
    return _array;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self setNavigationIteam];
    self.title = NSLocalizedString(@"about us", nil);
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
- (void)creatTableView
{
    self.tableview = [[UITableView  alloc]initWithFrame:CGRectMake(0, 280, self.view.frame.size.width , self.view.frame.size.height) style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.scrollEnabled = NO;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ABOUTUSTABLEVIEWCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ABOUTUSTABLEVIEWCELL"];
    }
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ if (indexPath.row == 1) {
    SoftwareVersionViewController *softwareVC = [[SoftwareVersionViewController alloc]init];
    [self.navigationController pushViewController:softwareVC animated:YES];
}
    if (indexPath.row == 0) {
        SoftwareIntroduceViewController * introduceVC = [[SoftwareIntroduceViewController alloc]init];
        [self.navigationController pushViewController:introduceVC animated:YES];
    }
    if (indexPath.row == 2) {
        PrivacyPolicyViewController * privacyPolicy = [[PrivacyPolicyViewController alloc]init];
        [self.navigationController pushViewController:privacyPolicy animated:YES];
    }
}

@end
