//
//  ViewController.m
//  HeaderTypeView
//
//  Created by yuanfang on 2018/7/23.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

#import "ViewController.h"
#import "HeaderTypeListView.h"
#import "PageViewController.h"
#import "Masonry.h"
#import "DeatilViewController.h"

@interface ViewController () <PageControllerDataSource, PageControllerDataDelegate>

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) PageViewController *pageViewController;

/**
 *  选择类型
 */
@property (nonatomic, strong) HeaderTypeListView *scroll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self) weakSelf = self;
    
    //创建存放内容视图
    self.container = [UIView new];
    [self.view addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.mas_topLayoutGuideBottom).offset(0);
        make.bottom.equalTo(weakSelf.view).offset(0);
    }];
    
    self.scroll = [[HeaderTypeListView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44) ButtonTitles:@[@"第一",@"第二",@"第三"]];
    self.scroll.backgroundColor = [UIColor whiteColor];
    self.scroll.buttonTitleFont = [UIFont systemFontOfSize:16];
    self.scroll.normalColor = [UIColor whiteColor];
    self.scroll.selectedColor = [UIColor whiteColor];
    [self.view addSubview:self.scroll];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuideBottom);
        make.left.right.equalTo(weakSelf.view);
        if ([[UIScreen mainScreen] bounds].size.width == 812) {
            make.height.equalTo(@88);
        } else {
            make.height.equalTo(@64);
        }
    }];
    
    weakSelf.pageViewController = [[PageViewController alloc] init];
    weakSelf.pageViewController.pDataSource = self;
    weakSelf.pageViewController.pDataDelegate = self;
    [weakSelf.pageViewController reloadPages];
}

#pragma mark -RDPageControllerDataSource

- (NSArray *)pageButtons
{
    return _scroll.buttons;
}

- (NSArray *)pageControllers
{
    NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i< 3; i++) {
        DeatilViewController *vc = [DeatilViewController new];
        vc.view.backgroundColor = [UIColor colorWithRed:0.2*i green:0.5*i blue:0.3*i alpha:1.0];
        [vcArray addObject:vc];
    }
    return vcArray;
}

- (UIView *)pageContainer
{
    return _container;
}

#pragma mark -RDDataDelegate
//手势切换才会调用
- (void)pageChangedToIndex:(NSInteger)index
{
    [_scroll selectButtonAtIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
