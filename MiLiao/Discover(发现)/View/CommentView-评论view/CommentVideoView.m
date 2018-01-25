//
//  CommentVideoView.m
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "CommentVideoView.h"
#import "CommentVideoTableViewCell.h"

@interface CommentVideoView ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end


static NSString *CellID_CommentVideoTableViewCell = @"CommentVideoTableViewCell";

@implementation CommentVideoView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:CellID_CommentVideoTableViewCell bundle:nil] forCellReuseIdentifier:CellID_CommentVideoTableViewCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    
}

+ (instancetype)CommentVideoView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (IBAction)maskButtonClick:(id)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.y = ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
