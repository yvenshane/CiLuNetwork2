//
//  VENHomePageHorizontalCollectionView.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageHorizontalCollectionView.h"
#import "VENHomePageHorizontalCollectionViewCell.h"
#import "VENHomePageModel.h"

@interface VENHomePageHorizontalCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation VENHomePageHorizontalCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 65);
        layout.minimumLineSpacing = 25;
        //        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 25, 10, 25);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.bounds.size.height) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VENHomePageHorizontalCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [self addSubview:collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoriesModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageModel *model = self.categoriesModel[indexPath.row];
    
    VENHomePageHorizontalCollectionViewCell *cell = (VENHomePageHorizontalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cate_icon] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.titleLabel.text = model.cate_name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1] forKey:@"FirstLoading"];
    });
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToClassifyPage" object:indexPath];
    self.block(@"");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
