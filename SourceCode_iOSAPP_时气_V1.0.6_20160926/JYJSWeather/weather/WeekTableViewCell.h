//
//  WeekTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol WeekTableViewCellDelegate;
@interface WeekTableViewCell : BaseTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic , weak) id <WeekTableViewCellDelegate> delegate;
@end
@protocol WeekTableViewCellDelegate <NSObject>

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end