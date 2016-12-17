//
//  DetailViewController.m
//  petegg
//
//  Created by ldp on 16/4/7.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "DetailViewController.h"

#import "AFHttpClient+Detailed.h"

#import "UIImageView+WebCache.h"

#import "DetailContentCell.h"
#import "DetailCommentCell.h"
#import "DetailImageCell.h"
#import "DetailVideoCell.h"
#import "CommentInputView.h"

#import "MWPhotoBrowser.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ReportViewController.h"
#import "PersonDetailViewController.h"
@interface DetailViewController()<MWPhotoBrowserDelegate>
{
    NSIndexPath *currentEditingIndexthPath;
}

@property (nonatomic, strong) UIView* userInfoView;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* toolView;

@property (nonatomic, strong) UIImageView *tempImageView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) CommentInputView *commentInputView;

@property (nonatomic, strong) DetailModel* detailModel;
@property (nonatomic, strong) NSMutableArray* resourcesArray;
@property (nonatomic, strong) NSMutableArray* photoArray;
@property (nonatomic, strong) NSString * isdianzan;
@property (nonatomic,strong)UITextField * ceishi;
@property (nonatomic,assign)BOOL dianzanzan;

@property (nonatomic,assign)BOOL isVideo;

@end

const CGFloat contentLabelFontSize = 15;
NSString * const kDetailContentCellID = @"DetailContentCell";
NSString * const kDetailCommentCellID = @"DetailCommentCell";
NSString * const kDetailImageCellID = @"DetailImageCell";
NSString * const kDetailVideoCellID = @"DetailVideoCell";

@implementation DetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setNavTitle:@"萌宠秀详情"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)setupData{
    [super setupData];
    
    self.resourcesArray = [NSMutableArray array];
    self.photoArray = [NSMutableArray array];
    
    [self loadDetailInfo];
  
}




- (void)setupView{
    self.bGroupView = YES;
    [super setupView];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 49);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.separatorStyle = NO;
    self.ceishi =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.ceishi];
    
    [self.tableView registerClass:[DetailContentCell class] forCellReuseIdentifier:kDetailContentCellID];
    [self.tableView registerClass:[DetailCommentCell class] forCellReuseIdentifier:kDetailCommentCellID];
    [self.tableView registerClass:[DetailImageCell class] forCellReuseIdentifier:kDetailImageCellID];
    [self.tableView registerClass:[DetailVideoCell class] forCellReuseIdentifier:kDetailVideoCellID];
    
    [self.view addSubview:self.toolView];
    
    [self.view addSubview:self.commentInputView];
    
    self.tempImageView = [UIImageView new];
    [self.view addSubview:self.tempImageView];
    _dianzanzan = NO;
    [self initRefreshView];
}

- (void)loadDetailInfo{
    //萌宠秀详情的接口
     [self showHudInView:self.view hint:@"正在加载..."];
    //[self showHint:@"正在加载" afterTime:7];
    [[AFHttpClient sharedAFHttpClient] querDetailWithStid:self.stid complete:^(BaseModel *model) {
        
        if (model && model.list && model.list.count > 0) {
            
            self.detailModel = model.list[0];
            
            [self.resourcesArray removeAllObjects];
            
            if ([self.detailModel.type isEqualToString:@"pv"]|| [self.detailModel.type isEqualToString:@"v"]) {
                self.isVideo = YES;
                self.resourcesArray = [NSMutableArray arrayWithObject:self.detailModel.thumbnails];
            }else{
                
                self.isVideo = NO;
                self.resourcesArray = [[self.detailModel.resources componentsSeparatedByString:@","] mutableCopy];
            }
            
            for (NSString* resources in self.resourcesArray) {
                [self.photoArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:resources]]];
            }
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)] withRowAnimation:UITableViewRowAnimationNone];
           // [self hideHud];
        }else{
            //[self hideHud];
            
        }
    }];
}


- (void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]queryCommentWithWid:_stid pageIndex:page pageSize:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
        
        [self handleEndRefresh];
        
        if (model) {
            if (page == START_PAGE_INDEX) {
                [self.dataSource removeAllObjects];
            }

            [self.dataSource addObjectsFromArray:model.list];
            
            self.tableView.mj_footer.hidden = model.list.count < REQUEST_PAGE_SIZE;
            
            [self.tableView reloadData];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    
}

