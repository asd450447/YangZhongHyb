//
//  DevUITableViewCell.m
//  YangZhongHyb
//
//  Created by mao ke on 2017/5/25.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "DevUITableViewCell.h"

@implementation DevUITableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
