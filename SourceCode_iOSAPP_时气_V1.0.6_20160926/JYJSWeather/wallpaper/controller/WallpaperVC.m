//
//  WallpaperVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/2/25.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WallpaperVC.h"
#import "CustomImageView.h"
#import "Image_Model.h"

#import "WallpaperCVCell.h"
#import "SinglePaperVC.h"

#import "RefreshView.h"
#import "UIScrollView+RefreshFooterView.h"

#import "SqlDataBase.h"
#import "CacheDataManager.h"
#import "AppDelegate.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


typedef enum{
    GESTURE_STATE_START,
    GESTURE_STATE_MOVE,
    GESTURE_STATE_END
}GestureState;
@interface WallpaperVC ()<UICollectionViewDataSource, UICollectionViewDelegate,UIWebViewDelegate>
{
    BOOL first;
    BOOL second;
}
@property (nonatomic, strong) UICollectionView  * wallpaperCollection;
@property (nonatomic, assign) BOOL               isRefreshing;
@property (nonatomic, strong) CacheDataManager  * cacheDataManager;
@property (nonatomic, strong) UIView            * headerView;
@property (nonatomic, strong) UIButton          * left_button;
@property (nonatomic, strong) UIButton          * middle_button;
@property (nonatomic, strong) UIWebView         * middle_webview;
@property (nonatomic, strong) UIView            * backgroundView;      // 添加所有视图,以后可改为scrollview
@property (nonatomic, strong) UIButton          * right_button;
@property (nonatomic, strong) UIWebView         * webView;
@property (nonatomic, assign) GestureState        gesState;
@property (nonatomic, strong) NSString          * imgURL;
@property (nonatomic, strong) NSTimer           * timer;
@property (nonatomic, strong) UIView            * effectview;
/*
 * No : HTML在第一个页面
 * YES: HTML在第二个页面
 */
@property (nonatomic, assign) BOOL midHT_Page;
/****/
/*
 * NO : HTML在第一页
 * YES: HTML在第二个页面了
 */
@property (nonatomic, assign) BOOL htmlPage;
/*
 * NO : 返回上一级
 * YES: 返回HTML
 */
@property (nonatomic, assign) BOOL goBack;
@end

@implementation WallpaperVC
{
    RefreshView * _refreshHeaderView;               //壁纸刷新
    RefreshView * _midwebviewRefreshHeaderView;     //静态表情刷新
    RefreshView * _rightwebviewRefreshHeaderView;   //动态表情刷新
    int _count;
    SqlDataBase *sqldata;
    int _page;//本地page 变量,_pages:传过来的变量

    RefreshPosition _refreshPosition;

}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pictureArray = [NSMutableArray array];
        self.array = [NSMutableArray array];
        _page = 0;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"self.view.frame:%f",self.view.frame.origin.y);
    UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:scroll];
  
    [self creatView];
    [self creatWallpaper];
    [self creatRefreshHeadView];
    // setup infinite scrolling
     __weak WallpaperVC *weakSelf = self;
    [self.wallpaperCollection addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    [self setNavigationIteam];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    titleLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:17];
    titleLabel.text = NSLocalizedString(@"壁纸/表情", @"Wallpaper");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;

    sqldata = [[SqlDataBase alloc]init];
    [sqldata configSelectedWallpaperListDB];
    _cacheDataManager = [[CacheDataManager alloc]initFile];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_Index !=0) {
        if (_Index<8) {
            [self.wallpaperCollection setContentOffset:CGPointMake(0, (_Index/2)* (WallPaperScale * ScreenWidth/2)) animated:YES];
        }else {
            if(_Index == 10){
                _Index--;
            }
            [self.wallpaperCollection setContentOffset:CGPointMake(0, (_Index/2-1)* (WallPaperScale * ScreenWidth/2)+98) animated:YES];
        }

    }
    _Index = 0;
}

