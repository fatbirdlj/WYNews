//
//  NavigationTitleLabel.m
//  WYNews
//
//  Created by 刘江 on 2017/4/25.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "NavigationTitleLabel.h"

@implementation NavigationTitleLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
    }
    return  self;
}

- (void)setNavigationTitleType:(NavigationTitleType)navigationTitleType{
    
    _navigationTitleType = navigationTitleType;
    
    if (navigationTitleType == Default) {
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:16];
    } else {
        self.textColor = [UIColor redColor];
        self.font = [UIFont systemFontOfSize:20];
    }
}

- (NSString *)description{
    return self.text;
}

/* factor is from 0 to 1 */
- (void)animateToHighlightByFactor:(CGFloat)factor{
    self.textColor = [UIColor colorWithRed:factor green:0 blue:0 alpha:1];
    self.font = [UIFont systemFontOfSize:16+4*factor];
}

/* factor is from 0 to 1 */
- (void)animateToDefaultByFactor:(CGFloat)factor{
    self.textColor = [UIColor colorWithRed:1-factor green:0 blue:0 alpha:1];
    self.font = [UIFont systemFontOfSize:20-4*factor];
}

@end
