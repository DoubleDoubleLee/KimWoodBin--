//
//  ViewController.m
//  KimWoodBin-瀑布流
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 Double Lee. All rights reserved.
//
#define IMAGE_WIDTH ([UIScreen mainScreen].bounds.size.width-GAP*3)/4
#define GAP 5
#import "ViewController.h"
#import "LSSTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableV;
    NSMutableArray * _dataSource;//存储所有需要使用到得图片
    NSMutableArray * _FourTableVDataSource;//存储四个tableV的数据源
    NSMutableArray * _tableVArr;//存储四个tableV;
    CGFloat _imageHeight[4];//记录当前tableV上图片的高度
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //1.实例化数据源
    [self initDataSource];
    //2.把所有的图片都分配给四个tableV
    [self initEachDataSource];
    //3.展示
    [self createUI];
}
#pragma mark--1.实例化数据源
-(void)initDataSource{
    _dataSource=[[NSMutableArray alloc]init];
    for (int i=0; i<300; i++) {
        NSString * imageName=[NSString stringWithFormat:@"%.2d.jpg",i%16];
        UIImage * image=[UIImage imageNamed:imageName];
        [_dataSource addObject:image];
    }
}
#pragma mark--配置每个tableV的数据源图片
-(void)initEachDataSource{
    //1.实例化装有四个数据源的大数据源
    _FourTableVDataSource=[[NSMutableArray alloc]init];
    //2.创建四个tableV对应的数据源
    for (int i=0; i<4; i++) {
         NSMutableArray * subDataSource=[[NSMutableArray alloc]init];
        [_FourTableVDataSource addObject:subDataSource];
    }
    //3.分配图片
    for (UIImage * image in _dataSource) {
        //1.拿到数据源中所有图片高度最短的那个数据源
        NSMutableArray * shortDataArr=[self shortDataSource];
        //2.将图片添加到这个数据源中
        [shortDataArr addObject:image];
        //3.更新当前tableV的所有图片高度
        [self updateImageHeight:shortDataArr];
    }
}
-(NSMutableArray *)shortDataSource{
    //假设第一个tableV上的所有图片高度最低 记录他的高度
    CGFloat shortHeight=_imageHeight[0];
    //记录下标 指明最低的那个是哪一个tableView
    int min=0;
    //找到图片整体最低的那个数据源
    for ( int i=0; i<4; i++) {
        if (_imageHeight[i]<shortHeight) {
            shortHeight=_imageHeight[i];
            min=i;
        }
    }
    return _FourTableVDataSource[min];
}
-(void)updateImageHeight:(NSMutableArray *)shortDataSource{
  //拿到最低数据源的位置
    NSInteger index=[_FourTableVDataSource indexOfObject:shortDataSource];
    //取到最后的一张图片
    UIImage *image=[shortDataSource lastObject];
    //更新高度
    _imageHeight[index] += [self imageHeightWithImage:image];
}
-(CGFloat)imageHeightWithImage:(UIImage *)image{
    return image.size.height*IMAGE_WIDTH/image.size.width;
}
#pragma mark--创建视图
-(void)createUI{
    _tableVArr=[[NSMutableArray alloc]init];
    for (int i=0; i<4; i++) {
        _tableV=[[UITableView alloc]initWithFrame:CGRectMake((IMAGE_WIDTH+GAP)*i , 0, IMAGE_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableV.dataSource=self;
        _tableV.delegate=self;
        _tableV.showsVerticalScrollIndicator=NO;
        [self.view addSubview:_tableV];
        //将tableView添加到数组中
        [_tableVArr addObject:_tableV];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //1.拿到当前tableView的索引
    NSInteger index=[_tableVArr indexOfObject:tableView];
    //2.拿到这个tableView的数据源
    NSMutableArray * dataArr=_FourTableVDataSource[index];
    return dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index=[_tableVArr indexOfObject:tableView];
    NSMutableArray * dataArr=_FourTableVDataSource[index];
    //取到数据源中的图片
    UIImage * image=dataArr[indexPath.row];
    //取到当前图片的高度
    return [self imageHeightWithImage:image];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSSTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[LSSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSInteger index=[_tableVArr indexOfObject:tableView];
    NSMutableArray * dataArr=_FourTableVDataSource[index];
    //取到数据源中的图片
    UIImage * image=dataArr[indexPath.row];
    [cell setImage:image width:IMAGE_WIDTH height:[self imageHeightWithImage:image]];
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    for (UITableView * currentTableV in _tableVArr) {
        if (currentTableV==scrollView) {
            continue;
        }
        currentTableV.contentOffset=scrollView.contentOffset;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
