//
//  LSSTableViewCell.m
//  KimWoodBin-瀑布流
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 Double Lee. All rights reserved.
//

#import "LSSTableViewCell.h"

@implementation LSSTableViewCell
{
    UIImageView * _imageV;
}
//重写cell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview];
    }
    return self;
}
-(void)addSubview{
   _imageV=[[UIImageView alloc]init];
    [self.contentView addSubview:_imageV];
}
// 设置图片的宽高
-(void)setImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height{
    _imageV.image=image;
    _imageV.frame=CGRectMake(0, 0, width, height);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
