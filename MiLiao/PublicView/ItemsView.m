//
//  ItemsView.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/2.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "ItemsView.h"
#import "NSStringSize.h"

#define itemButtonTag       1000
@implementation ItemsView

- (instancetype)initWithFrame:(CGRect)frame itemArr:(NSArray *)itemArr {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//字典数组
- (void)setItemsDicArr:(NSArray *)itemArr {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemArr = itemArr;
    CGFloat w = 12;
    CGFloat h = 0;
    
    for (int i = 0; i < itemArr.count; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.tag = itemButtonTag+i;
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize buttonSize = [NSStringSize getNSStringHeight:[itemArr[i] objectForKey:@"tagName"] Font:11.0];
        
        itemButton.backgroundColor = [ToolObject getColorStr:[itemArr[i] objectForKey:@"tagColor"]];
        [itemButton setTitleColor:Color255 forState:UIControlStateNormal];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [itemButton setTitle:[itemArr[i] objectForKey:@"tagName"] forState:UIControlStateNormal];
        itemButton.layer.cornerRadius = 12;
        
        itemButton.frame = CGRectMake(w, h, buttonSize.width+20 , 24);
        if(w + buttonSize.width + 24 > WIDTH){
            w = 12;
            h = h + itemButton.frame.size.height + 12;
            itemButton.frame = CGRectMake(w, h, buttonSize.width+20, 24);
        }
        
        w = itemButton.frame.size.width + itemButton.frame.origin.x+12;
        
        if (i == itemArr.count-1) {
            self.itemsViewHeight = itemButton.frame.origin.y+24;
            self.itemsViewWidth = itemButton.frame.origin.x+itemButton.frame.size.width;
        }
        [self addSubview:itemButton];
    }
}
//传过来str
- (void)setItemStr:(NSString *)str {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *array = [str componentsSeparatedByString:@","];
    CGFloat w = 12;
    CGFloat h = 0;
    
    for (int i = 0; i < array.count; i++) {
        NSArray *strArr = [array[i] componentsSeparatedByString:@":"];
        if (strArr.count == 2) {
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            itemButton.tag = itemButtonTag+i;
            [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            CGSize buttonSize = [NSStringSize getNSStringHeight:strArr[1] Font:11.0];
            
            itemButton.backgroundColor = [ToolObject getColorStr:strArr[0]];
            [itemButton setTitleColor:Color255 forState:UIControlStateNormal];
            itemButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
            NSLog(@"------------%@---%@",strArr[0],strArr[1]);
            [itemButton setTitle:strArr[1] forState:UIControlStateNormal];
            itemButton.layer.cornerRadius = 12;
            
            itemButton.frame = CGRectMake(w, h, buttonSize.width+20 , 24);
            if(w + buttonSize.width + 24 > WIDTH){
                w = 12;
                h = h + itemButton.frame.size.height + 12;
                itemButton.frame = CGRectMake(w, h, buttonSize.width+20, 24);
            }
            
            w = itemButton.frame.size.width + itemButton.frame.origin.x+12;
            
            if (i == array.count-1) {
                self.itemsViewHeight = itemButton.frame.origin.y+24;
                self.itemsViewWidth = itemButton.frame.origin.x+itemButton.frame.size.width;
            }
            [self addSubview:itemButton];
        }
       
    }
    
}
- (void)itemButtonClick:(UIButton *)itemButton {
    
}
@end
