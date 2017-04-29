//
//  HorizontalScroller.h
//  WYNews
//
//  Created by 刘江 on 2017/4/24.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalScroller;

@protocol HorizontalScrollerDelegate <NSObject>

@required
- (NSInteger)numberOfViewsForHorizaontalScroller: (HorizontalScroller *)scroller;
- (UIView *)horizontalScroller: (HorizontalScroller *)scroller viewAtIndex: (NSInteger)index;
- (void)horizontalScroller: (HorizontalScroller *)scroller clickedViewAtIndex: (NSInteger)index;

@optional
- (NSInteger)initialViewIndexForHorizontalScroller: (HorizontalScroller *)scroller;

@end


@interface HorizontalScroller : UIView

@property (weak) id<HorizontalScrollerDelegate> delegate;

@property (assign,nonatomic) NSInteger currentViewIndex;

@property (nonatomic,readonly) NSArray *views;

- (void)reload;

@end
