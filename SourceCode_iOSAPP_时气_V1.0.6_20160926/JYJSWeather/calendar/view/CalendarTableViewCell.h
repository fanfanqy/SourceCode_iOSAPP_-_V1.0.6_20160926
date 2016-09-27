//
//  CalendarTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AppDelegate.h"
@protocol CalendarTableViewCellDelegate <NSObject>

-(void)reloadCalendarTableViewCell:(NSMutableArray *)array;

@end

@interface CalendarTableViewCell : BaseTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property(assign)id <CalendarTableViewCellDelegate> delegate;


@end