- (void)creatWallpaper{
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 108, self.view.frame.size.width * 3, self.view.frame.size.height-108)];
    [self.view addSubview:self.backgroundView];
    _page   = self.pages;
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = self.view.frame.size.width /2-1;
    CGFloat height = WallPaperScale * width -1;
    flow.itemSize = CGSizeMake(width, height);
    flow.minimumLineSpacing = 2; // 行
    flow.minimumInteritemSpacing = 2; //列
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.wallpaperCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.backgroundView.frame.size.height) collectionViewLayout:flow];
    self.wallpaperCollection.showsHorizontalScrollIndicator = NO;
    self.wallpaperCollection.showsVerticalScrollIndicator = NO;
    self.wallpaperCollection.delegate = self;
    self.wallpaperCollection.dataSource = self;
    [self.backgroundView addSubview:self.wallpaperCollection];
    [self.wallpaperCollection registerClass:[WallpaperCVCell class] forCellWithReuseIdentifier:@"wallpapercell"];
    self.wallpaperCollection.backgroundColor = [UIColor whiteColor];


}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WallpaperCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wallpapercell" forIndexPath:indexPath];
    if (self.array.count>0) {
        Image_Model * model = [self.array objectAtIndex:indexPath.row];
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *tokenString =  [userDefaultes objectForKey:@"TOKEN"];
        NSString * str = [NSString stringWithFormat:@"%@?token=%@&url=%@", wallPaperImage,tokenString,model.url];
        //BOOL isHostReach  = [[NetWorkMonitor networkReachable] isHostReach];
        BOOL isHostReach  = [ReachManager isReachable];
        UIImage *image = nil;
        if(isHostReach){
            image = [UIImage imageNamed:@"load_middle"]; // 占位图
        }else{
            image = [UIImage imageNamed:@"load_error_mid"];
        }
        [cell.wallpaper setImageWithURL:str placeholderImage:image];
    }else{
         UIImage *image = [UIImage imageNamed:@"load_error_mid"];
         [cell.wallpaper setImageWithURL:nil placeholderImage:image];
    }
    return cell;
}
- (void)creatMidWebView{
    self.middle_webview = [[UIWebView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.backgroundView.frame.size.height)];
    _middle_webview.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.backgroundView addSubview:self.middle_webview];
    _middle_webview.delegate = self;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *tokenString =  [userDefaultes objectForKey:@"TOKEN"];
    NSString * midurlStr = [NSString stringWithFormat:@"%@?token=%@&last=%@&t=1",ExpressionUrl,tokenString,@"epoch"];
    NSURL * midurl = [NSURL URLWithString:midurlStr];
    NSURLRequest * nidrequest = [NSURLRequest requestWithURL:midurl];
    [self.middle_webview loadRequest:nidrequest];
    self.middle_webview.scrollView.delegate = self;
    self.middle_webview.backgroundColor = [UIColor whiteColor];
    [self creatMidWebviewRefreshHeaderView];
    
    
}
- (void)creatRightWebView{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.backgroundView.frame.size.height)];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.backgroundView addSubview:_webView];
    _webView.delegate = self;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *tokenString =  [userDefaultes objectForKey:@"TOKEN"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?token=%@&last=%@&t=2",ExpressionUrl,tokenString,@"epoch"];
    NSLog(@"%@", urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scrollView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self creatRightWebviewRefreshHeaderView];
}
#pragma mark - 创建头部view,可自定义,可在上面添加图片,文字按钮
- (void)creatView{
    // 头部view
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    [self.view addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.headerView.frame;
    CGFloat w = frame.size.width/3;
    // 按钮中间的竖线
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(w, 0, 1, frame.size.height)];
    line.backgroundColor = [UIColor grayColor];
    [self.headerView addSubview:line];
    
    UILabel * rightline = [[UILabel alloc]initWithFrame:CGRectMake(w*2, 0, 1, frame.size.height)];
    rightline.backgroundColor = [UIColor grayColor];
    [self.headerView addSubview:rightline];
    
    UILabel * topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
    topLine.backgroundColor = [UIColor grayColor];
    [self.headerView addSubview:topLine];
    
    // 三个按钮
    self.left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w, frame.size.height)];
    [self.headerView addSubview:self.left_button];
    [_left_button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    _left_button.selected = YES;
    [_left_button setTitle:@"壁纸" forState:UIControlStateNormal];
    [_left_button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_left_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.middle_button = [[UIButton alloc]initWithFrame:CGRectMake(w, 0, w, frame.size.height)];
    [self.headerView addSubview:self.middle_button];
    [self.middle_button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    _middle_button.selected = YES;
    [_middle_button setTitle:@"静态表情" forState:UIControlStateNormal];
    [_middle_button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_middle_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _middle_button.selected = NO;
    
    self.right_button = [[UIButton alloc]initWithFrame:CGRectMake(w*2, 0, w, frame.size.height)];
    [self.headerView addSubview:self.right_button];
    [_right_button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    _right_button.selected = NO;
    [_right_button setTitle:@"动态表情" forState:UIControlStateNormal];
    [_right_button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_right_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

}
- (void)instructionsAction:(id)sender{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [delegate.window addSubview:self.effectview];
}
- (void)sureAction:(id)sender{
    [self.effectview removeFromSuperview];
}
#pragma mark - 切换按钮的点击方法
- (void)changeAction:(UIButton *)button{
    // 如果点击的按钮已经被选中了,那么不进行操作
    if (button.selected) {
        return;
    }else{
        
        // 切换按钮的选择状态
        self.right_button.selected = NO;
        self.left_button.selected = NO;
        self.middle_button.selected = NO;
        button.selected = YES;
    }
    if(self.left_button.selected == NO){
       // BOOL isHostReach  = [[NetWorkMonitor networkReachable] isHostReach];
        BOOL isHostReach  = [ReachManager isReachable];
        if (isHostReach == 0) {
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            [delegate addRequestErrorView];
        }
    }
    CGRect backgroundViewFrame = _backgroundView.frame;
    // 改变下面的table及其动画
    if (self.left_button.selected) {
        backgroundViewFrame.origin.x = 0;
        self.backgroundView.frame = backgroundViewFrame;
        // 只要是点击左侧壁纸按钮,都是返回主页
        self.goBack = NO;
        
    }else if(self.right_button.selected){
        backgroundViewFrame.origin.x = - self.view.frame.size.width * 2;
        self.backgroundView.frame = backgroundViewFrame;
        if (self.htmlPage) {
            self.goBack = YES;
        }else{
            self.goBack = NO;
        }
        if (!_webView) {
            [self creatRightWebView];
        }

    }else{
        backgroundViewFrame.origin.x = - self.view.frame.size.width;
        self.backgroundView.frame = backgroundViewFrame;
        if (self.midHT_Page) {
            self.goBack = YES;
        }else{
            self.goBack = NO;
        }
        if (!_middle_webview) {
            [self creatMidWebView];
        }
    }
    // 改变tableview的偏移量
    [UIView animateWithDuration:0.2 animations:^{
        self.wallpaperCollection.contentOffset = CGPointMake(0, 0);
    }];
    NSLog(@"%d %d %d",self.left_button.selected, self.middle_button.selected, self.right_button.selected);
    NSLog(@"%d", _goBack);
}
#pragma mark - webview
- (void)webViewDidStartLoad:(UIWebView *)webView{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate addLoadView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // 999 还有未结束的请求就开始新的请求
    // 101 无法显示 URL
    // 加载WebView失败
    NSLog(@"%@", webView.request.URL);
    if (error.code != 101) {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate removeLoadView];
        [delegate addRequestErrorView];
    }
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate removeLoadView];
    static NSString* const kTouchJavaScriptString=
    @"document.ontouchstart=function(event){\
    x=event.targetTouches[0].clientX;\
    y=event.targetTouches[0].clientY;\
    document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
    document.ontouchmove=function(event){\
    x=event.targetTouches[0].clientX;\
    y=event.targetTouches[0].clientY;\
    document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
    document.ontouchcancel=function(event){\
    document.location=\"myweb:touch:cancel\";};\
    document.ontouchend=function(event){\
    document.location=\"myweb:touch:end\";};\
    document.documentElement.style.webkitUserSelect='none';";
    
    [self.webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];

    [self.middle_webview stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
}
//js执行代码：
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {
    // 如果是在第二页,长按图片保存图片,如果是在第一页,不做响应
    if (!self.htmlPage && !first) {
        
        first = YES;
        return YES;
    }
    if (!self.midHT_Page && !second) {
        second = YES;
        return YES;
    }
    
    if (!self.htmlPage && self.right_button.selected) {
        if (navigationType == UIWebViewNavigationTypeLinkClicked)
        {
            self.htmlPage = YES;
            self.goBack = YES;
            return YES;
        }
    }
    
    if (!self.midHT_Page && self.middle_button.selected) {
        if (navigationType == UIWebViewNavigationTypeLinkClicked)
        {
            self.midHT_Page = YES;
            self.goBack = YES;
            return YES;
        }
    }
    if ((self.midHT_Page && self.middle_button.selected) || (self.htmlPage && self.right_button.selected)){
        NSString *requestString = [[_request URL] absoluteString];
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                       isEqualToString:@"myweb"]) {
            if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
            {
                if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
                {
                    /*
                     @需延时判断是否响应页面内的js...
                     */
                    _gesState = GESTURE_STATE_START;
                    NSLog(@"touch start!");
                    float ptX = [[components objectAtIndex:3]floatValue];
                    float ptY = [[components objectAtIndex:4]floatValue];
                    NSLog(@"touch point (%f, %f)", ptX, ptY);
                    
                    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];

                    NSString * tagName = nil;
                    if (self.middle_button.selected) {
                        tagName = [self.middle_webview stringByEvaluatingJavaScriptFromString:js];
                    } else {
                        tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
                    }
                    /****/
                    _imgURL = nil;
                    if ([tagName isEqualToString:@"IMG"]) {
                        _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                    }
                    // 如果是在第二页,长按图片保存图片
                    if ((self.htmlPage && self.right_button.selected) || (self.midHT_Page && self.middle_button.selected)) {
                        if (_imgURL) {
                            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                        }
                    }                }
                else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
                {
                    //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                    _gesState = GESTURE_STATE_MOVE;
                    NSLog(@"you are move");
                    
                }
                else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
                    [_timer invalidate];
                    _timer = nil;
                    _gesState = GESTURE_STATE_END;
                    NSLog(@"touch end");
                }
            }
            return NO;
        }
        return YES;
    }
    return YES;
}
- (void)goBackViewController{
    NSLog(@"goback");
    if (self.goBack) {
        self.goBack = NO;
        if (self.middle_button.selected) {
            self.midHT_Page = NO;
            [self.middle_webview goBack];
        }
        if (self.right_button.selected) {
            [self.webView goBack];
            self.htmlPage = NO;
        }
        
    } else {
        CGRect frame = self.backgroundView.frame;
        frame.origin.x = 0;
        self.backgroundView.frame = frame;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//如果点击的是图片，并且按住的时间超过1s，执行handleLongTouch函数，处理图片的保存操作。
- (void)handleLongTouch {
    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START) {

        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片"]) {
        if (_imgURL) {
            NSLog(@"imgurl = %@", _imgURL);
        }

        NSString *urlToSave = nil;
        if (self.middle_button.selected) {
            
            urlToSave = [self.middle_webview stringByEvaluatingJavaScriptFromString:_imgURL];
        }else{
            urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:_imgURL];
        }
        /****/
        NSLog(@"image url=%@", urlToSave);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        //        UIImage* image = [UIImage imageWithData:data];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            
            NSLog(@"Success at %@", [assetURL path] );
        }] ;
        
        //        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error){
        NSLog(@"Error");
        //                [self showAlert:SNS_IMAGE_HINT_SAVE_FAILE];
    }else {
        NSLog(@"OK");
        //                [self showAlert:SNS_IMAGE_HINT_SAVE_SUCCE];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.array.count==0) {
        return 10;
    }
    return self.array.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SinglePaperVC *singlePaper = [[SinglePaperVC alloc]init];
    singlePaper.array = self.array;
    singlePaper.index = indexPath.row;
    [self.navigationController pushViewController:singlePaper animated:YES];
    
}
#pragma mark - 导航栏
- (void)setNavigationIteam{
    UIView * navigationBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [self.view addSubview:navigationBackView];
    navigationBackView.backgroundColor = [UIColor whiteColor];
    
    UIImage *leftimage = [UIImage imageNamed:@"back_Black"];
    UIButton * leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0, 22, 22);
    [leftButton setImage:leftimage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}
