//
//  XYZHeroTableViewCell.m
//  TableDemo
//
//  Created by 史江凯 on 15/5/11.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//FC8A8F0215C88437AEB851C64688EB8E

#import "XYZHeroTableViewCell.h"

@implementation XYZHeroTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
