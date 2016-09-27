//
//  SoftwareIntroduceViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/6/7.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "SoftwareIntroduceViewController.h"
@interface SoftwareIntroduceViewController ()
@property (nonatomic , strong) UIView       * navigationBackView;
//@property (nonatomic , strong) UITextView   * introduceView;
@property (nonatomic , strong) UIScrollView   * scrollView;
@property (nonatomic , strong) UILabel   * introduceLabel;
@property (nonatomic , strong) UILabel      * versionLabel;

@end

@implementation SoftwareIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"app guide", nil);
    [self createScrollView];
    [self setNavigationIteam];
    [self creatImageView];
    [self creatIntroduceLabel];
    
}

-(void)createScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
//    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

}

- (void)creatImageView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 20, 100, 100)];
    [_scrollView addSubview:imageView];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"jyjslogo.png" ofType:nil];
    imageView.image = [UIImage imageWithContentsOfFile:path];
    imageView.layer.masksToBounds = YES;
    
    self.versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height, imageView.frame.size.width, 80)];
    [_scrollView addSubview:_versionLabel];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;

      _versionLabel.text = NSLocalizedString(@"CFBundleDisplayName", nil);
    _versionLabel.textColor = [UIColor blackColor];
    _versionLabel.numberOfLines = 0;
    
}
- (void)creatIntroduceLabel{
    _introduceLabel = [[UILabel alloc]init];
    _introduceLabel.numberOfLines = 0;
    CGRect rect = CGRectMake(10, self.versionLabel.frame.origin.y + self.versionLabel.frame.size.height, self.view.frame.size.width - 20, 9999);

    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"softwareIntroduce" ofType:@"txt"];
    NSString *strIntroduce = [NSString stringWithContentsOfFile:strBasePath encoding:NSUTF8StringEncoding error:nil];
    [_scrollView addSubview:_introduceLabel];
    
//    CGSize size = [strIntroduce sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(self.view.frame.size.width-20 , 9999) lineBreakMode:NSLineBreakByWordWrapping];
    //计算文本高度
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont boldSystemFontOfSize:17] ,NSFontAttributeName,
                                   paragraphStyle,NSParagraphStyleAttributeName,
                                   nil];
    CGRect rectSize = [strIntroduce boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict  context:nil];


    [_introduceLabel setFrame:CGRectMake(rect.origin.x,rect.origin.y,rectSize.size.width,rectSize.size.height)];
    _introduceLabel.text = strIntroduce;
    [_scrollView addSubview:_introduceLabel];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _introduceLabel.frame.origin.y+_introduceLabel.frame.size.height+10);
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
}


@end