#pragma mark   ---------- 下拉刷新 上拉刷新
- (void)creatRefreshHeadView{
    //创建下拉刷新 View
    if (!_refreshHeaderView) {
        RefreshView *view = [[RefreshView alloc] initWithFrame:CGRectMake(0, -300, self.view.frame.size.width, 300)];
        _refreshHeaderView = view;
        _refreshHeaderView.delegate = (id)self;
        [_wallpaperCollection addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}
- (void)creatMidWebviewRefreshHeaderView{
    if (!_midwebviewRefreshHeaderView) {
        RefreshView *view = [[RefreshView alloc] initWithFrame:CGRectMake(0, -300, self.view.frame.size.width, 300)];
        _midwebviewRefreshHeaderView = view;

        _midwebviewRefreshHeaderView.delegate = (id)self;
        [self.middle_webview.scrollView addSubview:_midwebviewRefreshHeaderView];
    }
    [_midwebviewRefreshHeaderView refreshLastUpdatedDate];
}
- (void)creatRightWebviewRefreshHeaderView{
    
    if (!_rightwebviewRefreshHeaderView) {
        RefreshView *view = [[RefreshView alloc] initWithFrame:CGRectMake(0, -300, self.view.frame.size.width, 300)];
        _rightwebviewRefreshHeaderView = view;
        _rightwebviewRefreshHeaderView.delegate = (id)self;
        [self.webView.scrollView addSubview:_rightwebviewRefreshHeaderView];
    }
    [_rightwebviewRefreshHeaderView refreshLastUpdatedDate];
    
}
//上拉 下拉都要用这两个方法监听滚动高度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.wallpaperCollection]) {
        [_refreshHeaderView refreshViewDidScroll:scrollView];
        if (scrollView.contentOffset.y>=scrollView.contentSize.height-80) {
            [self.wallpaperCollection.infiniteScrollingView setNeedsDisplay];
            [self.wallpaperCollection.infiniteScrollingView stopAnimating];
        }
    }
    if ([scrollView isEqual:self.middle_webview.scrollView]) {
        [_midwebviewRefreshHeaderView refreshViewDidScroll:scrollView];
    }
    if ([scrollView isEqual:self.webView.scrollView]) {
        [_rightwebviewRefreshHeaderView refreshViewDidScroll:scrollView];
    }

}
//结束拖拽状态
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([scrollView isEqual:self.wallpaperCollection]) {
        [_refreshHeaderView refreshViewDidEndDragging:scrollView];
        
    }
    if ([scrollView isEqual:self.webView.scrollView]) {
        [_rightwebviewRefreshHeaderView refreshViewDidEndDragging:scrollView];
    }
    if ([scrollView isEqual:self.middle_webview.scrollView]) {
        [_midwebviewRefreshHeaderView refreshViewDidEndDragging:scrollView];
    }}
