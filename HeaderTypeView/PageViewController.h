//
//  PageViewController.h
//  HeaderTypeView
//
//  Created by yuanfang on 2018/7/23.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageMode) {
    FreeButtons,
    LeftRightArrows,
    SegmentController
};

@protocol PageControllerDataSource;
@protocol PageControllerDataDelegate;

@interface PageViewController : UIPageViewController

@property (nonatomic, assign) id<PageControllerDataSource>   pDataSource;
@property (nonatomic, assign) id<PageControllerDataDelegate> pDataDelegate;

@property (nonatomic, assign) PageMode                           pageMode;     // This selects the mode of the PageViewController

- (void)reloadPages;                                                        // Like reloadData in tableView. You need to call this method to update the stack of viewcontrollers and/or buttons
- (void)reloadPagesToCurrentPageIndex:(NSInteger)currentPageIndex;          // Like reloadData in tableView. You need to call this method to update the stack of viewcontrollers and/or buttons

- (void)moveToViewNumber:(NSInteger)viewNumber __attribute__((deprecated));                // Default to YES. Deprecated.
- (void)moveToViewNumber:(NSInteger)viewNumber animated:(BOOL)animated;     // The ViewController position. Starts from 0

@end

@protocol PageControllerDataSource <NSObject>

@required
- (NSArray *)pageButtons;
- (NSArray *)pageControllers;
- (UIView *)pageContainer;
@optional
- (void)otherConfiguration; 

@end

@protocol PageControllerDataDelegate <NSObject>

@optional
- (void)pageChangedToIndex:(NSInteger)index;

@end

