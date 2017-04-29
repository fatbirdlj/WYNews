//
//  MainViewController.m
//  WYNews
//
//  Created by 刘江 on 2017/4/27.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "MainViewController.h"
#import "HorizontalScroller.h"
#import "NavigationTitleLabel.h"

@interface MainViewController ()<HorizontalScrollerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) HorizontalScroller *navigationScroller;
@property (copy,nonatomic) NSArray *navigationTitles;
@property (copy,nonatomic) NSArray *controllerIdentities;
@property (strong,nonatomic) NSMutableArray *views;
@property (assign,nonatomic) BOOL isClickEvent;
@end

@implementation MainViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - Properties

- (NSArray *)navigationTitles{
    if (!_navigationTitles) {
        _navigationTitles = [NSArray arrayWithObjects:@"头条", @"视频", @"娱乐", @"体育", @"广州", @"网易号",
                             @"财经", @"科技", @"手机", nil];
    }
    return _navigationTitles;
}

- (NSArray *)controllerIdentities{
    if (!_controllerIdentities) {
        _controllerIdentities = [NSArray arrayWithObjects:@"HeadLine",@"Video",@"HeadLine",@"Video",@"HeadLine",@"Video",@"HeadLine",@"Video",@"HeadLine",nil];
    }
    return _controllerIdentities;
}

- (HorizontalScroller *)navigationScroller{
    if (!_navigationScroller) {
        _navigationScroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 40)];
        _navigationScroller.delegate = self;
    }
    return _navigationScroller;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = nil;
        _collectionView.bounces = false;
        _collectionView.pagingEnabled = YES;
        _collectionView.directionalLockEnabled = YES;
        _collectionView.bouncesZoom = NO;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray *)views{
    if (!_views) {
        _views = [[NSMutableArray alloc] init];
    }
    return _views;
}

#pragma mark - Initialize

- (void)initializeControllers{
    for (NSString *identity in self.controllerIdentities) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identity];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60);
        [vc didMoveToParentViewController:self];
        [self.views addObject:vc.view];
    }
}

#pragma mark - HorizontalScroller

- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(NSInteger)index{
    NavigationTitleLabel *titleLabel= [[NavigationTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    titleLabel.text = self.navigationTitles[index];
    return titleLabel;
}

- (NSInteger)numberOfViewsForHorizaontalScroller:(HorizontalScroller *)scroller{
    return [self.navigationTitles count];
}

- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(NSInteger)index{
    self.isClickEvent = YES;
    [self hightLightNavigationTitleAtIndex:index];

    if ([[self.collectionView visibleCells] count] == 0) {
        self.isClickEvent = NO;
    } else {
        [self.collectionView scrollRectToVisible:CGRectMake(self.view.bounds.size.width*index, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)
                                        animated:YES];
    }
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigationScroller];
    [self initializeControllers];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.views count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell.contentView addSubview:self.views[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-60);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.isClickEvent && [scrollView isKindOfClass:[UICollectionView class]]) {
        CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
        CGFloat magnification = scrollView.contentOffset.x / self.view.bounds.size.width;
        CGFloat factor;
        NSInteger fromIndex,toIndex;
        if (magnification == trunc(magnification)) {
            [self hightLightNavigationTitleAtIndex:magnification];
        } else {
            // scroll right
            if (translation.x<0) {
                fromIndex = trunc(magnification);
                toIndex = fromIndex + 1;
                factor = magnification - trunc(magnification);
            } else {
                toIndex = trunc(magnification);
                fromIndex = toIndex + 1;
                factor = 1 - (magnification - trunc(magnification));
            }
            NavigationTitleLabel *currentNavigationTitle = self.navigationScroller.views[fromIndex];
            [currentNavigationTitle animateToDefaultByFactor:factor];
            NavigationTitleLabel *targetNavigationTitle = self.navigationScroller.views[toIndex];
            [targetNavigationTitle animateToHighlightByFactor:factor];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        NSInteger index = round(scrollView.contentOffset.x / self.view.bounds.size.width);
        self.navigationScroller.currentViewIndex = index;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.isClickEvent = NO;
}


- (void)hightLightNavigationTitleAtIndex:(NSInteger)index{
    for (int i=0; i<[self.navigationTitles count]; i++) {
        NavigationTitleLabel *navigationTitle = self.navigationScroller.views[i];
        if (i == index) {
            navigationTitle.navigationTitleType = Highlight;
        } else {
            navigationTitle.navigationTitleType = Default;
        }
    }
}
@end
