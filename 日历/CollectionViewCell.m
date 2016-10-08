//
//  CollectionViewCell.m
//  日历
//
//  Created by 韩冲 on 2016/9/19.
//  Copyright © 2016年 韩冲. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (nonatomic,strong)UILabel *show;
@property (nonatomic,strong)UIView *back;

@end

@implementation CollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCol) name:@"cal" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defult) name:@"defult" object:nil];

    }
    return self;
}
-(UIView *)back{
    if (_back==nil) {
        _back=[UIView new];
        _back.layer.cornerRadius=15;
        _back.layer.masksToBounds=YES;
        
    }
    return _back;
}
-(UILabel *)show{
    if (_show==nil) {
        _show=[UILabel new];
        _show.textAlignment=NSTextAlignmentCenter;
    }
    return _show;
}
-(void)setDate:(NSString *)date{
    _date=date;
    self.show.text=date;
    [self.contentView addSubview:self.back];
    [self.contentView addSubview:self.show];
}
-(void)setToday:(BOOL)today{
    _today=today;
    if (today==YES) {
        self.show.textColor=[UIColor redColor];

    }else{
        self.show.textColor=[UIColor blackColor];
   }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.show.frame=CGRectMake(0, self.contentView.frame.size.height/2, self.contentView.frame.size.width, self.contentView.frame.size.height/2);
    self.show.center=CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
    self.back.frame=CGRectMake(0, 0, 30, 30);
    self.back.center=CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);

}
-(void)toDayAnm{
    [UIView animateWithDuration:0.2 animations:^{
        self.back.backgroundColor=[UIColor blueColor];
        self.show.textColor=[UIColor whiteColor];
    } completion:^(BOOL finished) {
        self.change=NO;
        ;
    }];
    

    

}
-(void)otherDayAnm{
    [UIView animateWithDuration:0.2 animations:^{
        self.back.backgroundColor=[UIColor yellowColor];
        self.show.textColor=[UIColor lightGrayColor];;
    } completion:^(BOOL finished) {
        self.change=NO;
;
    }];

    
}

-(void)toDayAnm1{
    [UIView animateWithDuration:0.2 animations:^{
        self.back.backgroundColor=[UIColor whiteColor];
        self.show.textColor=[UIColor redColor];
    }];
    
    
}
-(void)otherDayAnm1{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.back.backgroundColor=[UIColor whiteColor];
        self.show.textColor=[UIColor blackColor];
    }];
    
}

-(void)changeCol{
    if (self.change==NO) {
        if (self.today) {
            [self toDayAnm1];
        }else{
            [self otherDayAnm1];
        }
    }

}
-(void)defult{
    if (self.today) {
        [self toDayAnm1];
    }else{
        [self otherDayAnm1];
    }
}
@end