- (UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 49, self.tableView.width, 49)];
        _toolView.backgroundColor = LIGHT_GRAY_COLOR;
        _toolView.layer.shadowColor = [UIColor blackColor].CGColor;
        _toolView.layer.shadowOffset = CGSizeMake(0, -1);
        _toolView.layer.shadowOpacity = 0.4;
        _toolView.layer.shadowRadius = 2;
        
        //分享
        UIButton* shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"shareBtn"] forState:UIControlStateNormal];
        [shareBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            
            
            [self shareBox];
            
            
        }];
        
//        [shareBtn addTarget:self action:@selector(shareBox) forControlEvents:
//         UIControlEventTouchUpInside];
        
        //评论
        UIButton* commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [commentBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [self.commentInputView showWithSendCommentBlock:^(NSString *text) {
                if (text && text.length > 0) {

                    [[AFHttpClient sharedAFHttpClient] addCommentWithPid:[AccountManager sharedAccountManager].loginModel.mid bid:@"" wid:self.stid bcid:@"" ptype:@"m" action:@"p" content:text complete:^(BaseModel *model) {
                        
                        if (model) {
                            CommentModel* addModel = [[CommentModel alloc] init];
                            addModel.memname = [AccountManager sharedAccountManager].loginModel.nickname;
                            addModel.content = text;
                            addModel.age = [AccountManager sharedAccountManager].loginModel.pet_age;
                            addModel.sex = [AccountManager sharedAccountManager].loginModel.pet_sex;
                            addModel.opttime = [AppUtil getCurrentTime];
                            addModel.race = [AccountManager sharedAccountManager].loginModel.pet_race;
                            addModel.wid = self.stid;
                            addModel.cid = model.content;
                            addModel.img = [AccountManager sharedAccountManager].loginModel.headportrait;
                            addModel.pid = [AccountManager sharedAccountManager].loginModel.mid;
                            
                            [self.dataSource insertObject:addModel atIndex:0];
                            [self.tableView reloadData];
                        }
                    }];
                }
            }];
        }];
        
        //赞
        UIButton* likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [[AFHttpClient sharedAFHttpClient]queryBehaviorWithMid:[AccountManager sharedAccountManager].loginModel.mid objid:self.stid complete:^(BaseModel *model) {
            if (model) {
                if ([model.content isEqualToString:@"0"]) {
                     [likeBtn setImage:[UIImage imageNamed:@"likeBtn"] forState:UIControlStateNormal];
                    [likeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                     //点赞借口
                        [self isORdianzan:likeBtn];
                       
                    }];
                }else{
                     [likeBtn setImage:[UIImage imageNamed:@"dianzanhou.png"] forState:UIControlStateNormal];
                    [likeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        [[AppUtil appTopViewController] showHint:@"您已经点过赞了!"];
                    }];
                }
            }else{
                 [likeBtn setImage:[UIImage imageNamed:@"likeBtn"] forState:UIControlStateNormal];
                [[AppUtil appTopViewController] showHint:model.retDesc];
            }
            
        }];
        
       
        
        //警告
        UIButton* warningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [warningBtn setImage:[UIImage imageNamed:@"warningBtn"] forState:UIControlStateNormal];
        [warningBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            ReportViewController * report = [[ReportViewController alloc]init];
            report.stid = self.stid;
            [self.navigationController pushViewController:report animated:YES];

            
        }];
        
        [_toolView sd_addSubviews:@[shareBtn, commentBtn, likeBtn, warningBtn]];
        
        _toolView.sd_equalWidthSubviews = @[shareBtn, commentBtn, likeBtn, warningBtn];
        
        shareBtn.sd_layout.leftSpaceToView(_toolView, 0).topSpaceToView(_toolView, 0).heightIs(49);
        commentBtn.sd_layout.leftSpaceToView(shareBtn, 0).topSpaceToView(_toolView, 0).heightIs(49);
        likeBtn.sd_layout.leftSpaceToView(commentBtn, 0).topSpaceToView(_toolView, 0).heightIs(49);
        warningBtn.sd_layout.leftSpaceToView(likeBtn, 0).topSpaceToView(_toolView, 0).rightSpaceToView(_toolView, 0).heightIs(49);
    }
    
    return _toolView;
}

