//
//  IntroduceViewController.m
//  petegg
//
//  Created by czx on 16/5/4.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController ()

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"Product introduction"];
}

-(void)setupView{
    [super setupView];
     self.view.backgroundColor = LIGHT_GRAY_COLOR;
    
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 727 * W_Hight_Zoom)];
    NSString * str =  [AppUtil getServerTest];
    str = [str stringByAppendingString:@"s/function/function.jsp"];
    NSURL * url = [NSURL URLWithString:str];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];

}

@end
