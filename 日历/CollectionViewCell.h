//
//  CollectionViewCell.h
//  日历
//
//  Created by 韩冲 on 2016/9/19.
//  Copyright © 2016年 韩冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)NSString *date;
@property (nonatomic,assign)BOOL today;
@property (nonatomic,assign)BOOL change;

-(void)toDayAnm;
-(void)otherDayAnm;

@end