/**
 *  分享
 */

- (void)shareBox
{
    
    // 1、创建分享参数
    NSArray *imageArray = @[[UIImage imageNamed:@"segoColor.jpg"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数
    
    //NSString * strUrl =[NSString stringWithFormat:@"http://180.97.81.213/clientAction.do?method=client&nextPage=/s/sproutpet/article.jsp&stid=%@&mid=%@&access=outside",self.stid,[AccountManager sharedAccountManager].loginModel.mid];
    
    NSString * strUrl =[NSString stringWithFormat:@"http://www.segopet.com/site/wx/wxvideosdk.jsp"];

    
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams
//         SSDKSetupShareParamsByText:[NSString stringWithFormat:@"赛果分享http://180.97.81.213:15102/clientAction.do?method=client&nextPage=/s/sproutpet/article.jsp&stid=%@&mid=%@&access=outside",self.stid,[AccountManager sharedAccountManager].loginModel.mid]
//         images:imageArray
//         url:[NSURL URLWithString:strUrl]
//         title:@"赛果分享"
//         type:SSDKContentTypeAuto];
    
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams
//         SSDKSetupShareParamsByText:[NSString stringWithFormat:@"仅需嵌入几行代码，就能在您的APP或智能硬件里实现远程双向视频聊天功能"]
//         images:imageArray
//         url:[NSURL URLWithString:strUrl]
//         title:@"赛果视频SDK"
//         type:SSDKContentTypeAuto];
//        
//        
//        // 2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet: nil items:nil shareParams:shareParams onShareStateChanged:^(
//                                                                                                    SSDKResponseState state, SSDKPlatformType platformType,
//                                                                                                    NSDictionary *userData, SSDKContentEntity *contentEntity,
//                                                                                                    NSError *error, BOOL end) {
//            
//            
//            switch (state) {
//                case SSDKResponseStateSuccess: {
//                    
//                    [self shareSuccess:platformType];
//                    UIAlertView *alertView =
//                    [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                               message:nil
//                                              delegate:nil
//                                     cancelButtonTitle:@"确定"
//                                     otherButtonTitles:nil];
//                    [alertView show];
//                    [self.ceishi becomeFirstResponder];
//                    break;
//                }
//                case SSDKResponseStateFail: {
//                    UIAlertView *alert = [[UIAlertView alloc]
//                                          initWithTitle:@"分享失败"
//                                          message:[NSString stringWithFormat:@"%@", error]
//                                          delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//                    [alert show];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }];
//    }
//    
    
}



/**
 *  分享成功
 */


- (void)shareSuccess:(NSInteger )style
{
    
    NSString * strvice =@"clientAction.do?common=addShare&classes=appinterface&method=json";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
     [dic setValue:[AccountManager sharedAccountManager].loginModel.mid forKey:@"mid"];
     [dic setValue:@"m" forKey:@"objtype"];
     [dic setValue:self.stid forKey:@"objid"];
    switch (style) {
        case 1:
            [dic setValue:@"SinaWeibo" forKey:@"approach"];
            break;
       case 6:
            [dic setValue:@"QQspace" forKey:@"approach"];
            break;
       case 22:
            [dic setValue:@"Wechat" forKey:@"approach"];
            break;
        case 23:
            [dic setValue:@"WechatFriends" forKey:@"approach"];
            break;
        case 24:
            [dic setValue:@"QQ" forKey:@"approach"];
            break;
        default:
            break;
    }
    
    
    [AFNetWorking postWithApi:strvice parameters:dic success:^(id json) {
    
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}


//点赞
-(void)isORdianzan:(UIButton *)sender{
    
    if (_dianzanzan == NO) {
        [[AFHttpClient sharedAFHttpClient]addBehaviorWithMid:[AccountManager sharedAccountManager].loginModel.mid objid:self.stid objcon:@"m" complete:^(BaseModel *model) {
            if (model) {
                [[AppUtil appTopViewController] showHint:model.retDesc];
                [sender setImage:[UIImage imageNamed:@"dianzanhou.png"] forState:UIControlStateNormal];
                _dianzanzan = YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"dianzanbian" object:nil];
            }
        }];
    }else{
    [[AppUtil appTopViewController] showHint:@"您已经点过赞了!"];
    }
}





- (CommentInputView *)commentInputView{
    
    if (!_commentInputView) {
        _commentInputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, self.view.height - [CommentInputView defaultHeight], self.view.width, [CommentInputView defaultHeight])];
        _commentInputView.viewController = self;
    }
    
    return _commentInputView;
}

- (UIView *)userInfoView{
    if (!_userInfoView) {
        _userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 76)];
        
        UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.tableView.width, 66)];
        bgView.backgroundColor = [UIColor whiteColor];
        [_userInfoView addSubview:bgView];
        
        // 头像
        _iconImageView =[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 50, 50)];
        _iconImageView.layer.cornerRadius = _iconImageView.bounds.size.width/2;
        _iconImageView.layer.masksToBounds = YES;
        [bgView addSubview:_iconImageView];
        
        UIButton * touchuBtn = [[UIButton alloc]initWithFrame:_iconImageView.frame];
        touchuBtn.backgroundColor = [UIColor clearColor];
        [bgView addSubview:touchuBtn];
        [touchuBtn addTarget:self action:@selector(wocaonigedaxigua) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 名字
        _nameLabel =[[UILabel alloc]initWithFrame:CGRectMake( _iconImageView.right + 8,23, self.tableView.width - _iconImageView.right - 8 - 8, 20)];
        _nameLabel.font =[UIFont systemFontOfSize:13];
        [bgView addSubview:_nameLabel];
    }
    
    if (self.detailModel) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.headportrait] placeholderImage:nil];
        _nameLabel.text = self.detailModel.nickname;
    }
    
    return _userInfoView;
}
-(void)wocaonigedaxigua{
    NSLog(@"haha");
    
    PersonDetailViewController * perVc = [[PersonDetailViewController alloc]init];
    perVc.ddddd = self.detailModel.publishuser;
    [self.navigationController pushViewController:perVc animated:NO];
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return self.userInfoView;
        case 2:
        {
            UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 44)];
            headerView.backgroundColor = [UIColor whiteColor];
            
            UILabel* titleLB = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, headerView.width - 8 - 8, 28)];
            titleLB.text = @"评论列表";
            [headerView addSubview:titleLB];
            
            return headerView;
        }
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.detailModel ? self.userInfoView.height : 0;
        case 2:
            return 44;
        default:
            break;
    }
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return 10;
            
        default:
            break;
    }
    return 0.0000001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return self.detailModel ? 1: 0;
          
        case 0:
            return self.resourcesArray.count;
            
        case 2:
            return self.dataSource.count;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            NSString* resources = self.resourcesArray[indexPath.row];
            CGFloat height;
            if (self.isVideo) {
                height = [self.tableView cellHeightForIndexPath:indexPath model:resources keyPath:@"model" cellClass:[DetailVideoCell class] contentViewWidth:SCREEN_WIDTH];
                [self hideHud];
            }else{
                height = [self.tableView cellHeightForIndexPath:indexPath model:resources keyPath:@"model" cellClass:[DetailImageCell class] contentViewWidth:SCREEN_WIDTH];
                [self hideHud];
            }
            
            return height;
        }
        case 1:
            return [self.tableView cellHeightForIndexPath:indexPath model:self.detailModel keyPath:@"model" cellClass:[DetailContentCell class] contentViewWidth:SCREEN_WIDTH];
        case 2:
        {
            CommentModel* model = self.dataSource[indexPath.row];
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DetailCommentCell class] contentViewWidth:SCREEN_WIDTH];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            NSString* resources = self.resourcesArray[indexPath.row];
            
            if (self.isVideo) {
                DetailVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:kDetailVideoCellID];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                cell.model = resources;
                return cell;
            }
            DetailImageCell* cell = [tableView dequeueReusableCellWithIdentifier:kDetailImageCellID];
            cell.tableView = tableView;
            
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.model = resources;
            return cell;
        }
        case 1:
        {
            DetailContentCell* cell = [tableView dequeueReusableCellWithIdentifier:kDetailContentCellID];
            
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            
            cell.model = self.detailModel;

            return cell;
        }
        case 2:
        {
            CommentModel* commentModel = self.dataSource[indexPath.row];
            DetailCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:kDetailCommentCellID];
            cell.commentLableClickBlock = ^(int index){
                currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
                [self.commentInputView showWithSendCommentBlock:^(NSString *text) {
                    if (text && text.length > 0) {
                        
                        //回复评论的model
                        CommentModel* replayCommentModel = commentModel.list[index];
                        
                        [[AFHttpClient sharedAFHttpClient] addCommentWithPid:[AccountManager sharedAccountManager].loginModel.mid bid:replayCommentModel.pid wid:self.stid bcid:commentModel.cid ptype:@"r" action:@"h" content:text complete:^(BaseModel *model) {
                            
                            if (model) {
                                CommentModel* addModel = [[CommentModel alloc] init];
                                addModel.memname = [AccountManager sharedAccountManager].loginModel.nickname;
                                addModel.content = text;
                                addModel.opttime = [AppUtil getCurrentTime];
                                addModel.wid = self.stid;
                                addModel.cid = model.content;
                                addModel.bcid = commentModel.cid;
                                addModel.bmemname = replayCommentModel.memname;
                                addModel.img = [AccountManager sharedAccountManager].loginModel.headportrait;
                                addModel.pid = [AccountManager sharedAccountManager].loginModel.mid;
                                
                                [commentModel.list addObject:addModel];
                                [self.tableView reloadRowsAtIndexPaths:@[currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
                                
                            }
                        }];
                    }
                }];
            };
            cell.replyBlock = ^(){
                currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
                [self.commentInputView showWithSendCommentBlock:^(NSString *text) {
                    if (text && text.length > 0) {
                        
                        [[AFHttpClient sharedAFHttpClient] addCommentWithPid:[AccountManager sharedAccountManager].loginModel.mid bid:commentModel.pid wid:self.stid bcid:commentModel.cid ptype:@"r" action:@"h" content:text complete:^(BaseModel *model) {
                            
                            if (model) {
                               
                                CommentModel* addModel = [[CommentModel alloc] init];
                                addModel.memname = [AccountManager sharedAccountManager].loginModel.nickname;
                                addModel.content = text;
                                addModel.opttime = [AppUtil getCurrentTime];
                                addModel.wid = self.stid;
                                addModel.cid = model.content;
                                addModel.bcid = commentModel.cid;
                                addModel.img = [AccountManager sharedAccountManager].loginModel.headportrait;
                                addModel.pid = [AccountManager sharedAccountManager].loginModel.mid;
                                
                                [commentModel.list addObject:addModel];
                                [self.tableView reloadRowsAtIndexPaths:@[currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
                            
                            }
                        }];
                    }
                }];
            };
            
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            
            cell.model = commentModel;
            
            return cell;
        }
            
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (self.isVideo) {
                
                //TODO 视频播放
                MPMoviePlayerViewController * vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:self.detailModel.resources]];
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                NSError *err = nil;
                [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
                [self presentMoviePlayerViewControllerAnimated:vc];
            }else{
                MWPhotoBrowser *browser=[[MWPhotoBrowser alloc]initWithDelegate:self];
                browser.displayActionButton = YES;
                browser.displayNavArrows = NO;
                browser.displaySelectionButtons = NO;
                browser.zoomPhotosToFill = YES;
                browser.alwaysShowControls = NO;
                browser.enableGrid = YES;
                browser.startOnGrid = NO;
                [browser setCurrentPhotoIndex:indexPath.row];
                [self.navigationController pushViewController:browser animated:YES];     
            }
           
        }
            break;
            
        default:
            break;
    }
}

- (void)keyboardNotification:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - self.commentInputView.height , rect.size.width, self.commentInputView.height);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    self.commentInputView.frame = textFieldRect;
}

#pragma mark    图片浏览器协议
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    
    if (index < self.photoArray.count){
        return [self.photoArray objectAtIndex:index];
    }
    return nil;
}




-(void)doLeftButtonTouch{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxin11232" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}

@end
