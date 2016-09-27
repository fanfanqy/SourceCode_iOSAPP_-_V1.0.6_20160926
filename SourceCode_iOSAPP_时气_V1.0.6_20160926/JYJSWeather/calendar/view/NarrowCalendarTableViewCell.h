//
//  NarrowCalendarTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AppDelegate.h"
@protocol NarrowCalendarTableViewCellDelegate <NSObject>

-(void)reloadCalendarTableViewCell:(NSMutableArray *)array;

@end
@interface NarrowCalendarTableViewCell : BaseTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,weak)id <NarrowCalendarTableViewCellDelegate> delegate;

@end
