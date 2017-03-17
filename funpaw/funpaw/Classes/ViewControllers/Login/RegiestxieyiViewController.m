//
//  RegiestxieyiViewController.m
//  funpaw
//
//  Created by czx on 2017/2/15.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "RegiestxieyiViewController.h"

@interface RegiestxieyiViewController ()

@end

@implementation RegiestxieyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    [self setNavTitle:@"Terms of Use"];
    
    
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 727 * W_Hight_Zoom)];
    NSString * str =  @"http://app.smartsuoo.com:15102/clientAction.do?method=client&nextPage=/";
    
    
    str = [str stringByAppendingString:@"s/agreement/article.jsp"];
    NSURL * url = [NSURL URLWithString:str];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];

    
    
    
    
    
    
    
}



@end
