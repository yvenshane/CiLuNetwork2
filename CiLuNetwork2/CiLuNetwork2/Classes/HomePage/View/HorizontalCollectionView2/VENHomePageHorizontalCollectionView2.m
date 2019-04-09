//
//  VENHomePageHorizontalCollectionView2.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageHorizontalCollectionView2.h"
#import "VENHomePageHorizontalCollectionViewCell2.h"
#import "VENHomePageModel.h"

@interface VENHomePageHorizontalCollectionView2 () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray *foundationList;

@end

@implementation VENHomePageHorizontalCollectionView2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *foundationList = [[NSUserDefaults standardUserDefaults] objectForKey:@"metaData"][@"foundationList"];
        
        _foundationList = foundationList;
        
        // title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 50, 22)];
        titleLabel.text = @"基金会";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        [self addSubview:titleLabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(65 + 20, 18, 135, 17)];
        descriptionLabel.text = @"您只能进入所属的基金会";
        descriptionLabel.textColor = UIColorFromRGB(0x999999);
        descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:descriptionLabel];
        
        // CollectionView
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kMainScreenWidth - 20 - 15) / 2.5, 60);
        layout.minimumLineSpacing = 10;
        //        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 52, kMainScreenWidth, 60) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VENHomePageHorizontalCollectionViewCell2 class]) bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
        [self addSubview:collectionView];
        
        // 分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 127, kMainScreenWidth, 10)];
        lineView.backgroundColor = UIColorMake(245, 245, 245);
        [self addSubview:lineView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.foundationList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageHorizontalCollectionViewCell2 *cell = (VENHomePageHorizontalCollectionViewCell2 *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.foundationList[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.titleLabel.text = self.foundationList[indexPath.row][@"name"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.pushToFoundationPageBlock([NSString stringWithFormat:@"%@", self.foundationList[indexPath.row][@"id"]]);
    
    NSLog(@"indexPath - %ld, id - %@", (long)indexPath.row, self.foundationList[indexPath.row][@"id"]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
