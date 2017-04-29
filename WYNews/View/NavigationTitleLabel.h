//
//  NavigationTitleLabel.h
//  WYNews
//
//  Created by 刘江 on 2017/4/25.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NavigationTitleType){
    Default = 0,
    Highlight
};


@interface NavigationTitleLabel : UILabel

@property (nonatomic) NavigationTitleType navigationTitleType;

- (void)animateToHighlightByFactor:(CGFloat)factor;
- (void)animateToDefaultByFactor:(CGFloat)factor;

@end
