//
//  LocationController.m
//  JYJS
//
//  Created by DEV-IOS-2 on 15/12/17.
//  Copyright © 2015年 DEV-IOS-2. All rights reserved.
//

#import "LocationController.h"
#import "Utils.h"
#import "DBModel.h"
#import "AppDelegate.h"
#import "SqlDataBase.h"
#import "RootViewController.h"
#import "CityNameTableViewCell.h"

#define UserLocationManager @"userLocationManager"

@interface LocationController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    /*
     YES:tableview上铺dataArr , 即所有保存的城市
     NO:tableview上铺resultArr , 即所有检索到的城市
     */
    BOOL change;
    /*
     YES:搜索的为字母
     NO:搜索的为汉字 默认NO
     */
    BOOL languageShows;
}
@property (nonatomic, strong) UITableView       * table;
@property (nonatomic, strong) NSMutableArray    * resultArr;        // 搜索结果数组
@property (nonatomic, strong) UISearchBar       * searchBar;
@property (nonatomic, strong) UILabel           * myLocation;
@property (nonatomic, strong) UIButton          * editBut;
@property (nonatomic, strong) NSMutableArray    * userCityArray;    // 用来存储添加的城市顺序
@property (nonatomic, strong) NSMutableArray    * dataArr;

@property (nonatomic, strong) UIView            * localCityView;    // 当前城市不在城市列表时,显示当前城市
@property (nonatomic, strong) UIView            * titleHeaderView;  // 顶部当前位置,编辑
@property (nonatomic, copy)   NSMutableArray     * initialArray;    // 记录刚进入时的城市列表顺序

@end

@implementation LocationController
{
    SqlDataBase *_sqldata;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.userCityArray = [NSMutableArray array];
        self.locationCityModel = [[DBModel alloc]init];
        self.dataArr = [NSMutableArray array];
        self.resultArr = [NSMutableArray array];
        self.initialArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"my city", nil);
    [self handleData];
//当前语言code判断
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *culture = delegate.languageCode;
    if ([culture isEqualToString:@"zh"]) {
        languageShows = NO;
    }else{
        languageShows = YES;
    }
    [self creatLocalcityView];
    [self creatTable];
    [self setNavigationIteam];
    [self readUserDefaults];
    self.initialArray = self.userCityArray;
}

- (void)handleData{
    // 先从userdefault中读取城市顺序,在从数据库中读取城市信息
    [self readUserDefaults];
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
    [sqldata configDatabase];
    NSArray * arr = [sqldata searchAllSaveCity];

    for (NSString * cityname in self.userCityArray) {

        for (DBModel *model in arr) {
            BOOL flag  =  NO;

            // 按顺序给城市排序
//                qwz 相同,名字不同可以添加; qwz 不同,名字相同,可以添加 ; qwz 不同,名字不同,可以添加
//                qwz 相同,名字相同不可以添加;
                if ([cityname isEqualToString:model.cityCC]) {
                        for (int j=0; j<self.dataArr.count; j++) {
                            DBModel *model1 = self.dataArr[j];
                            if ([model1.cityCC isEqualToString:cityname] && [model1.qwz isEqualToString:model.qwz]) {
                                flag = YES;//已经添加过了
                                break;
                            }
                            flag = NO;
                        }
                        if (!flag) {
                            [self.dataArr addObject:model];
                        }
                }
        }
    }
}

