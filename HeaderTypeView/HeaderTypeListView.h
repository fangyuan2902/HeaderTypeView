//
//  HeaderTypeListView.h
//  HeaderTypeView
//
//  Created by yuanfang on 2018/7/23.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTypeListView : UIView

/**
 *  正常颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 *  选中颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 *  按钮字体
 */
@property (nonatomic, strong) UIFont *buttonTitleFont;

/**
 *  最小间隙
 */
@property (nonatomic, assign) CGFloat minSpace;

/**
 *  按钮数组
 */
@property (nonatomic, readonly) NSMutableArray<UIButton *> *buttons;

- (instancetype)initWithFrame:(CGRect)frame ButtonTitles:(NSArray *)buttonTitles;

/**
 *  选择指定按钮
 *
 *  @param index 按钮索引
 */
- (void)selectButtonAtIndex:(NSInteger)index;

@end

