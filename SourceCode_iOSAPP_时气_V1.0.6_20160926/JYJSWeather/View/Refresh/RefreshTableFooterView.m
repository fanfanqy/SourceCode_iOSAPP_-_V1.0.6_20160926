//
//  EGORefreshTableFooterView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RefreshTableFooterView.h"
#define  REFRESH_REGION_HEIGHT 65.0f
@interface RefreshTableFooterView (Private)
- (void)setState:(RefreshState)aState;
@end

@implementation RefreshTableFooterView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame  textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        _statusLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:17];

		[self setState:RefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame  textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

    if ([_delegate respondsToSelector:@selector(refreshViewDataLastUpdated)]) {

        NSDate *date = [_delegate refreshViewDataLastUpdated];

        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

        _lastUpdatedLabel.text = [NSString stringWithFormat:@"最后加载时间: %@", [dateFormatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else {
        _lastUpdatedLabel.text = nil;
        
    }
}


- (void)setState:(RefreshState)aState{
	
	switch (aState) {
		case RefreshTrigger:
			_statusLabel.text = NSLocalizedString(@"松开加载", @"Release to load more");
			break;

		case RefreshNormal:
			_statusLabel.text = NSLocalizedString(@"加载更多", @"Pull up to load more");
            [self refreshLastUpdatedDate];
			break;

		case RefreshLoading:
			_statusLabel.text = NSLocalizedString(@"正在加载", @"Loading Status");
			break;
		default:
			break;
	}
	
	_state = aState;
    if (_state == RefreshSuccess) {
        _state = RefreshNormal;
    }
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshViewDidScroll:(UIScrollView *)scrollView {

//    if (_state == RefreshTrigger) {
//
//        //		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
//        //		offset = MIN(offset, 60);
//        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
//
//    } else
    if (scrollView.isDragging) {

        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(refreshViewDataIsLoading:)]) {
            _loading = [_delegate refreshViewDataIsLoading:self];
        }

        if (_state == RefreshTrigger &&
            (scrollView.contentOffset.y+scrollView.frame.size.height) < scrollView.contentSize.height+REFRESH_REGION_HEIGHT &&
            scrollView.contentOffset.y > 0.0f && !_loading) {
            [self setState:RefreshNormal];
        } else if (_state == RefreshNormal &&
                   scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT && !_loading) {
            [self setState:RefreshTrigger];
        }

        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        if (scrollView.contentSize.height < scrollView.frame.size.height) {
            if (_state == RefreshTrigger && (scrollView.contentOffset.y < 65) && !_loading) {
                [self setState:RefreshNormal];
            } else if (_state == RefreshNormal && (scrollView.contentOffset.y > 65) &&  !_loading){
                [self setState:RefreshTrigger];
            }
        }

    }

}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView {

    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(refreshViewDataIsLoading:)]) {
        _loading = [_delegate refreshViewDataIsLoading:self];
    }
    //NSLog(@"bottom:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT  && !_loading) {

        if ([_delegate respondsToSelector:@selector(refreshViewDidTriggerRefresh:)]) {
            if (scrollView.contentOffset.y > 65) {
                [_delegate refreshViewDidTriggerRefresh:RefreshFooter];
                [self setState:RefreshLoading];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0.0f, scrollView.contentOffset.y, 0.0f);
                [UIView commitAnimations];
            } else {
                [self setState:RefreshNormal];
            }

        }

    }

}

- (void)refreshViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView andSetContentoffsetHeight:(float)height{

    [UIView animateWithDuration:RefreshFastAnimationDuration delay:2*RefreshFastAnimationDuration options:UIViewAnimationOptionCurveLinear animations:^{
         scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f, scrollView.contentOffset.y, 0.0f);
//        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    } completion:^(BOOL finished) {
        [self setState:RefreshNormal];
    }];

//     [self setState:RefreshNormal];

    
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_statusLabel = nil;
	_lastUpdatedLabel = nil;
}


@end