- (void)creatLocalcityView{
    self.titleHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    self.localCityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, _titleHeaderView.frame.size.height/2)];
    _localCityView.backgroundColor = [UIColor whiteColor];
    UILabel * cityName = [[UILabel alloc]init];
    cityName.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTWO];
    [_localCityView addSubview:cityName];
    cityName.frame = CGRectMake(10, 0, ScreenWidth -80-20, _localCityView.frame.size.height);
    cityName.text = [NSString stringWithFormat:@"当前位置是:%@",self.locationCityModel.cityCC];
    UIButton * addButton = [[UIButton alloc]init];
    [_localCityView addSubview:addButton];
    [addButton setTitle:NSLocalizedString(@"add", nil) forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTWO];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setBackgroundColor:[UIColor lightGrayColor]];
    addButton.layer.cornerRadius = 5;
    addButton.layer.masksToBounds = YES;
    addButton.frame = CGRectMake(ScreenWidth-80, 5, 70, 30);
    [addButton addTarget:self action:@selector(addlocalcity) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleHeaderView addSubview:_localCityView];
    // 先设置坐标, 如果发现当前位置城市在城市列表中,则将坐标改为0

    self.myLocation = [[UILabel alloc]initWithFrame:CGRectMake(20,  _localCityView.frame.size.height, EditWidth, EditHeight)];
    [_titleHeaderView addSubview:_myLocation];
    _myLocation.text = NSLocalizedString(@"city list", nil);
    _myLocation.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTHREE];

    self.editBut = [[UIButton alloc]initWithFrame:CGRectMake(_titleHeaderView.frame.size.width - EditWidth/2-10, _localCityView.frame.size.height, EditWidth/2, EditHeight)];
    _editBut.titleLabel.textAlignment = NSTextAlignmentRight;
    _editBut.titleLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTWO];
    [_titleHeaderView addSubview:_editBut];
    [_editBut setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
    [_editBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editBut addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [_editBut setTitle:NSLocalizedString(@"complete", nil) forState:UIControlStateSelected];
    // 设置坐标
    for (DBModel *model in self.dataArr) {
        if ([model.cityCC isEqualToString:self.locationCityModel.cityCC]) {
            [self setTitleHeaderViewFrameWithShow:NO];
            break;
        }
    }
}
- (void)setTitleHeaderViewFrameWithShow:(BOOL)sure{
    if (sure) {
        self.titleHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
        self.localCityView.frame = CGRectMake(0, 0, ScreenWidth, _titleHeaderView.frame.size.height/2);
        [self.titleHeaderView addSubview:self.localCityView];

    }else{
        self.titleHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        self.localCityView.frame = CGRectMake(0, 0, 0, 0);
        [self.localCityView removeFromSuperview];
    }

    self.editBut.frame = CGRectMake(_titleHeaderView.frame.size.width - EditWidth/2-10, _localCityView.frame.size.height, EditWidth/2, EditHeight);
    self.myLocation.frame = CGRectMake(20,  _localCityView.frame.size.height, EditWidth, EditHeight);
}
- (void)creatTable{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.table];
    _table.delegate = self;
    _table.dataSource = self;
    [self.table registerClass:[CityNameTableViewCell class] forCellReuseIdentifier:@"LOCATIONCELL"];
    [self createSearchBar];
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
- (void)goBackViewController{
    RootViewController * root = (RootViewController *)[self.navigationController.viewControllers firstObject];
    if (self.userCityArray.count != self.initialArray.count) {
        [root handleWeatherAndCityData];
    } else {
        for (int i = 0; i < self.userCityArray.count; i++) {
            NSString * a = [self.userCityArray objectAtIndex:i];
            NSString * b = [self.initialArray objectAtIndex:i];
            if (![a isEqualToString:b]) {
                [root handleWeatherAndCityData];
                break;
            }
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 搜索
- (void)createSearchBar{

    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.table.tableHeaderView = _searchBar;
    _searchBar.delegate = self;
    _searchBar.placeholder = NSLocalizedString(@"search", nil);

}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
    self.editBut.selected = YES;
    [self editAction:self.editBut];
    [searchBar setShowsCancelButton:YES animated:YES];
    // 开始编辑
    [self.resultArr removeAllObjects];
    [self.table reloadData];
    return YES;
}
// 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.resultArr = [NSMutableArray array];
    _sqldata = [[SqlDataBase alloc]init];
    [_sqldata configDatabase];

    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [searchBar.text stringByTrimmingCharactersInSet:set];
    if (searchBar.text == nil || trimedString.length == 0) {


    }else{

        if (searchBar.text.length>0&&![Utils isAllChineseInString:searchBar.text]) {
            NSLog(@"searchBar.text1:%@",searchBar.text);
            [self searchCity:searchBar.text];

        }else if (searchBar.text.length>0&&[Utils isAllChineseInString:searchBar.text]) {
            NSLog(@"searchBar.text2:%@",searchBar.text);
            if (!self.locationCityModel.cityCC){
                self.resultArr =  [_sqldata searchWithString:searchBar.text andIsPinyin:NO andLocationCityModel:nil];
            }else{
                self.resultArr =  [_sqldata searchWithString:searchBar.text andIsPinyin:NO andLocationCityModel:self.locationCityModel];
            }

            if (self.resultArr.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"search failed", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"search again", nil) otherButtonTitles: nil];
                [alert show];

            } else {
                change = YES;
                [self.table reloadData];
            }
        }
    }

}
-(void)searchCity:(NSString *)string{

    NSArray *arrayTemp = [_sqldata searchWithString:string andIsPinyin:YES andLocationCityModel:self.locationCityModel];
    for (int i=0; i< [arrayTemp count]; i++) {

        //             [self.resultArr addObject:arrayTemp[i]];
        // 假如搜索tianjin,接口返回的是tianjin,本地存储的是:天津,这个时候,根据语言,汉语保留天津,英语保留tianjin
        DBModel *model = arrayTemp[i];
        BOOL flag = NO;
        for (DBModel *item in self.resultArr) {
            if ([item.qwz isEqualToString:model.qwz]) {
                flag = YES;
                break;
            }
        }
        if (!flag) {
            [self.resultArr addObject:arrayTemp[i]];
        }
    }
    if (self.resultArr.count == 0) {

        [JSNet searchCityWithString:string FinishBlock:^(NSData *data) {
            NSError * error = nil;
            
            NSDictionary * finishDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                NSString * dataString = [finishDic objectForKey:@"d"];
                if ((NSNull *)dataString != [NSNull null]) {
                    NSData * finishData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                    if (finishData != nil) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finishData options:NSJSONReadingMutableContainers error:nil];

                        NSArray *arrayResults =[[dic objectForKey:@"response"] objectForKey:@"results"];

                        if (arrayResults != nil) {
                            for (int i=0; i<arrayResults.count; i++) {
                                NSDictionary *dicTemp = arrayResults[i];
                                DBModel *model = [[DBModel alloc]init];
                                model.cityPinyin = [dicTemp objectForKey:@"city"];
                                model.country_name = [dicTemp objectForKey:@"country_name"];
                                model.lat = @" ";
                                model.lon = @" ";
                                model.qwz = [dicTemp objectForKey:@"l"];
                                model.cityCC = [dicTemp objectForKey:@"city"];
                                model.isCC = NO;
                                [self.resultArr addObject:model];
                            }

                        }else{
                            NSString * dataString = [finishDic objectForKey:@"d"];
                            if ((NSNull *)dataString != [NSNull null]) {

                                NSData * finishData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                                NSError * error = nil;
                                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:finishData options:NSJSONReadingMutableContainers error:&error];
                                NSDictionary *dic2 = [dic1 objectForKey:@"location"];

                                if (!dic2) {

                                }else{
                                    DBModel *model = [[DBModel alloc]init];
                                    model.cityPinyin = [dic2 objectForKey:@"city"];
                                    model.country_name = [dic2 objectForKey:@"country_name"];
                                    model.lat = [dic2 objectForKey:@"lat"];
                                    model.lon = [dic2 objectForKey:@"lon"];
                                    model.qwz = [dic2 objectForKey:@"l"];
                                    model.cityCC = [dic2 objectForKey:@"city"];
                                    model.isCC = NO;
                                    [self.resultArr addObject:model];
                                }
                            }
                        }
                    }
                }
            }
            //处理 搜集来的
            int indexFlagMin = 0;
            NSMutableArray *indexFlagMinArray = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray *countryNameArray = [NSMutableArray arrayWithCapacity:10];
            for (int i=0; i < self.resultArr.count; i++) {
                DBModel *model1 = self.resultArr[i];
                NSString *countryName = model1.country_name;
                BOOL addedCountryName = NO;
                if(countryNameArray.count == 0 ){
                    [countryNameArray addObject:countryName];
                }else{
                    for (int t=0; t<countryNameArray.count; t++) {
                        if ([countryName isEqualToString:countryNameArray[t]]) {
                            addedCountryName = YES;
                            break;
                        }
                        addedCountryName = NO;
                    }
                    if (!addedCountryName) {
                        [countryNameArray addObject:countryName];
                    }
                }
                if(self.locationCityModel.cityCC) {
                    if ([model1.cityPinyin isEqualToString:string] && [model1.cityPinyin isEqualToString:self.locationCityModel.cityPinyin] && !addedCountryName) {
                        [indexFlagMinArray addObject:[NSString stringWithFormat:@"%d",indexFlagMin]];
                    }else{
                        if (!addedCountryName) {
                            indexFlagMin = i;
                            [indexFlagMinArray addObject:[NSString stringWithFormat:@"%d",indexFlagMin]];
                        }
                    }
                }else{
                    if (!addedCountryName) {
                        indexFlagMin = i;
                        [indexFlagMinArray addObject:[NSString stringWithFormat:@"%d",indexFlagMin]];
                    }
                }
            }
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (int k=0; k<indexFlagMinArray.count; k++) {
                DBModel *model = self.resultArr[[indexFlagMinArray[k] intValue]];
                [mutableArray addObject:model];
            }
            [self.resultArr removeAllObjects];
            self.resultArr = mutableArray;

            if (self.resultArr.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"search failed", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"search again", nil) otherButtonTitles: nil];
                [alert show];

            } else {
                change = YES;
                [self.table reloadData];
            }
        }];


    } else {
        change = YES;
        [self.table reloadData];
    }

}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    // 结束编辑
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    change = NO;
    self.searchBar.text = @"";
    [self.table reloadData];
    [searchBar resignFirstResponder];
    // 点击取消
}
// 判断这个城市是否已经添加过,如果未添加过则添加到表中
- (void)saveCityToDB:(DBModel *)model{
    
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
     [sqldata configDatabase];
    if ([sqldata searchOneCity:model] != nil) {
        [self.table reloadData];

    } else{

        //去除@"（";
        NSString *modelCityCC = nil;
        for (int i=0; i<model.cityCC.length; i++) {
            NSString *s = [model.cityCC substringWithRange:NSMakeRange(i, 1)];
            if ([s isEqualToString:@"（"]) {
                NSRange range;
                range = NSMakeRange(0, i);
                modelCityCC = [model.cityCC substringWithRange:range];
                model.cityCC = modelCityCC;
                break;
            }
        }

        [sqldata saveCityToDB:model];
        [self.userCityArray addObject:model.cityCC];
        [self saveUserDefaults];
        [self.dataArr removeAllObjects];
        [self.resultArr removeAllObjects];
        [self handleData];
        [self.table reloadData];
    }
}
#pragma mark - 滚动键盘退出
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}
// 编辑 / 完成 点击事件
- (void)editAction:(UIButton *)button{
    [_searchBar resignFirstResponder];

    button.selected = !button.selected;
    if (button.selected) {
        [self.table setEditing:YES animated:YES];

    }else{
        // 将当前城市顺序存到本地
        [self saveUserDefaults];
        [self.table setEditing:NO animated:YES];
    }

}
#pragma mark - tableview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.titleHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (change) {
        return 0;

    } else {
            if (!self.locationCityModel.cityCC ) {
                [self setTitleHeaderViewFrameWithShow:NO];
                return 40;
            }
            [self setTitleHeaderViewFrameWithShow:YES];
            for (DBModel *model in self.dataArr) {
                if ([model.cityCC isEqualToString:self.locationCityModel.cityCC]) {

                    [self setTitleHeaderViewFrameWithShow:NO];
                    return 40;

                }
            }
            return 80;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}
