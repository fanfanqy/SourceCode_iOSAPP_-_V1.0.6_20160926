//
//  SinglePaperVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/3/4.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "SinglePaperVC.h"
#import "BelowToolbar.h"
#import "UIImage+ChangeSize.h"
#import "WallpaperCollectionViewCell.h"
#import "Image_Model.h"
#import "CustomImageView.h"
#import "AppDelegate.h"
@interface SinglePaperVC ()<UIAlertViewDelegate , UICollectionViewDelegate, UICollectionViewDataSource,BelowToolbarDelegate>

@property (nonatomic , strong) BelowToolbar *belowToolbar;
@property (nonatomic , strong) UIView * navigationBackView;
@property (nonatomic , strong) UICollectionView * collectionView;
@end

@implementation SinglePaperVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatCollectionView];
    [self creatSubviews];
    [self setNavigationIteam];
}
- (void)setNavigationIteam
{
    self.title = @"壁纸详情";
    self.navigationBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [self.view addSubview:_navigationBackView];
    _navigationBackView.backgroundColor = [UIColor whiteColor];
    
    UIImage *leftimage = [UIImage imageNamed:@"back_Black"];
    UIButton * leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0, 22, 22);
    [leftButton setImage:leftimage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    // 分享按钮
    UIImage *rightimage = [UIImage imageNamed:@"share_black"];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 18, 24);
    [rightButton setImage:rightimage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}
- (void)goBackViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatCollectionView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -64, ScreenWidth, ScreenHeight+64) collectionViewLayout:flow];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[WallpaperCollectionViewCell class] forCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELL"];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = YES;
    flow.itemSize = CGSizeMake(ScreenWidth, ScreenHeight);
    flow.minimumLineSpacing = 0;

    self.collectionView.contentOffset = CGPointMake(self.view.frame.size.width * self.index, 0);

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallpaperCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELL" forIndexPath:indexPath];
    if (self.array.count > 0) {
    Image_Model * model = [self.array objectAtIndex:indexPath.row];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *tokenString =  [userDefaultes objectForKey:@"TOKEN"];
    NSString * str = [NSString stringWithFormat:@"%@?token=%@&url=%@", wallPaperImage,tokenString,model.url];
     BOOL isHostReach  = [ReachManager isReachable];
    UIImage *image = nil;
    if(isHostReach){
        image = [UIImage imageNamed:@"load_max"]; // 占位图
    }else{
        image = [UIImage imageNamed:@"load_error_max"];
    }
    [cell.imageview setImageWithURL:str placeholderImage:image];
    }
    return cell;
}
// 点击当前图片,隐藏/显示 工具按钮
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    CGRect naviRect = self.navigationBackView.frame;
    CGRect toolRect = self.belowToolbar.frame;
    if (naviRect.origin.y == 0) {
        naviRect.origin.y = 0 - naviRect.size.height;
        toolRect.origin.y = toolRect.origin.y + toolRect.size.height;
    } else {
        
        naviRect.origin.y = 0;
        toolRect.origin.y = toolRect.origin.y - toolRect.size.height;
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
        self.navigationBackView.frame = naviRect;
        self.belowToolbar.frame = toolRect;
    }];
    
}

- (void)shareAction
{
    NSLog(@"分享给好友");
    int temp = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    WallpaperCollectionViewCell * cell = (WallpaperCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:temp inSection:0]];
    UIImage * image = cell.imageview.image;
    NSArray *activityItems = [[NSArray alloc]initWithObjects:image, nil];
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
    UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
        NSLog(@"completed:%d type:%@",completed,type);
    };
    avc.completionHandler = myblock;
}
- (void)creatSubviews
{
    // 收藏,预览,下载
    self.belowToolbar = [[BelowToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    [self.view addSubview:self.belowToolbar];
    self.belowToolbar.delegate = self;
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)downloadAction // 下载
{
    int temp = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    Image_Model * model = nil;
    if (self.array.count > 0) {
        model = [self.array objectAtIndex:temp];
    }
    NSString * fileName = model.url;
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSFileManager *manager=[NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/images", path];
    path = [NSString stringWithFormat:@"%@/%@", path,fileName];

    BOOL isHasFile=[manager fileExistsAtPath:path];
    if (isHasFile) {
        //为真表示已经请求过这个文件,可以直接读取
        WallpaperCollectionViewCell * cell = (WallpaperCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:temp inSection:0]];
        UIImage * image = cell.imageview.image;
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"download success", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
        [alert show];

    }else{
        //没有请求过这个图片
         BOOL isHostReach  = [ReachManager isReachable];

        if (isHostReach == 1) {
            // 请求天气数据
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"下载失败" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
            [alert show];
        }else{
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            [delegate addRequestErrorView];
        }

    }
    /****/
}
@end
