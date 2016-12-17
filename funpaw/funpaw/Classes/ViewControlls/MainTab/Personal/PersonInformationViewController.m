//
//  PersonInformationViewController.m
//  petegg
//
//  Created by czx on 16/4/25.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PersonInformationViewController.h"
#import "AFHttpClient+InformationChange.h"
#import "InformationModel.h"

@interface PersonInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong)UIButton * manBtn;
@property (nonatomic,strong)UIButton * womanBtn;
@property (nonatomic,strong)UITextField * nameTextField;
@property (nonatomic,strong)UITextField * qqTextField;
@property (nonatomic,strong)UIButton * leftkuangbtn;
@property (nonatomic,strong)UIButton * rightkuangBtn;
@property (nonatomic,strong)UIButton * brithdayBtn;
@property (nonatomic,strong)UITextField * addressTextField;
@property (nonatomic,strong)UITextField * signTextField;
//生日的东西
@property (nonatomic,strong)UIDatePicker * datePicker;
@property (nonatomic,strong)UIView * bigView;
@property (nonatomic,strong)UIButton * bigButton;
@property (nonatomic,strong)UIButton * wanchengBtn;



@property (nonatomic,strong)UIView * downWithView;
@property (nonatomic,strong)UIButton * coverButton;
@property (nonatomic,strong)UIView * littleDownView;
@property(nonatomic,strong)UIImagePickerController * imagePicker;
@property (nonatomic,strong)NSString * picstr;

@property (nonatomic,strong)UIButton * publicBtn;
@end

@implementation PersonInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc]init];
//    [self setNavTitle:@"修改个人信息"];
    [self setNavTitle:@"Modify personal information"];
    _imagePicker =[[UIImagePickerController alloc]init];
    _imagePicker.delegate= self;
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setupData{
    [super setupData];
    
    if (self.informationModel) {
        [self initUserface];
    }else{
        [self showHudInView:self.view hint:@"Loading..."];
        
        [[AFHttpClient sharedAFHttpClient]queryByIdMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
            if (model) {
                [self hideHud];
                self.informationModel = model.list[0];
                [self initUserface];
            }
        }];
    }
}


-(void)setupView{
    [super setupView];
}

