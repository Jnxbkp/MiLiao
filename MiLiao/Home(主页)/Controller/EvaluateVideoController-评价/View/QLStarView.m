//
//  SareView.m
//  SongQiMall
//
//  Created by king on 2017/3/6.
//  Copyright © 2017年 king. All rights reserved.
//

#import "QLStarView.h"

@interface QLStarView ()
@property (nonatomic, strong) NSArray *starButtonArray;

@end

@implementation QLStarView
{
    SelectedStart _startBlock;
}

static CGFloat _starNum = 5;//星星的个数


- (instancetype)initWithFrame:(CGRect)frame defaultImageName:(NSString *)defaultImageName hightLightImageName:(NSString *)hightLightImageName selectedStart:(SelectedStart)start {
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultImageName = defaultImageName;
        self.lightImageName = hightLightImageName;
        _startBlock = start;
        [self createStarView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createStarView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createStarView];
    
}

- (void)setAllSelected:(BOOL)allSelected {
    _allSelected = allSelected;
    if (allSelected) {
        [self.starButtonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = allSelected;
        }];
    }
}

- (void)setStarClickEnable:(BOOL)starClickEnable {
    _starClickEnable = starClickEnable;
    [self.starButtonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = starClickEnable;
    }];
}

- (void)getSelectedStar:(SelectedStart)star {
    _startBlock = star;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width / _starNum;
    CGFloat height = self.bounds.size.height;
    [self.starButtonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(width * idx, 0, width, height);
    }];
}

- (void)createStarView {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _starNum; i++) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [starButton setAdjustsImageWhenHighlighted:NO];
        UIImage *normalImage = self.defaultImage ? self.defaultImage : [UIImage imageNamed:self.defaultImageName];
        UIImage *selectedImage = self.lightImage ? self.lightImage : [UIImage imageNamed:self.lightImageName];
        [starButton setImage:normalImage forState:UIControlStateNormal];
        [starButton setImage:selectedImage forState:UIControlStateSelected];
        [mutableArray addObject:starButton];
        starButton.enabled = self.isStarClickEnable;
        starButton.selected = self.isAllSelecetd;
        [starButton addTarget:self action:@selector(starButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:starButton];
    }
    self.starButtonArray = [mutableArray copy];
}

- (void)starButtonClick:(UIButton *)sender {
    NSInteger index = [self.starButtonArray indexOfObject:sender];
    
    if (index == self.starButtonArray.count-1) {//点击的最后一个
        sender.selected = !sender.isSelected;//反转其选中状态
        if (sender.selected) {//如果反转后 是选中状态 则将全部设为选中
            for (UIButton *start in self.starButtonArray) {
                start.selected = YES;
            }
        }
    } else {
        //不是最后一个
        //拿到点击的下一个星星
        UIButton *nextStart = self.starButtonArray[index+1];
        //如果下一个星星是点中的,则将其以后的全部设为非选中
        if (nextStart.isSelected) {
            for (NSInteger i = index + 1; i < self.starButtonArray.count; i++) {
                UIButton *start = self.starButtonArray[i];
                start.selected = NO;
            }
        }
        else {
            //将点中的星星状态反转
            sender.selected = !sender.isSelected;
            if (sender.isSelected) {//如果反转以后是选中状态则将其之前的星星 设为选中状态
                for (NSInteger i = 0; i<index; i++) {
                    UIButton *start = self.starButtonArray[i];
                    start.selected = YES;
                }
            }
            
        }
        
    }
    sender.isSelected?(index++):(index);
    !_startBlock?:_startBlock(index);
    if (self.delegate) {
        [self.delegate clickIndex:index];
    }
}


@end
