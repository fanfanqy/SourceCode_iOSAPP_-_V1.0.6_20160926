//
//  FeedbackViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/20.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "FeedbackViewController.h"

static const CGFloat gap = 10;
static const CGFloat buttonHeight = 30;

@interface FeedbackViewController ()
@property (nonatomic , strong) UIView           * buttonBackgroundView;
@property (nonatomic , strong) NSArray          * butArray;
@property (nonatomic , strong) UITextView       * textView;
@property (nonatomic , strong) UIButton         * submit;
@property (nonatomic , strong) NSMutableArray   * array;
@property (nonatomic , strong) UIView           * navigationBackView;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"feedback", nil);
    [self.view setBackgroundColor:UIColorFromRGB(0xF4F4F4)];
    [self getFeedBackCategories];
    [self creatView];
    [self addSwipe];
    [self setNavigationIteam];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    CGRect frame = self.textView.frame;

    frame.size.height = ScreenHeight - frame.origin.y - height - 10;
    self.textView.frame = frame;
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    CGRect frame = self.textView.frame;
    frame.size.height = ScreenHeight - self.buttonBackgroundView.frame.origin.y - self.buttonBackgroundView.frame.size.height - 50;
    self.textView.frame = frame;
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
    
    self.submit = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-40) / 2, self.textView.frame.origin.y + self.textView.frame.size.height + gap, buttonHeight * 2, buttonHeight)];
    self.submit.titleLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TextNumberThree];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.submit];
    [self.submit setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    [self.submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)goBackViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getFeedBackCategories{
    
    [JSNet handleFeedBackCategoriesFinishBlock:^(NSData *data) {
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:&error];
        if (!error) {
            self.array = [dic objectForKey:@"d"];
            [self reloadViewFrames];
        } else {
            NSLog(@"请求失败");
        }
    }];
}
- (void)reloadViewFrames{
    CGFloat width = 0;
    for (int i = 1; i <= self.array.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttonHeight, 60)];
        [self.buttonBackgroundView addSubview:label];
        label.tag = 1000 + i;
        label.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERFOUR];
        label.userInteractionEnabled = YES;
        label.text = [self.array objectAtIndex:(i - 1)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
        label.frame = CGRectMake(width, gap, rect.size.width + 2 * gap, buttonHeight);

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedType:)];
        [label addGestureRecognizer:tap];
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 1;
        label.layer.borderColor = UIColorFromRGB(0xF4F4F4).CGColor;
        width = width + label.frame.size.width + gap;
        /**/
    }

}
- (void)creatView{
    self.buttonBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(gap, gap + 64, self.view.frame.size.width - gap * 2, buttonHeight + gap * 2)];
    [self.view addSubview:self.buttonBackgroundView];

    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(gap, self.buttonBackgroundView.frame.origin.y + self.buttonBackgroundView.frame.size.height, self.view.frame.size.width - 2 * gap, ScreenHeight - self.buttonBackgroundView.frame.origin.y - self.buttonBackgroundView.frame.size.height - 50)];
    [self.view addSubview:self.textView];
    self.textView.layer.cornerRadius = gap;
    self.textView.font = [UIFont systemFontOfSize:17];
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil]; // 让完成按钮显示在右侧
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"complete", nil)
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(pickerDoneClicked)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    self.textView.inputAccessoryView = keyboardDoneButtonView;
    
}
- (void)submitAction:(UIButton *)button{
    NSString * Category = @"";
    for (UILabel *label  in self.buttonBackgroundView.subviews) {
        if (label.backgroundColor == [UIColor lightGrayColor]) {
            Category = label.text;
        }
    }
    if ([JSNet hasRegister]) {
        if ([_textView.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"submit failed", nil) message:NSLocalizedString(@"empty content title", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
            [alertView show];
        } else if([Category isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"submit failed", nil) message:NSLocalizedString(@"noselect feedkind", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
            [alertView show];
        }else{
            [JSNet submitFeedBackWithCategory:Category Contents:_textView.text finishBlock:^(NSData *data) {
                NSError * error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:&error];
                if (!error) {
                    NSNumber * number = [dic objectForKey:@"d"];
                    if ([number integerValue] == 1 ) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"submit success", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
                        [alertView show];
                        // 提交成功后清空
                        self.textView.text = nil;
                        for (UILabel *label  in self.buttonBackgroundView.subviews) {
                            if (label.backgroundColor == [UIColor lightGrayColor]) {
                                label.backgroundColor = [UIColor whiteColor];
                            }
                        }
                        
                    }else {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"submit failed", nil) message:NSLocalizedString(@"submit again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
                        [alertView show];
                    }
                    
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"submit failed", nil) message:NSLocalizedString(@"submit again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
                    [alertView show];
                    NSLog(@"提交失败");
                }
            }];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"submit failed", nil) message:NSLocalizedString(@"submit again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
        [alertView show];
        [JSNet appRegisterWithFinishBlock:^(BOOL isFinishRegister) {
        }];
    }
}
-(void)pickerDoneClicked{
    [self.textView resignFirstResponder];
}
- (void)addSwipe{
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
}
- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGesture{
    [self.textView resignFirstResponder];
}
- (void)selectedType:(UITapGestureRecognizer *)tap{
    
    for (UILabel *label  in self.buttonBackgroundView.subviews) {
        
        label.backgroundColor = [UIColor whiteColor];
    }
    tap.view.backgroundColor = [UIColor lightGrayColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
