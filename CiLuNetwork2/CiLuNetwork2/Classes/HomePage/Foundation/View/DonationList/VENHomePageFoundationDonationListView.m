//
//  VENHomePageFoundationDonationListView.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/14.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageFoundationDonationListView.h"
#import "VENHomePageFoundationDonationListViewTableViewCell.h"
#import "VENHomePageModel.h"

@interface VENHomePageFoundationDonationListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENHomePageFoundationDonationListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"捐赠动态";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        [self addSubview:titleLabel];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 30;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"VENHomePageFoundationDonationListViewTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        [self addSubview:tableView];
        
        _titleLabel = titleLabel;
        _tableView = tableView;
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.donationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageFoundationDonationListViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENHomePageModel *model = self.donationList[indexPath.row];

    cell.nameLabel.text = model.name;
    cell.dateLabel.text = model.date_time;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"捐赠%@", model.amount]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, model.amount.length)];
    
    cell.priceLabel.attributedText = attributedString;
    
    
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(15, 15, kMainScreenWidth - 30, 22);
    self.tableView.frame = CGRectMake(0, 52, kMainScreenWidth, self.donationList.count * 30);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
