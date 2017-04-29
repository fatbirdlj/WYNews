//
//  HeadLineViewController.m
//  WYNews
//
//  Created by 刘江 on 2017/4/27.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "HeadLineViewController.h"

@interface HeadLineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HeadLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
