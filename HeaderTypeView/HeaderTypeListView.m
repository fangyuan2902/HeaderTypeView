//
//  HeaderTypeListView.m
//  HeaderTypeView
//
//  Created by yuanfang on 2018/7/23.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

#import "HeaderTypeListView.h"
#import "Masonry.h"

@implementation NSString (StringSize)

- (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)size {
    NSDictionary*attrs =@{NSFontAttributeName:font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGSize)sizeWithString:(NSString*)str font:(UIFont*)font maxSize:(CGSize)size{
    NSDictionary*attrs =@{NSFontAttributeName:font};
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs  context:nil].size;
}

@end

@interface HeaderTypeListView ()

/**
 *  按钮标题数组
 */
@property (nonatomic, strong) NSMutableArray *buttonTitles;

/**
 *  所以按钮文字宽度总和
 */
@property (nonatomic, assign) CGFloat totalButtonWidth;

/**
 *  当前间隙
 */
@property (nonatomic, assign) CGFloat currentSpace;


@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  选中索引
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 *  底部
 */
@property (nonatomic, strong) UIImageView *bgImage;

/**
 *  选择线条
 */
@property (nonatomic, strong) UIImageView *selectImage;

@end

@implementation HeaderTypeListView

- (instancetype)initWithFrame:(CGRect)frame ButtonTitles:(NSArray *)buttonTitles {
    self = [super initWithFrame:frame];
    if (self) {
        _bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbgImage"]];
        _bgImage.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_bgImage];
        [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
        
        _scrollView = UIScrollView.new;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.delaysContentTouches = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topselectImage"]];
        [self addSubview:_selectImage];
        
        _buttonTitles = [NSMutableArray arrayWithArray:buttonTitles];
        _buttons = [NSMutableArray arrayWithCapacity:0];
        
        _totalButtonWidth = 0;
        _minSpace = 30;
        _currentSpace = 0;
        _selectIndex = -1;
    }
    return self;
}

- (void)didMoveToSuperview {
    [self createButtons];
}

- (void)layoutSubviews {
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
}

- (void)createButtons {
    //创建button
    for (NSUInteger i = 0; i<_buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
        [button setTitle:_buttonTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = _buttonTitleFont;
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
        
        _totalButtonWidth = _totalButtonWidth + [_buttonTitles[i] sizeWithFont:_buttonTitleFont maxSize:self.frame.size].width;
        
        [_scrollView addSubview:button];
    }
    
    //默认选中第一个
    UIButton *button = _buttons[0];
    button.selected = YES;
    _selectIndex = 0;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    for (UIButton *button in _buttons) {
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
    }
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    for (UIButton *button in _buttons) {
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
    }
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    for (UIButton *button in _buttons) {
        button.titleLabel.font = _buttonTitleFont;
    }
}

- (void)selectButton:(UIButton *)button {
    if (_selectIndex == -1 ||_selectIndex > _buttons.count) {
        _selectIndex = [_buttons indexOfObject:button];
        button.selected = YES;
    } else {
        if (_selectIndex < _buttons.count) {
            UIButton *lastButton = [_buttons objectAtIndex:_selectIndex];
            lastButton.selected = NO;
            
            _selectIndex = [_buttons indexOfObject:button];
            button.selected = YES;
            [self scrollToButton:button];
            //更新约束
            UIButton *button = _buttons[_selectIndex];
            [_selectImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(button.mas_bottom).offset(0);
                make.centerX.equalTo(button.mas_centerX);
                make.width.equalTo(@5);
                make.height.equalTo(@5);
            }];
            
            [UIView animateWithDuration:0.4 animations:^{
                [self layoutIfNeeded];
            }];
        }
    }
}

- (void)selectButtonAtIndex:(NSInteger)index {
    if(index >=0 && index<_buttons.count) {
        UIButton *button = _buttons[index];
        [self selectButton:button];
    }
}
//重写父类方法
- (void)updateConstraints {
    UIButton *lastButton;
    //获取合适间隙
    CGFloat space;
    if ((self.frame.size.width - _totalButtonWidth)/_buttons.count > _minSpace) {
        space = (self.frame.size.width - _totalButtonWidth)/_buttons.count;
    } else {
        space = _minSpace;
    }
    
    //间距不改变的情况下
    if (_currentSpace != space) {
        _currentSpace = space;
        //添加约束
        for (UIButton *button in _buttons) {
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastButton?lastButton.mas_right:@0);
                make.height.mas_equalTo(40);
                make.bottom.equalTo(self);
                make.width.equalTo(@(_currentSpace + [button.titleLabel.text sizeWithFont:_buttonTitleFont maxSize:self.frame.size].width));
            }];
            lastButton =  button;
        }
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastButton);
        }];
        
        UIButton *button = _buttons[_selectIndex];
        [_selectImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button.mas_bottom).offset(0);
            make.centerX.equalTo(button.mas_centerX);
            make.width.equalTo(@5);
            make.height.equalTo(@5);
        }];
    }
    [super updateConstraints];
}

- (void)scrollToButton:(UIButton *)button {
    //当前偏移量
    CGFloat offsetX = _scrollView.contentOffset.x;
    //scrollview的X
    CGFloat scrollCenterX = _scrollView.center.x;
    //scrollview的width
    CGFloat scrollWidth = _scrollView.frame.size.width;
    //ContentSize的With
    CGFloat contentSizeWidth = _scrollView.contentSize.width;
    //button的centerX
    CGFloat buttonCenterX = button.center.x;
    //需要偏移距离
    CGFloat needOffsetX = buttonCenterX - offsetX - scrollCenterX;
    //右边可移动距离
    CGFloat canOffsetX = contentSizeWidth - offsetX - scrollWidth;
    
    if (needOffsetX > 0) {//往左移
        CGFloat moveLength = MIN(ABS(needOffsetX), ABS(canOffsetX));
        [_scrollView setContentOffset:CGPointMake(offsetX + moveLength, 0) animated:YES];
    } else {//往右移
        CGFloat moveLength = MIN(ABS(needOffsetX), ABS(offsetX));
        [_scrollView setContentOffset:CGPointMake(offsetX - moveLength, 0) animated:YES];
    }
}

@end

