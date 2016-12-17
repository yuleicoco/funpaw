//
//  FeaturedViewController.m
//  petegg
//
//  Created by czx on 16/5/9.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "FeaturedViewController.h"

@interface FeaturedViewController ()

@end

@implementation FeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"推荐"];
}

-(void)setupView{
    [super setupView];
   // NSLog(@"%ld",self.number);
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 727 * W_Hight_Zoom)];
 //   NSString * str =  [AppUtil getServerTest];
     NSString * str = @"";
    if ([self.number isEqualToString: @"2"]) {

        str =[AppUtil getServerTest];
        str = [str stringByAppendingString:@"clientAction.do?method=client&aid=2&nextPage=/s/recommend/article.jsp&access=inside"];
    
        
    }else if([self.number isEqualToString: @"3"]){
        
        str =[AppUtil getServerTest];
        str = [str stringByAppendingString:@"clientAction.do?method=client&aid=3&nextPage=/s/recommend/article.jsp&access=inside"];

    
    }
    
    NSURL * url = [NSURL URLWithString:str];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];
    
}
-(void)setupData{
    [super setupData];
    
}



@end
