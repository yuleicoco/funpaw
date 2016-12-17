//
//  JubaoxuzhiViewController.m
//  petegg
//
//  Created by czx on 16/5/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "JubaoxuzhiViewController.h"

@interface JubaoxuzhiViewController ()

@end

@implementation JubaoxuzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"举报须知"];
}

-(void)setupView{
    [super setupView];
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 727 * W_Hight_Zoom)];
    NSString * str =  [AppUtil getServerTest];
    str = [str stringByAppendingString:@"s/report/article.jsp"];
    NSURL * url = [NSURL URLWithString:str];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];

        
    
}

@end