-(void)initUserface{
    NSArray * nameArray = @[@"Gender",@"Nickname",@"Family",@"Birthday",@"Address",@"Signature"];
    for (int i  = 0 ; i < 6 ; i ++) {
        UILabel * lineLabeles = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 230 * W_Hight_Zoom + 45 * W_Hight_Zoom * i , 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabeles.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineLabeles];
        
        UILabel * nameLabeles = [[UILabel alloc]initWithFrame:CGRectMake(35 * W_Wide_Zoom, 195 * W_Hight_Zoom + 45* W_Hight_Zoom * i , 80 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        nameLabeles.font = [UIFont systemFontOfSize:15];
        nameLabeles.text = nameArray[i];
        nameLabeles.textColor = [UIColor blackColor];
        [self.view addSubview:nameLabeles];
    }
    
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(147.5 * W_Wide_Zoom, 80 * W_Hight_Zoom, 80 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
    [_headImage.layer setMasksToBounds:YES];
    _headImage.layer.cornerRadius = _headImage.width/2;
    NSString * imageStr = [NSString stringWithFormat:@"%@",self.informationModel.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [_headImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    [self.view addSubview:_headImage];
    
    UIButton * headButton  = [[UIButton alloc]initWithFrame:_headImage.frame];
    headButton.backgroundColor = [UIColor clearColor];
    [headButton addTarget:self action:@selector(headButtontouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headButton];

    
    _manBtn = [[UIButton alloc]initWithFrame:CGRectMake(130 * W_Wide_Zoom, 202 * W_Hight_Zoom, 18 * W_Wide_Zoom, 18 * W_Hight_Zoom)];
    [_manBtn setImage:[UIImage imageNamed:@"manAnimal.png"] forState:UIControlStateNormal];
    [_manBtn setImage:[UIImage imageNamed:@"manSelect.png"] forState:UIControlStateSelected];
    [self.view addSubview:_manBtn];
    [_manBtn addTarget:self action:@selector(sexTouch1) forControlEvents:UIControlEventTouchUpInside];
    
    _womanBtn = [[UIButton alloc]initWithFrame:CGRectMake(200 * W_Wide_Zoom, 202 * W_Hight_Zoom, 18 * W_Wide_Zoom, 18 * W_Hight_Zoom)];
    [_womanBtn setImage:[UIImage imageNamed:@"womenAnimal.png"] forState:UIControlStateNormal];
    [_womanBtn setImage:[UIImage imageNamed:@"wanmenSelect.png"] forState:UIControlStateSelected];
    [self.view addSubview:_womanBtn];
    [_womanBtn addTarget:self action:@selector(sexTouch2) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.informationModel.pet_sex isEqualToString:@"公"]) {
        _manBtn.selected = YES;
    }else{
        _womanBtn.selected = YES;
    }
    
    
    _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(130 * W_Wide_Zoom, 240 * W_Hight_Zoom, 200 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _nameTextField.tintColor = GREEN_COLOR;
    _nameTextField.font = [UIFont systemFontOfSize:13];
    // _nameTextField.backgroundColor = [UIColor blueColor];
    _nameTextField.placeholder = @"Please input nickname";
    [self.view addSubview:_nameTextField];
    _nameTextField.text = self.informationModel.nickname;
    
    
//    _qqTextField = [[UITextField alloc]initWithFrame:CGRectMake(130 * W_Wide_Zoom, 285 * W_Hight_Zoom, 200 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
//    //_qqTextField.backgroundColor = [UIColor blueColor];
//    _qqTextField.tintColor = GREEN_COLOR;
//    _qqTextField.font = [UIFont systemFontOfSize:13];
//    _qqTextField.placeholder = @"Please input qq";
//    [self.view addSubview:_qqTextField];
//    _qqTextField.text = model.qq;
    
    
//    _publicBtn = [[UIButton alloc]initWithFrame:CGRectMake(280 * W_Wide_Zoom, 285 * W_Hight_Zoom, 90 * W_Wide_Zoom, 30 * W_Wide_Zoom)];
//   // [_publicBtn setTitle:@"公开" forState:UIControlStateNormal];
//    [_publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _publicBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.view addSubview:_publicBtn];
//    [_publicBtn addTarget:self action:@selector(gongkaiButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
//    if ([model.qqshowpurview isEqualToString:@"all"]) {
//        [_publicBtn setTitle:@"All people" forState:UIControlStateNormal];
//    }else if ([model.qqshowpurview isEqualToString:@"self"]){
//        [_publicBtn setTitle:@"Only myself" forState:UIControlStateNormal];
//    }else if ([model.qqshowpurview isEqualToString:@"friend"]){
//        [_publicBtn setTitle:@"Only friends" forState:UIControlStateNormal];
//    }
    
    
    
    
    _leftkuangbtn = [[UIButton alloc]initWithFrame:CGRectMake(130 * W_Wide_Zoom, 290 * W_Hight_Zoom, 18 * W_Wide_Zoom, 17 * W_Hight_Zoom)];
    [_leftkuangbtn setImage:[UIImage imageNamed:@"kuang_off.png"] forState:UIControlStateNormal];
    [_leftkuangbtn setImage:[UIImage imageNamed:@"kuang_on.png"] forState:UIControlStateSelected];
    [_leftkuangbtn addTarget:self action:@selector(leftKuangTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftkuangbtn];
    
    UILabel * wangLabel = [[UILabel alloc]initWithFrame:CGRectMake(153 * W_Wide_Zoom, 283 * W_Hight_Zoom, 50 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    wangLabel.text = @"Dog";
    wangLabel.textColor = [UIColor blackColor];
    wangLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:wangLabel];
    
    _rightkuangBtn = [[UIButton alloc]initWithFrame:CGRectMake(200 * W_Wide_Zoom, 290 * W_Hight_Zoom, 18 * W_Wide_Zoom, 17 * W_Hight_Zoom)];
    [_rightkuangBtn setImage:[UIImage imageNamed:@"kuang_off.png"] forState:UIControlStateNormal];
    [_rightkuangBtn setImage:[UIImage imageNamed:@"kuang_on.png"] forState:UIControlStateSelected];
    [_rightkuangBtn addTarget:self action:@selector(rightKuangTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightkuangBtn];
    
    UILabel * miaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(223 * W_Wide_Zoom, 283 * W_Hight_Zoom, 50 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    miaoLabel.text = @"Cat";
    miaoLabel.textColor = [UIColor blackColor];
    miaoLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:miaoLabel];
    if ([self.informationModel.pet_race isEqualToString:@"汪"]) {
        _leftkuangbtn.selected = YES;
    }else{
        _rightkuangBtn.selected = YES;
    }
    
    
    
    
    _brithdayBtn = [[UIButton alloc]initWithFrame:CGRectMake(70 * W_Wide_Zoom, 330 * W_Hight_Zoom, 200 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    //[_brithdayBtn setTitle:@"2016-05-13" forState:UIControlStateNormal];
    _brithdayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_brithdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_brithdayBtn];
    [_brithdayBtn addTarget:self action:@selector(brithdayButtontouch) forControlEvents:UIControlEventTouchUpInside];
    [_brithdayBtn setTitle:self.informationModel.pet_birthday forState:UIControlStateNormal];
    
    _addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(130 * W_Wide_Zoom, 375 * W_Hight_Zoom, 200 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _addressTextField.tintColor = GREEN_COLOR;
    _addressTextField.font = [UIFont systemFontOfSize:13];
    _addressTextField.placeholder = @"Please input address";
    [self.view addSubview:_addressTextField];
    _addressTextField.text = self.informationModel.address;
    
    
    _signTextField = [[UITextField alloc]initWithFrame:CGRectMake(130 * W_Wide_Zoom, 420 * W_Hight_Zoom, 200 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _signTextField.tintColor = GREEN_COLOR;
    _signTextField.font = [UIFont systemFontOfSize:13];
    _signTextField.placeholder = @"Please input signature";
    [self.view addSubview:_signTextField];
    _signTextField.text = self.informationModel.signature;
    
    
    UIButton * sureButton = [[UIButton alloc]initWithFrame:CGRectMake(87.5 * W_Wide_Zoom, 470 * W_Hight_Zoom, 200 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    sureButton.backgroundColor = GREEN_COLOR;
    [sureButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sureButton.layer.cornerRadius = 5;
    [self.view addSubview:sureButton];
    [sureButton addTarget:self action:@selector(sureButtonTouch) forControlEvents:UIControlEventTouchUpInside];
}

-(void)gongkaiButtonTouch:(UIButton *)sender{
    [_nameTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_signTextField resignFirstResponder];
    _downWithView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 120 * W_Hight_Zoom)];
    _littleDownView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    _coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 667 * W_Hight_Zoom)];
    _coverButton.backgroundColor = [UIColor blackColor];
    _coverButton.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_coverButton];
    [_coverButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 animations:^{
        _downWithView.frame = CGRectMake(0 * W_Wide_Zoom, 503 * W_Hight_Zoom, 375 * W_Wide_Zoom, 120 * W_Hight_Zoom);
        _littleDownView.frame = CGRectMake(0 * W_Wide_Zoom, 627 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom);
        _littleDownView.backgroundColor = [UIColor whiteColor];
        _downWithView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_littleDownView];
        [[UIApplication sharedApplication].keyWindow addSubview:_downWithView];
    }];
    NSArray * nameArray = @[@"All people",@"Only friends",@"Only myself",];
    for (int i = 0; i < 3; i++) {
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 40 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabel.backgroundColor = GRAY_COLOR;
        [_downWithView addSubview:lineLabel];
        
        UIButton * downButtones = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 40 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
        [downButtones setTitle:nameArray[i] forState:UIControlStateNormal];
        [downButtones setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        downButtones.titleLabel.font = [UIFont systemFontOfSize:14];
        [_downWithView addSubview:downButtones];
        downButtones.tag = i;
        [downButtones addTarget:self action:@selector(gongkai:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton * quxiaoButton = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    [quxiaoButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [quxiaoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quxiaoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_littleDownView addSubview:quxiaoButton];
    [quxiaoButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];

}



//-(void)gongkai:(UIButton *)sender{
//    NSString * objectStr = @"";
//    if (sender.tag == 0) {
//        objectStr = @"all";
//        [_publicBtn setTitle:@"All people" forState:UIControlStateNormal];
//    }else if (sender.tag == 1){
//        objectStr = @"friend";
//        [_publicBtn setTitle:@"Only friends" forState:UIControlStateNormal];
//    }else if (sender.tag == 2){
//        objectStr = @"self";
//        [_publicBtn setTitle:@"Only myself" forState:UIControlStateNormal];
//    }
//    [[AFHttpClient sharedAFHttpClient]modifyQqStatusWithMid:[AccountManager sharedAccountManager].loginModel.mid object:objectStr complete:^(BaseModel *model) {
//        if (model) {
//            [[AppUtil appTopViewController] showHint:@"Modify success"];
//        }else{
//            [[AppUtil appTopViewController] showHint:model.retDesc];
//        }
//    }];
//    
//    
//    
//    [self hideButton:nil];
//}




-(void)headButtontouch:(UIButton *)sender{
    _downWithView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
    _littleDownView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    _coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 667 * W_Hight_Zoom)];
    _coverButton.backgroundColor = [UIColor blackColor];
    _coverButton.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_coverButton];
    [_coverButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 animations:^{
        _downWithView.frame = CGRectMake(0 * W_Wide_Zoom, 543 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom);
        _littleDownView.frame = CGRectMake(0 * W_Wide_Zoom, 627 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom);
        _littleDownView.backgroundColor = [UIColor whiteColor];
        _downWithView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_littleDownView];
        [[UIApplication sharedApplication].keyWindow addSubview:_downWithView];
    }];
    NSArray * nameArray = @[NSLocalizedString(@"photograph", nil),NSLocalizedString(@"Select from album", nil)];
    for (int i = 0; i < 2; i++) {
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 40 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabel.backgroundColor = GRAY_COLOR;
        [_downWithView addSubview:lineLabel];
        
        UIButton * downButtones = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 40 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
        [downButtones setTitle:nameArray[i] forState:UIControlStateNormal];
        [downButtones setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        downButtones.titleLabel.font = [UIFont systemFontOfSize:14];
        [_downWithView addSubview:downButtones];
        downButtones.tag = i;
        [downButtones addTarget:self action:@selector(imageButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton * quxiaoButton = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    [quxiaoButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [quxiaoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quxiaoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_littleDownView addSubview:quxiaoButton];
    [quxiaoButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];



}
-(void)hideButton:(UIButton *)sender{
    _coverButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _downWithView.frame = CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom);
        _littleDownView.frame = CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom);
    }];
}

-(void)imageButtonTouch:(UIButton *)sender{
    if (sender.tag == 0) {
        [self takePhoto];
    }else{
        [self loacalPhoto];
    }
    
}
- (void)takePhoto
{
    [self hideButton:nil];
    // 拍照
    NSArray * mediaty = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.mediaTypes = @[mediaty[0]];
        //设置相机模式：1摄像2录像
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //使用前置还是后置摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //闪光模式
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        _imagePicker.allowsEditing = YES;
    }else
    {
        NSLog(@"打开摄像头失败");
    }
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
    
}

- (void)loacalPhoto
{
    [self hideButton:nil];
    NSArray * mediaTypers = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.mediaTypes = @[mediaTypers[0],mediaTypers[1]];
        _imagePicker.allowsEditing = YES;
    }
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    UIImage * showImage = info[UIImagePickerControllerEditedImage];
    NSLog(@"wocaocao:%@",showImage);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"handImageText" object:showImage];
    
    _headImage.image = showImage;
    NSDateFormatter * formater =[[NSDateFormatter alloc]init];
    NSData * data = UIImageJPEGRepresentation(showImage,1.0f);
    
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    [formater stringFromDate:[NSDate date]];
    NSString *picname1 = [NSString stringWithFormat:@"%@.jpg",[formater stringFromDate:[NSDate date]]];
    
    
    NSString * pictureDataString = [data base64EncodedStringWithOptions:0];
    // NSLog(@"%@",pictureDataString);
    
    _picstr = [NSString stringWithFormat:@"[{\"%@\":\"%@\",\"%@\":\"%@\"}]",@"name",picname1,@"content",pictureDataString];
    
    [self changgeheadRequest];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)changgeheadRequest{
    [self showHudInView:self.view hint:@"Modifing..."];
    
    [[AFHttpClient sharedAFHttpClient]modifyHeadportraitWithMid: [AccountManager sharedAccountManager].loginModel.mid picture:_picstr complete:^(BaseModel *model) {
        [self hideHud];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationInformationChange object:nil];
        
        [[AppUtil appTopViewController] showHint:@"Modify success"];
    }];
}






-(void)sureButtonTouch{
    if ([AppUtil isBlankString:_nameTextField.text]) {
        [[AppUtil appTopViewController] showHint:@"Please input nickname"];
        return;
    }
    
    NSString * petsex = @"";
    if (_manBtn.selected == YES) {
        petsex = @"公";
    }else if (_womanBtn.selected == YES){
        petsex = @"母";
    }
    NSString * petrace = @"";
    if (_leftkuangbtn.selected == YES) {
        petrace = @"汪";
    }else if (_rightkuangBtn.selected == YES){
        petrace = @"喵";
    }
    
    [self showHudInView:self.view hint:@"Modifing..."];
    [[AFHttpClient sharedAFHttpClient]modifyMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid nicname:_nameTextField.text qq:_qqTextField.text address:_addressTextField.text signature:_signTextField.text pet_sex:petsex pet_birthday:_brithdayBtn.titleLabel.text pet_race:petrace complete:^(BaseModel *model) {
            [self hideHud];
            [[AppUtil appTopViewController] showHint:@"Modify success"];
        
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeNameText" object:_nameTextField.text];
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationInformationChange object:nil];
            [self.navigationController popViewControllerAnimated:YES];
    }];


}

//生日按钮点击
-(void)brithdayButtontouch{
    [_nameTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_signTextField resignFirstResponder];

    _bigButton = [[UIButton alloc]initWithFrame:self.view.bounds];
    _bigButton.backgroundColor = [UIColor blackColor];
    _bigButton.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_bigButton];
    [_bigButton addTarget:self action:@selector(bigButtonHidden) forControlEvents:UIControlEventTouchUpInside];
    
    _datePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0 * W_Wide_Zoom,200,self.view.frame.size.width,260 * W_Hight_Zoom)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.alpha = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:_datePicker];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CN"];//设置为中文显示
    _datePicker.locale = locale;
    
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
   
    _wanchengBtn = [[UIButton alloc]initWithFrame:CGRectMake(0* W_Wide_Zoom, 427 * W_Hight_Zoom, 375 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    _wanchengBtn.backgroundColor = [UIColor whiteColor];
    [_wanchengBtn setTitle:@"Complete" forState:UIControlStateNormal];
    [_wanchengBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:_wanchengBtn];
    [_wanchengBtn addTarget:self action:@selector(wanchengButtonTouch:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)wanchengButtonTouch:(UIButton *)sender{
   
    NSDate *pickerDate = [_datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    [_brithdayBtn setTitle:dateString forState:UIControlStateNormal];
    sender.hidden = YES;
    _bigButton.hidden = YES;
    _datePicker.hidden = YES;
}



-(void)bigButtonHidden{
    _wanchengBtn.hidden = YES;
    _bigButton.hidden = YES;
    _datePicker.hidden = YES;

}


-(void)dateChanged:(id)sender{
    NSDate *pickerDate = [sender date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    [_brithdayBtn setTitle:dateString forState:UIControlStateNormal];
    //打印显示日期时间
    NSLog(@"格式化显示时间：%@",dateString);
    
    
}

//按钮点击变化
-(void)leftKuangTouch{
    _leftkuangbtn.selected = YES;
    _rightkuangBtn.selected = NO;
    [_nameTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_signTextField resignFirstResponder];

}

-(void)rightKuangTouch{
    _leftkuangbtn.selected = NO;
    _rightkuangBtn.selected = YES;
    [_nameTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_signTextField resignFirstResponder];

}



-(void)sexTouch1{
    _manBtn.selected = YES;
    _womanBtn.selected = NO;
    [_nameTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_signTextField resignFirstResponder];



}
-(void)sexTouch2{
    _womanBtn.selected = YES;
    _manBtn.selected = NO;
    [_nameTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_signTextField resignFirstResponder];

}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_nameTextField isExclusiveTouch]||![_qqTextField isExclusiveTouch] || ![_addressTextField isExclusiveTouch]||![_signTextField isExclusiveTouch]) {
        [_nameTextField resignFirstResponder];
        [_qqTextField resignFirstResponder];
        [_addressTextField resignFirstResponder];
        [_signTextField resignFirstResponder];
        
    }
}





@end
