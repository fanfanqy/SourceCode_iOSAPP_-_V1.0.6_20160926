//
//  WallpaperTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WallpaperTableViewCell.h"
#import "NarrrowWallpaperCollectionViewCell.h"
#import "WallpaperCollectionViewCell.h"
#import "WallpaperVC.h"
#import "Image_Model.h"
#import "CustomImageView.h"
#import "AppDelegate.h"

@interface WallpaperTableViewCell ()

@end

@implementation WallpaperTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xcccccc);
        self.array = [NSMutableArray array];
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = UIColorFromRGB(0xcccccc);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.bounces = NO;
        [self.collectionView registerClass:[WallpaperCollectionViewCell class] forCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.frame = CGRectMake(0, 0,ScreenWidth, ModuleWallpaperHeight- GapHeight);
        flow.minimumLineSpacing = 0;
        flow.sectionInset = UIEdgeInsetsMake(-1*GapHeight, 0, 0, 0);
        flow.itemSize = CGSizeMake(ScreenWidth, ModuleWallpaperHeight - GapHeight);

        // footerImage 主页壁纸模块下方的小图
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.otherCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        [self.contentView addSubview:self.otherCollectionView];
        self.otherCollectionView.backgroundColor = UIColorFromRGB(0xcccccc);
        self.otherCollectionView.delegate = self;
        self.otherCollectionView.dataSource = self;
        self.otherCollectionView.bounces = NO;
        self.otherCollectionView.showsVerticalScrollIndicator = NO;
        self.otherCollectionView.showsHorizontalScrollIndicator = NO;
        [self.otherCollectionView registerClass:[WallpaperCollectionViewCell class] forCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELLlittle"];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat height = ScreenWidth/4.0;
        self.otherCollectionView.frame = CGRectMake(0, ModuleWallpaperHeight - height - GapHeight, ScreenWidth, height);

        flowLayout.itemSize = CGSizeMake(ScreenWidth/4.0, height);
        flowLayout.minimumLineSpacing = 0;
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 无数据时返回0,有数据时,collectionView返回数组个数,缩略图返回数组个数+1,因为缩略图最后有一个'更多'
    if (self.array.count == 0) {
        if ([collectionView isEqual:self.collectionView]) {
            return 10;
        } else {
            return 11;
        }
    }
    if ([collectionView isEqual:self.collectionView]) {
        return self.array.count;
    } else {
        return self.array.count+1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NarrrowWallpaperCollectionViewCell * cell = nil;
    if ([collectionView isEqual:self.collectionView]) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELL" forIndexPath:indexPath];

        if (self.array.count>0) {
            if (indexPath.item < self.array.count) {
                Image_Model * model = [self.array objectAtIndex:indexPath.row];
                NSLog(@"%@", model.url);
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
        }else{

            UIImage *image = [UIImage imageNamed:@"load_error_max"];
            [cell.imageview setImageWithURL:nil placeholderImage:image];
            
        }

    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELLlittle" forIndexPath:indexPath];
         if (self.array.count>0) {
               if (indexPath.item < self.array.count) {
                Image_Model * model = [self.array objectAtIndex:indexPath.row];
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                NSString *tokenString =  [userDefaultes objectForKey:@"TOKEN"];
                NSString * str = [NSString stringWithFormat:@"%@?token=%@&url=%@", wallPaperImage,tokenString,model.url];
                    BOOL isHostReach  = [ReachManager isReachable];
                   UIImage *image = nil;
                   if(isHostReach){
                       image = [UIImage imageNamed:@"load_min"]; // 占位图
                   }else{
                       image = [UIImage imageNamed:@"load_error_min"];
                   }
                [cell.imageview setImageWithURL:str placeholderImage:image];
               }else{
                   cell.imageview.image = [UIImage imageNamed:@"more"];
               }
             CGFloat temp = (collectionView.contentSize.width - ScreenWidth) / (self.array.count);

             int jl = self.otherCollectionView.contentOffset.x / temp ;
             if (jl == self.array.count) {
                 if (indexPath.row == self.array.count -1) {
                     cell.layer.borderColor = [UIColor yellowColor].CGColor;
                     cell.layer.borderWidth = 1;

                 } else {
                     cell.layer.borderColor = [UIColor grayColor].CGColor;
                     cell.layer.borderWidth = 1;
                 }
             }else{
                 if (indexPath.row == jl) {
                     NSLog(@"这里变黄 %d", jl);
                     cell.layer.borderColor = [UIColor yellowColor].CGColor;
                     cell.layer.borderWidth = 1;
                 } else {
                     cell.layer.borderColor = [UIColor grayColor].CGColor;
                     cell.layer.borderWidth = 1;
                 }
             }

         }else{
             if (indexPath.item < 10){
             UIImage *image = [UIImage imageNamed:@"load_error_min"];
             [cell.imageview setImageWithURL:nil placeholderImage:image];
             }else{
                  cell.imageview.image = [UIImage imageNamed:@"more"];
             }
         }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallpaperVC *wallpaper = [[WallpaperVC alloc]init];
    
    if (self.array.count==0) {
         BOOL isHostReach  = [ReachManager isReachable];
        if (isHostReach == 1) {

            UIAlertView *alert = nil;
            if ([JSNet hasRegister]){
                alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:NSLocalizedString(@"loading error", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
            }else{
                alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:NSLocalizedString(@"please pull down refresh data", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
            }
            [alert show];

        }else{
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            [delegate addRequestErrorView];
        }
    }
    wallpaper.array = [self.array mutableCopy];
    wallpaper.pages = self.pages;
    wallpaper.Index =(int)indexPath.item;
    [self.viewControllerDelegate.navigationController pushViewController:wallpaper animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.otherCollectionView]) {
        if (self.array.count>0) {
        if (scrollView.contentOffset.x+2+ScreenWidth >= scrollView.contentSize.width) {
            self.collectionView.contentOffset = CGPointMake(ScreenWidth * (self.array.count - 1), 0);
            return;
        }
        CGFloat temp = (self.otherCollectionView.contentSize.width - ScreenWidth) / self.array.count;
        int jl = self.otherCollectionView.contentOffset.x / temp ;
        if (jl < 0) {
            self.collectionView.contentOffset = CGPointMake( 0, 0);
        }else{
            self.collectionView.contentOffset = CGPointMake(ScreenWidth * jl, 0);
        }
        NSLog(@"下停止减速 - %d", jl);
        }else{
            return;
        }
    }
    if ([scrollView isEqual:self.collectionView]) {
        if (self.array.count>0) {
        if (scrollView.contentOffset.x+ScreenWidth > scrollView.contentSize.width) {
            self.otherCollectionView.contentOffset = CGPointMake(self.otherCollectionView.contentSize.width - ScreenWidth, 0);
            return;
        }
        CGFloat temp = (self.collectionView.contentSize.width - ScreenWidth) / (self.array.count - 3);
        CGFloat jl = self.collectionView.contentOffset.x / temp ;
        
        self.otherCollectionView.contentOffset = CGPointMake(ScreenWidth/4 * jl, 0);
        NSLog(@"上停止减速 - %0.2f", jl);
        }else{
            return;
        }
    }
}
// 停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 正确
    if ([scrollView isEqual:self.otherCollectionView]) {
          if (self.array.count>0) {
        if (scrollView.contentOffset.x+ScreenWidth+2 > scrollView.contentSize.width) {
            self.collectionView.contentOffset = CGPointMake(ScreenWidth * (self.array.count - 1), 0);
            return;
        }
        
        CGFloat temp = (self.otherCollectionView.contentSize.width - ScreenWidth) / self.array.count;
        int jl = self.otherCollectionView.contentOffset.x / temp ;
        if (jl < 0) {
            self.collectionView.contentOffset = CGPointMake( 0, 0);
        }else{
            self.collectionView.contentOffset = CGPointMake(ScreenWidth * jl, 0);
        }
        NSLog(@"下停止拖拽 - %d", jl);
          }else{
              return;
          }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.otherCollectionView]) {
        if (self.array.count > 0) {
        CGFloat temp = (self.otherCollectionView.contentSize.width - ScreenWidth) / (self.array.count);
        
        int jl = self.otherCollectionView.contentOffset.x / temp ;
        for (int i = 0; i< self.array.count; i++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UICollectionViewCell * cell = [self.otherCollectionView cellForItemAtIndexPath:indexPath];
            cell.layer.borderWidth = 1;
            if (i == jl) {
                NSLog(@"%d==%d", i, jl);
                cell.layer.borderColor = [UIColor yellowColor].CGColor;
            } else {
                cell.layer.borderColor = [UIColor grayColor].CGColor;
            }
            
        }
        if (scrollView.contentOffset.x+ScreenWidth+2 > scrollView.contentSize.width) {
            UICollectionViewCell * cell = [self.otherCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.array.count - 1 inSection:0]];
            cell.layer.borderColor = [UIColor yellowColor].CGColor;
            cell.layer.borderWidth = 1;
        }
        NSLog(@"lalala - %d", jl);

        }else{
            return;
        }
    }
    if ([scrollView isEqual:self.collectionView]) {
        
        
    }
}
@end