//下载数据
- (void)UpdownloadData{
    //这里刷新数据
    [self initHttpRequest];
    //刷新完成后,应该让刷新视图调用下面的方法,来结束刷新,收起刷新提示条
    [_refreshHeaderView refreshViewDataSourceDidFinishedLoading:_wallpaperCollection];
    //改变标记状态
    _isRefreshing = NO;
}
//刷新webview
- (void)reloadWebview{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *tokenString =  [userDefaultes objectForKey:@"TOKEN"];
    NSString * urlstr = self.webView.request.URL.absoluteString;
    if ([urlstr  isEqualToString: @""]) {
        NSString * urlString = [NSString stringWithFormat:@"%@?token=%@&last=%@&t=2",ExpressionUrl,tokenString,@"epoch"];
        NSURL * url = [NSURL URLWithString:urlString];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    } else {
        [self.webView reload];
    }
    [_rightwebviewRefreshHeaderView refreshViewDataSourceDidFinishedLoading:_webView.scrollView];
    //改变标记状态
    _isRefreshing = NO;
}
//刷新midwebview
- (void)reloadMidWebview{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *tokenString =  [userDefaultes objectForKey:@"TOKEN"];
    NSString * urlstr = self.middle_webview.request.URL.absoluteString;
    
    if ([urlstr  isEqualToString: @""]) {
        NSString * midurlStr = [NSString stringWithFormat:@"%@?token=%@&last=%@&t=1",ExpressionUrl,tokenString,@"epoch"];
        NSURL * midurl = [NSURL URLWithString:midurlStr];
        NSURLRequest * nidrequest = [NSURLRequest requestWithURL:midurl];
        [self.middle_webview loadRequest:nidrequest];
        
    } else {
        [self.middle_webview reload];
    }
    [_midwebviewRefreshHeaderView refreshViewDataSourceDidFinishedLoading:_middle_webview.scrollView];
    //改变标记状态
    _isRefreshing = NO;
}
//下拉刷新,请求壁纸数据
-(void)initHttpRequest{

    if (_refreshPosition == RefreshHeader) {
            if (![JSNet hasRegister]) {
                [JSNet appRegisterWithFinishBlock:^(BOOL isFinishRegister) {
                    NSLog(@"AppregisterSuccess");
                    [self handleWallpaperData];
                }];
            }else{
                [self handleWallpaperData];
            }

            

    }
    NSLog(@"%lu",(unsigned long)self.array.count);
}
// 请求壁纸数据
- (void)handleWallpaperData{
    // 返回的格林治时间
    NSDate *dateUtc = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"RequestDataTime"]) {
        dateUtc = nil;

    }else{
        NSDate *date1 = [user objectForKey:@"RequestDataTime"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //输入格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *str = [dateFormatter stringFromDate:date1];
        NSDate *dateFormatted = [dateFormatter dateFromString:str];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        //输出格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
        dateUtc = [dateFormatter dateFromString:dateString];
        NSLog(@"dateUtc:%@",dateUtc);
    }
    
    // 请求壁纸大数据
   [JSNet handleWallPaperListFinishDataBlock:^(NSData *data) {
        SqlDataBase *sqldataInThisMethod = [[SqlDataBase alloc]init];
        [sqldataInThisMethod configSelectedWallpaperListDB];
        [sqldataInThisMethod configDatabase];
        NSError * error = nil;
        NSDictionary *  dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!error) {

            NSArray *array = [dic objectForKey:@"d"];
            if ((NSNull *)array != [NSNull null]) {
                if (array.count!=0) {

                    //请求时间重置
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:[NSDate date] forKey:@"RequestDataTime"];
                    //解析数据
                     NSArray *arraySort = [Image_Model sortOutDataWith:array];
                    //新的添加进数据库
                    [sqldataInThisMethod addWallperToServerWallPaperList:array];
                    [sqldataInThisMethod addWallper:arraySort];
                    //新数据插入 wallpaperCollection.datasource 中,_page不用等于0
                    if (self.array.count>0) {
                        for (int i=0; i<[arraySort count]; i++) {
                            Image_Model  * resultModel = arraySort[i];
                            [self.array insertObject:resultModel atIndex:i];
                        }
                    }else{
                        self.array = (NSMutableArray *)[sqldata achieveTenWallper:0 andWallpaperKind:3];
                    }
                    [_wallpaperCollection reloadData];
                }else{

                }
            }
        }
        }];
    
}
//向下滚动,添加数据
- (void)insertRowAtBottom {

    NSMutableArray *arrayIndexPath = [NSMutableArray array];
    if (self.array.count>0) {

        if ([[sqldata achieveTenWallper:_page andWallpaperKind:3] count]==0) {

            [self.wallpaperCollection.infiniteScrollingView setTextLabelString:@"已经到底了"];

        }else{

            NSArray *array = [sqldata achieveTenWallper:_page andWallpaperKind:3];
            for (int i=0; i<[array count]; i++) {
                Image_Model  * resultModel = array[i];
                [self.array addObject: resultModel];
            }

            for (int i=1; i<=array.count; i++) {
                [arrayIndexPath addObject: [NSIndexPath indexPathForRow:self.array.count-i inSection:0]];
            }

            [UIView animateWithDuration:0.3 animations:^{
                [self.wallpaperCollection insertItemsAtIndexPaths:arrayIndexPath];
            }];
              [self.wallpaperCollection.infiniteScrollingView stopAnimating];
              _page++;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

                if (self.wallpaperCollection.frame.origin.y!=0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.wallpaperCollection setFrame:CGRectMake(0, 0, self.wallpaperCollection.frame.size.width, self.wallpaperCollection.frame.size.height)];
                    });

                }
            });


        }
    }else{
        [self.wallpaperCollection.infiniteScrollingView setTextLabelString:@"已经到底了"];
        [self.wallpaperCollection.infiniteScrollingView stopAnimating];
    }


}

