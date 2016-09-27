//
//  FQTRefreshView.m
//  FQYRefreshView
//
//  Created by DEVP-IOS-03 on 16/1/26.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "RefreshView.h"
//#import "NetWorkMonitor.h"

@implementation RefreshView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 20.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont fontWithName:CALENDARFONTHEITI size:12];
        label.textColor = UIColorFromRGB(0x000000);
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel=label;
        _lastUpdatedLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:14];

        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 38.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.textColor = UIColorFromRGB(0x000000);
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        _statusLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TextNumberThree];

        CALayer *layer = [CALayer layer];
        NSLog(@"TableHeaderView:frame.size.height:%f",frame.size.height);
        layer.frame = CGRectMake(125.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:@"arrow11"].CGImage;
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= _4_0
                if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                    layer.contentsScale = [[UIScreen mainScreen] scale];
                }
        #endif
        [[self layer] addSublayer:layer];
        _arrowImage=layer;
//        初始给个Normal 状态
        [self setState:RefreshNormal];
    }
    return self;
}

- (void)refreshLastUpdatedDate
{
    if ([_delegate respondsToSelector:@selector(refreshViewDataLastUpdated)]) {

        NSDate *date = [_delegate refreshViewDataLastUpdated];

        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm:ss"];

        NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"上次刷新:%@",[formatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"lastUpdatedDate"];
        [[NSUserDefaults standardUserDefaults] setObject:[formatter1 stringFromDate:date] forKey:@"lastCacheDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSString *text = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastUpdatedDate"];
        if (text != nil) {
            _lastUpdatedLabel.text = text;
        }
        else{
            _lastUpdatedLabel.text = @"上次刷新:从未加载";
        }
    }
}

- (void)refreshViewDidScroll:(UIScrollView *)scrollView
{
    //在一个拖动过程中,随时会出现3种状态,需要进行条件判断,当最后结束的时候,查看完整EGORefresh效果,缺少"刷新完成",为了效果,加了一个刷新完成的状态
    // scrollView 是拖动状态下,这几个状态会来回转换
    if (_state != RefreshSuccess) {
        if (scrollView.isDragging) {
        BOOL _loading = NO;
            if ([_delegate respondsToSelector:@selector(refreshViewDataIsLoading:)]) {
                _loading = [_delegate refreshViewDataIsLoading:self];
            }
            //状态的赋值,是根据contentOffset.y的值来决定的,所以y值改变量达到另一种状态时,_state 还是原来的值
            if (_state == RefreshNormal && scrollView.contentOffset.y < -65.0f && scrollView.contentOffset.y <0 && !_loading) {
                    [self setState:RefreshTrigger];
            }

            if (_state == RefreshTrigger && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y <0 && !_loading) {
                [self setState:RefreshNormal];
            }
        }
        else{
            BOOL _loading = NO;
            if ([_delegate respondsToSelector:@selector(refreshViewDataIsLoading:)]) {
                _loading = [_delegate refreshViewDataIsLoading:self];
            }
            if (_state == RefreshTrigger && scrollView.contentOffset.y >= -65.0f && scrollView.contentOffset.y <0 && _loading) {
                 [self setState:RefreshLoading];
            }
        }
    }
    else
    {
        
        [self setState:RefreshSuccess];
    }
}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(refreshViewDataIsLoading:)]) {
        _loading = [_delegate refreshViewDataIsLoading:self];
    }
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
        
        [self setState:RefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:RefreshFastAnimationDuration];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        if ([_delegate respondsToSelector:@selector(refreshViewDidTriggerRefresh:)]) {
            [_delegate refreshViewDidTriggerRefresh:RefreshHeader];
        }

    }
}

- (void)refreshViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [self setState:RefreshSuccess];
    
    [UIView animateWithDuration:RefreshFastAnimationDuration delay:2*RefreshFastAnimationDuration options:UIViewAnimationOptionCurveLinear animations:^{
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(setNavigationBarShow)]) {
            [_delegate setNavigationBarShow];
        }
    }];
}

#pragma mark  私有方法
//设置状态,每种状态对应不同显示内容
- (void)setState:(RefreshState)state{

    switch (state) {
        case RefreshTrigger:
            //文字
            _statusLabel.text = @"松开刷新";
            //动画
            [CATransaction begin];
            _arrowImage.hidden = NO;
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation(M_PI , 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            break;

        case RefreshNormal:
            //这个地方用户不放手,在2个状态之间切换的动画,若果不加这个,从RefreshTrigger变到RefreshNormal没有动画,可以试验一下.上一个case,从RefreshNormal变到RefreshTrigger为什么不用这个条件,是因为初始状态是RefreshNormal
            if (_state == RefreshTrigger) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.hidden = NO;
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }

            _statusLabel.text = @"下拉刷新";
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];

            [self refreshLastUpdatedDate];

            break;
        case RefreshLoading:
            _statusLabel.text = @"正在刷新";

            [_activityView startAnimating];
            //这里就一部操作,把_arrowImage隐藏了,但是没这个暂时禁用图层的行为,消失的比较突兀,http://blog.csdn.net/robincui2011/article/details/9464781
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];

            break;
        case RefreshSuccess:
        {  BOOL isHostReach  = [ReachManager isReachable];
            NSLog(@"isHostReach:%d",isHostReach);
            if (isHostReach == 1) {
            _statusLabel.text = @"完成刷新";
            }else{
                _statusLabel.text = @"请检查网络设置";
            }
            _arrowImage.hidden = YES;
            [_activityView stopAnimating];
        }
            break;
        default:
            break;
    }
    _state = state;
    if (_state == RefreshSuccess) {
        _state = RefreshTrigger;
    }
}

@end
