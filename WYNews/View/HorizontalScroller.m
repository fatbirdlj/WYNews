//
//  HorizontalScroller.m
//  WYNews
//
//  Created by 刘江 on 2017/4/24.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "HorizontalScroller.h"
#import "NSArray+Index.h"

@interface HorizontalScroller()<UIScrollViewDelegate>
@end

@implementation HorizontalScroller{
    UIScrollView *scroller;
    CGFloat viewWidth;
    CGFloat hightlightViewWidth;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        scroller.showsVerticalScrollIndicator = NO;
        scroller.showsHorizontalScrollIndicator = NO;
        [self addSubview:scroller];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)scrollerTapped:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:gesture.view];
    for (int index=0; index<[self.delegate numberOfViewsForHorizaontalScroller:self]; index++) {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location)) {
            self.currentViewIndex = index;
            [self.delegate horizontalScroller:self clickedViewAtIndex:self.currentViewIndex];
            break;
        }
    }
}

- (void)reload{
    
    if (!self.delegate) return;
    
    [scroller.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSInteger numberOfViews = [self.delegate numberOfViewsForHorizaontalScroller:self];
    
    CGFloat xVlaue = 0;
    NSMutableArray *widths = [[NSMutableArray alloc] init];
    for (int i=0; i< numberOfViews; i++) {
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        [widths addObject:@(view.frame.size.width)];
        view.frame = CGRectMake(xVlaue, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [scroller addSubview:view];
        xVlaue += view.frame.size.width;
    }
    
    
    viewWidth = [[widths objectAtIndex:[widths firstIndexOfNormalValue]] doubleValue];
    
    NSInteger specialValueIndex = [widths indexOfSpecialValue];
    if(specialValueIndex == NSNotFound) hightlightViewWidth = viewWidth;
    else hightlightViewWidth = [[widths objectAtIndex:specialValueIndex] doubleValue];
    
    [scroller setContentSize:CGSizeMake(xVlaue, self.frame.size.height)];
    
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)])
        self.currentViewIndex = [self.delegate initialViewIndexForHorizontalScroller:self];
     else
        self.currentViewIndex = 0;
    [self.delegate horizontalScroller:self clickedViewAtIndex:self.currentViewIndex];
}

#pragma mark - Properties

- (NSArray *)views{
    return scroller.subviews;
}

- (void)setCurrentViewIndex:(NSInteger)currentViewIndex{
    _currentViewIndex = currentViewIndex;
    
    CGFloat xValue = currentViewIndex*viewWidth+hightlightViewWidth/2 - scroller.frame.size.width/2;
    if(xValue < 0) xValue = 0;
    else {
        CGFloat restSpace = scroller.contentSize.width - xValue;
        if(restSpace < scroller.frame.size.width) xValue = scroller.contentSize.width - scroller.frame.size.width;
    }
    [scroller setContentOffset:CGPointMake(xValue, 0) animated:YES];
}

#pragma mark - UIView

- (void)didMoveToSuperview{
    [self reload];
}

@end

