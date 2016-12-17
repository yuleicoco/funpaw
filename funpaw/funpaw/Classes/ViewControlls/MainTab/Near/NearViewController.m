//
//  NearViewController.m
//  petegg
//
//  Created by ldp on 16/3/14.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "NearViewController.h"
#import "NearbyPeopleViewController.h"
#import "DouYIDouViewController.h"
#import "SeachePeopleViewController.h"


@interface NearViewController ()
@property (nonatomic,strong)UIButton * seacherBtn;
@end

@implementation NearViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"tabNear", nil);
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    
    
    
}

-(void)setupView{
    [super setupView];
    _seacherBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom,69 *W_Hight_Zoom , 355 * W_Wide_Zoom, 25 * W_Hight_Zoom)];
    [_seacherBtn setImage:[UIImage imageNamed:@"seacherkuang.png"] forState:UIControlStateNormal];
    [self.view addSubview:_seacherBtn];
    [_seacherBtn addTarget:self action:@selector(seacherTouch) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 100 * W_Hight_Zoom, self.view.width, 120 * W_Hight_Zoom)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
 
    NSArray * imageNameArray = @[@"nearPeople.png",@"DouYiDou.png"];
    NSArray * nameArray = @[@"推荐",@"逗一逗"];
    for (int i = 0 ; i < 2 ; i ++) {
        UIImageView * headImages = [[UIImageView alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 15 * W_Hight_Zoom + i * 60 * W_Hight_Zoom, 30 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        headImages.image = [UIImage imageNamed:imageNameArray[i]];
        headImages.layer.cornerRadius = 5;
        [whiteView addSubview:headImages];
        
        UILabel * lineLabeles = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom + i * 59 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1)];
        lineLabeles.backgroundColor = [UIColor lightGrayColor];
        lineLabeles.alpha = 0.2;
        [whiteView addSubview:lineLabeles];
        
        UILabel * nameLabeles = [[UILabel alloc]initWithFrame:CGRectMake(50 * W_Wide_Zoom, 15 * W_Hight_Zoom + i * 60 * W_Hight_Zoom, 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        nameLabeles.textColor = [UIColor blackColor];
        nameLabeles.font =[UIFont systemFontOfSize:14];
        nameLabeles.text = nameArray[i];
        [whiteView addSubview:nameLabeles];
        
        UIImageView * rightImages = [[UIImageView alloc]initWithFrame:CGRectMake(350 * W_Wide_Zoom, 23 * W_Hight_Zoom +i * 60 * W_Hight_Zoom, 13 * W_Wide_Zoom, 13 * W_Hight_Zoom)];
        rightImages.image = [UIImage imageNamed:@"jiantou.png"];
        [whiteView addSubview:rightImages];
        
        
        UIButton * buttones = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 60 * W_Hight_Zoom, 375 * W_Wide_Zoom, 60 * W_Hight_Zoom)];
        buttones.tag = i;
        [buttones addTarget:self action:@selector(bigButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:buttones];
        
    }
    
}
-(void)setupData{
    [super setupData];
}

-(void)bigButtonTouch:(UIButton *)sender{
    if (0 == sender.tag) {
        NearbyPeopleViewController * NearVc = [[NearbyPeopleViewController alloc]init];
        [self.navigationController pushViewController:NearVc animated:YES];
    
    }else{
        DouYIDouViewController * douVc = [[DouYIDouViewController alloc]init];
        [self.navigationController pushViewController:douVc animated:YES];
    }
}
-(void)seacherTouch{
    NSLog(@"搜索");
    SeachePeopleViewController * seacher = [[SeachePeopleViewController alloc]init];
    [self.navigationController pushViewController:seacher animated:YES];
}




@end