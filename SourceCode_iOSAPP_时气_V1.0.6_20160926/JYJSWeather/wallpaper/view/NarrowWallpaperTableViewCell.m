//
//  NarrowWallpaperTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "NarrowWallpaperTableViewCell.h"
#import "WallpaperVC.h"
#import "Image_Model.h"
#import "AppDelegate.h"
#import "CustomImageView.h"
#import "NarrrowWallpaperCollectionViewCell.h"

@implementation NarrowWallpaperTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.array = [NSMutableArray array];
       
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.collectionView];

        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        UINib *nib = [UINib nibWithNibName:@"NarrrowWallpaperCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"NARROWWALLPAPERCOLLECTIONCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.pagingEnabled = NO;
        self.collectionView.bounces = NO;
        self.collectionView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect fream = [UIScreen mainScreen].bounds;
    self.collectionView.frame = CGRectMake(0, 0, fream.size.width, self.contentView.frame.size.height);
    UICollectionViewFlowLayout *ff  = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    ff.sectionInset = UIEdgeInsetsMake(-1*GapHeight, 0, 0, 0);
    ff.itemSize = CGSizeMake(self.collectionView.frame.size.width/3, self.collectionView.frame.size.height-GapHeight);
    ff.minimumLineSpacing = 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.array.count > 0) {
        return self.array.count+1;
    } else {
        if ([collectionView isEqual:self.collectionView]) {
            return 10;
        } else {
            return 11;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NarrrowWallpaperCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NARROWWALLPAPERCOLLECTIONCELL" forIndexPath:indexPath];
    if (self.array.count >1) {
        if (indexPath.item < self.array.count) {
            Image_Model * model = [self.array objectAtIndex:indexPath.row];
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *tokenString =  [userDefaultes objectForKey:@"TOKEN"];
            
            NSString * str = [NSString stringWithFormat:@"%@?token=%@&url=%@", wallPaperImage,tokenString,model.url];
           // BOOL isHostReach  = [[NetWorkMonitor networkReachable] isHostReach];
            BOOL isHostReach  = [ReachManager isReachable];
            UIImage *image = nil;
            if(isHostReach){
                image = [UIImage imageNamed:@"load_min"]; // 占位图
            }else{
                image = [UIImage imageNamed:@"load_error_min"];
            }
            [cell.imageview setImageWithURL:str placeholderImage:image];
        }
        if (indexPath.item == self.array.count) {
            cell.imageview.image = [UIImage imageNamed:@"more"];
        }
    }else{

        UIImage *image = [UIImage imageNamed:@"load_error_min"];
        [cell.imageview setImageWithURL:nil placeholderImage:image];

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
    wallpaper.array = [self.otherArray mutableCopy];
    wallpaper.pages = self.pages;
    wallpaper.Index = (int)indexPath.item;
    
    [self.viewControllerDelegate.navigationController pushViewController:wallpaper animated:YES];
}
@end