// 删除城市
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.userCityArray.count > indexPath.row) {
    [self.userCityArray removeObjectAtIndex:indexPath.row];
    [self saveUserDefaults];
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
    [sqldata configDatabase];
    [sqldata deleateCityFromSaveCity:[self.dataArr objectAtIndex:indexPath.row]];

    CacheDataManager *cacheDataManager = [[CacheDataManager alloc]initFile];
    DBModel *model = self.dataArr[indexPath.row];
    [cacheDataManager deleteFileWithName:model.qwz];
        
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
// 交换城市位置
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath{
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    if (self.dataArr.count > fromRow && self.userCityArray.count > toRow && self.userCityArray.count > fromRow && self.dataArr.count > toRow) {
        
        id object = [self.dataArr objectAtIndex:fromRow];
        [self.dataArr removeObjectAtIndex:fromRow];
        [self.dataArr insertObject:object atIndex:toRow];
        
        id cityname = [self.userCityArray objectAtIndex:fromRow];
        [self.userCityArray removeObjectAtIndex:fromRow];
        [self.userCityArray insertObject:cityname atIndex:toRow];
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CityNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOCATIONCELL" forIndexPath:indexPath];

    if (change) {
            DBModel *model = [self.resultArr objectAtIndex:indexPath.row];
            cell.comment.text = @"";
            cell.comment.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTHREE];
            cell.cityName.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTHREE];
            if (languageShows) {
                cell.cityName.text = [NSString stringWithFormat:@"%@ (%@)", model.cityPinyin,model.country_name];
            } else {
                cell.cityName.text = [NSString stringWithFormat:@"%@ (%@,%@)" , model.cityCC, model.cityPinyin, model.country_name];
            }
            for (DBModel * cc in self.dataArr) {
                //定位的城市,通过城市名判断一下,同在杭州,经纬度不同,他们的 'l' 不同
                //定位到城市还没添加进去,或者添加进去了,收个字符为l(定位的城市),则通过经纬度请求,else通过'l'请求
                if ([[cc.qwz substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"qwz"]) {
                    if ([cc.cityCC isEqualToString:model.cityCC]) {
                        cell.comment.text = NSLocalizedString(@"already add", nil);
                        break;
                    }else{
                        cell.comment.text = @"";
                    }
                }
                //非定位的城市, 'l' 判断
                else{
                if ([cc.qwz isEqualToString:model.qwz]) {
                    if ([cc.cityCC isEqualToString:model.cityCC]) {
                        cell.comment.text = NSLocalizedString(@"already add", nil);
                        break;
                    }else{
                         cell.comment.text = @"";
                    }

                }else{
                    cell.comment.text = @"";
                }
                }
            }

    }else{

            DBModel *model = [self.dataArr objectAtIndex:indexPath.row];
            if (!languageShows) {
                if ([Utils isAllChineseInString:model.cityCC]) {
                    cell.cityName.text = [NSString stringWithFormat:@"%@",model.cityCC];
                }else{
                    cell.cityName.text = [NSString stringWithFormat:@"%@(%@,%@)",model.cityCC,model.cityPinyin, model.country_name];
                }

            }else{
                if ([Utils isAllChineseInString:model.cityCC]) {
                    cell.cityName.text = [NSString stringWithFormat:@"%@(%@)",model.cityCC,model.cityPinyin];
                }else{
                    cell.cityName.text = [NSString stringWithFormat:@"%@(%@)",model.cityPinyin, model.country_name];
                }
            }

            if ([model.cityCC isEqualToString:self.locationCityModel.cityCC]) {

                [self setTitleHeaderViewFrameWithShow:NO];
                cell.comment.text = NSLocalizedString(@"location city", nil);

            }else{
                cell.comment.text = @" ";
            }
    }

     [cell.addButton addTarget:self action:@selector(addCity:) forControlEvents:UIControlEventTouchUpInside];
     cell.addButton.tag = 100 + indexPath.row;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (change) {
        return self.resultArr.count;
    }else{
        return self.dataArr.count;
    }
}

- (void)addCity:(UIButton *)button{

    NSInteger index = button.tag - 100;
    change = NO;
    DBModel * model = [self.resultArr objectAtIndex:index];
    self.searchBar.text = @"";
    [self saveCityToDB:model];
}
- (void)addlocalcity{
    // 添加定位城市到城市列表
    [self saveCityToDB:self.locationCityModel];

}

- (void)saveUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userCityArray forKey:@"userCityArray"];
}

- (void)readUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    self.userCityArray = [ NSMutableArray arrayWithArray:[userDefaultes arrayForKey:@"userCityArray"]];
}
@end