#pragma mark - RefreshView Delegate
//下拉刷新的执行方法  如果上述两个监听的滚动高度小于-65(scrollView.contentOffset.y <= - 65.0f)则执行这个代理方法改变刷新状态(出现菊花图)
- (void)refreshViewDidTriggerRefresh:(RefreshPosition)refreshPosition{
    NSLog(@"这里触发执行刷新操作");
    _isRefreshing = YES;
    _refreshPosition = refreshPosition;
    if (self.middle_webview.scrollView.contentOffset.y <= -60 ) {
        [self performSelector:@selector(reloadMidWebview) withObject:nil afterDelay:0];
    } else if (self.webView.scrollView.contentOffset.y <= -60) {
        [self performSelector:@selector(reloadWebview) withObject:nil afterDelay:0];
    }else {
        [self performSelector:@selector(UpdownloadData) withObject:nil afterDelay:0];
    }
}

//滚动过程会不断调用这个方法监听是否改变刷新状态(即是否出现菊花图转的效果),实现原理中 需要这个变量去判断请求数据是否完成
- (BOOL)refreshViewDataIsLoading:(UIView *)view{
    return _isRefreshing;
}
//显示刷新时间
- (NSDate*)refreshViewDataLastUpdated{
    return [NSDate date];
}

@end
