//
//  ViewController.m
//  日历
//
//  Created by 韩冲 on 2016/9/19.
//  Copyright © 2016年 韩冲. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    NSInteger _index;
    BOOL _firstShow;
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSDate  *currDate;
@property (nonatomic,strong)NSDate  *today;
@property (nonatomic,assign)NSInteger  allDays;
@property (nonatomic,assign)NSInteger  firstDay;
@property (nonatomic,strong)UILabel  *currDateLab;
@property (nonatomic,strong)UIButton  *nextMouth;
@property (nonatomic,strong)UIButton  *leftMouth;
@property (nonatomic,strong)NSArray  *titleArr;

@end

@implementation ViewController
-(NSDate *)today{
    if (_today==nil) {
        _today=[NSDate date];
    }
    return _today;
}
-(NSArray *)titleArr{
    if (_titleArr==nil) {
        _titleArr=[NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六",nil];
    }
    return _titleArr;
}
-(UIButton *)nextMouth{
    if (_nextMouth==nil) {
        _nextMouth=[UIButton buttonWithType:UIButtonTypeSystem];
        [_nextMouth setTitle:@"下个月" forState:UIControlStateNormal];
        _nextMouth.frame=CGRectMake(0, 280, self.view.frame.size.width, 30);
        [_nextMouth addTarget:self action:@selector(gotoNextMouth) forControlEvents:UIControlEventTouchUpInside];

    }
    return _nextMouth;
}
-(UIButton *)leftMouth{
    if (_leftMouth==nil) {
        _leftMouth=[UIButton buttonWithType:UIButtonTypeSystem];
        [_leftMouth setTitle:@"上个月" forState:UIControlStateNormal];
        _leftMouth.frame=CGRectMake(0, 310, self.view.frame.size.width, 30);
        [_leftMouth addTarget:self action:@selector(gotoLeftMouth) forControlEvents:UIControlEventTouchUpInside];

    }
    return _leftMouth;
}
-(void)gotoLeftMouth{
   
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.currDate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:-1];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self.currDate options:0];
    
    self.currDate=newdate;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"defult" object:nil];
    
    [self relode];

}
-(void)gotoNextMouth{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.currDate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:+1];
    
    [adcomps setDay:0];
    
    
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self.currDate options:0];
    
    self.currDate=newdate;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"defult" object:nil];

    [self relode];
}
-(void)relode{
    _index=1;
    _firstShow=YES;
    self.collectionView.frame=CGRectMake(0, 60, self.view.frame.size.width, (self.allDays/7+2)*30);
    self.currDateLab.text=[self getStrDate];
    self.allDays =  [self totaldaysInThisMonth:self.currDate];
    self.firstDay = [self firstWeekdayInThisMonth:self.currDate];
    [self.collectionView reloadData];
    
    CATransition *anim =[CATransition animation];
    anim.type =@"pageCurl";
    anim.duration=0.5;
    [self.collectionView.layer addAnimation:anim forKey:nil];
}

-(UILabel *)currDateLab{
    if (_currDateLab==nil) {
        _currDateLab=[UILabel new];
        _currDateLab.textAlignment=NSTextAlignmentCenter;
        _currDateLab.frame=CGRectMake(0, 250, self.view.frame.size.width, 30);
    }
    return _currDateLab;
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing=0;
        flowLayout.minimumInteritemSpacing=0;
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.bounces=NO;
        _collectionView.scrollEnabled=NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.currDate=[NSDate date];
    [self addTitle];
    _firstShow=YES;
    _index=1;
    self.currDateLab.text=[self getStrDate];
    self.allDays =  [self totaldaysInThisMonth:self.currDate];
    self.firstDay = [self firstWeekdayInThisMonth:self.currDate];
    
    self.collectionView.frame=CGRectMake(0, 60, self.view.frame.size.width, (self.allDays/7+1)*30);

    
    [self.view addSubview:self.currDateLab];
    
    [self.view addSubview:self.leftMouth];
    [self.view addSubview:self.nextMouth];
    //注册Cell，必须要有
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionView];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)addTitle{
    float w=self.view.frame.size.width/7;
    
    for (int i=0; i<self.titleArr.count; i++) {
        UILabel *l=[UILabel new];
        l.frame=CGRectMake(i*w, 35, w, 20);
        l.text=self.titleArr[i];
        l.textAlignment=NSTextAlignmentCenter;
        l.font=[UIFont systemFontOfSize:12];
        if (i==0||i==6) {
            l.textColor=[UIColor redColor];
        }else{
            l.textColor=[UIColor grayColor];
        }
        [self.view addSubview:l];
    }

}

-(NSString *)getStrDate{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateString=[dateFormatter stringFromDate:self.currDate];
    return currentDateString;

}
-(NSString *)getTodayStr:(NSDate *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *showDateStr=[dateFormatter stringFromDate:date];
    return showDateStr;
    
}

-(NSString *)getDay:(NSDate *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *day=[dateFormatter stringFromDate:self.today];
    return day;
    
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allDays+self.firstDay;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.date=@"";
    cell.today=NO;
    //判断显示日期数
    if (_firstShow==YES) {
        if (self.firstDay==0) {
            cell.date=@"1";
            _index++;
            _firstShow=NO;
        }else if (self.firstDay==indexPath.row){
            cell.date=@"1";
            _index++;
            _firstShow=NO;
        }
    }else{
        if (_index<=self.allDays) {
            cell.date=[NSString stringWithFormat:@"%d",_index];
            _index++;
        }
    
    }
    

    //当前日期显示红色
    if ([[self getTodayStr:self.today] isEqualToString:[self getTodayStr:self.currDate]]) {
        if ([[self getDay:self.today] intValue] +self.firstDay-1 ==indexPath.row) {
            cell.today=YES;
        }
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/7, 30);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionViewCell * cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.change=YES;
    
    if (cell.today) {
        [cell toDayAnm];
    }else{
        [cell otherDayAnm];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cal" object:nil];
    
}

@end
