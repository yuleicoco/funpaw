//
//  CompletionViewController.m
//  petegg
//
//  Created by yulei on 16/4/19.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "CompletionViewController.h"


@interface CompletionViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    NSString * girlOrBoy;
    NSString * catOrDog;
    NSUInteger sourceType;
    
    NSString * birstyStr;
    BOOL isHand;
    
    
    
    
    
}

@end

@implementation CompletionViewController

@synthesize handImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =[UIColor whiteColor];
     [self setNavTitle: NSLocalizedString(@"completion", nil)];
    handImage.userInteractionEnabled = YES;
    [self.nameTextF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    isHand = NO;
}

- (void)setupView{
    [super setupView];
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    [handImage addGestureRecognizer:singleRecognizer];

}
-(void)doLeftButtonTouch{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:@"You have not yet completed the confirmation of your information, confirm the return?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
         [self.navigationController popToRootViewControllerAnimated:YES];    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 *  头像点击
 */
- (void)handleSingleTapFrom:(UITapGestureRecognizer *)tap
{
    
    UIAlertController *sheet;
    //判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        sheet = [UIAlertController alertControllerWithTitle:@"Select upload mode" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"Photograph" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 普通按键
         
            sourceType = UIImagePickerControllerSourceTypeCamera;
            [self openXC];
            
            
        }];
        UIAlertAction *laterAction1 = [UIAlertAction actionWithTitle:@"Select from album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 普通按键
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self openXC];
            
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 取消按键
        }];
        
        
        [sheet addAction:laterAction];
        [sheet addAction:laterAction1];
        [sheet addAction:okAction];
        [self presentViewController:sheet animated:YES completion:nil];

        
    }
    
}


- (void)openXC
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

//UIImagePickerController的代理函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [handImage setImage:image];
    
    //获得头像之后将头像上传
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    [self submitAvatarImage:imageData];
    
}

//上传头像
- (void)submitAvatarImage:(NSData *)imageData
{
  //base64EncodedStringWithOptions:0
    NSString *base64str = [imageData base64EncodedStringWithOptions:0];
    NSString *picstr = [NSString stringWithFormat:@"[{\"%@\":\"%@\",\"%@\":\"%@\"}]",@"name",@"avatar.jpg",@"content",base64str];
    NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
    [dicc setValue:self.mid forKey:@"mid"];
    [dicc setValue:picstr forKey:@"picture"];
    NSString * str = @"clientAction.do?common=modifyHeadportrait&classes=appinterface&method=json";
    [AFNetWorking postWithApi:str parameters:dicc success:^(id json) {
        isHand = YES;
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    
    
    
    
    
}

- (void)setupData
{
    [super setupData];
    
    
}

/**
 *  XLB 点击事件
 */
- (IBAction)brithdayBtn:(UIButton *)sender {
    [_nameTextF resignFirstResponder];
    self.backView.hidden = NO;
    
}

- (IBAction)manBtn:(UIButton *)sender {
   [_nameTextF resignFirstResponder];
    sender.selected = YES;
    self.mubtn.selected = NO;
   [self chooseOnebtn:2004 button:sender];
    
    
}

- (IBAction)wowenSelect:(UIButton *)sender {
    sender.selected= YES;
    self.gongbtn.selected = NO;
    [_nameTextF resignFirstResponder];
    [self chooseOnebtn:2003 button:sender];

}

- (IBAction)dogWindowsBtn:(UIButton *)sender {
    [_nameTextF resignFirstResponder];
    sender.selected = YES;
    self.catbtn.selected = NO;
   [self chooseOnebtn:2006 button:sender];
    
    
}


- (IBAction)catWindowsBtn:(UIButton *)sender {
    [_nameTextF resignFirstResponder];
    sender.selected = YES;
    self.dogbtn.selected = NO;
   [self chooseOnebtn:2005 button:sender];
    
}

- (IBAction)dateTimePicker:(UIDatePicker *)sender {
    
    /*
    NSDate*selected = [self.timeSelect date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSString *destDateString = [dateFormatter stringFromDate:selected];
     NSString *message =  [NSString stringWithFormat: @"您选择的日期和时间是：%@",
                 destDateString];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"日期和时间" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
          [alert show];
     */
    
     
    [_nameTextF resignFirstResponder];
    
}

- (IBAction)overViewBtn:(UIButton *)sender {
    [_nameTextF resignFirstResponder];
    self.backView.hidden = YES;
    NSDate*selected = [self.timeSelect date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    birstyStr = [dateFormatter stringFromDate:selected];
    [self.birthdayBtn setTitle:birstyStr forState:UIControlStateNormal];
    
}

// 点击完成
- (IBAction)overBtn:(UIButton *)sender {
    
    
    if (isHand == NO) {
        
        [[AppUtil appTopViewController] showHint:@"Please select a picture"];
        return;
    }
    if ([AppUtil isBlankString:self.nameTextF.text]) {
        [[AppUtil appTopViewController] showHint:@"Please enter a nickname"];
        return;
    }
    if([AppUtil isBlankString:catOrDog])
    {
        [[AppUtil appTopViewController]showHint:@"Please select a family"];
        
        return;
    }
    if ([AppUtil isBlankString:girlOrBoy]) {
        [[AppUtil appTopViewController]showHint:@"Please select the gender"];
        return;
    }
    if ([AppUtil isBlankString:birstyStr]) {
        [[AppUtil appTopViewController]showHint:@"Please choose your birthday"];
        return;
    }
    [self.birthdayBtn setTitle:birstyStr forState:UIControlStateNormal];
    NSString * str =@"clientAction.do?method=json&classes=appinterface&common=writeData";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    [dic setValue:self.nameTextF.text forKey:@"nickname"];
    [dic setValue:birstyStr forKey:@"pet_birthday"];
    [dic setValue:catOrDog forKey:@"pet_race"];
    [dic setValue:girlOrBoy forKey:@"pet_sex"];
    [dic setValue:self.mid forKey:@"mid"];
    
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        if ([json[@"jsondata"][@"retCode"] isEqualToString:@"0000"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    
        
    } failure:^(NSError *error) {
    }];

    
    
}


- (void)chooseOnebtn:(NSInteger )tag button:(UIButton *)sender
{
    [_nameTextF resignFirstResponder];
    
    switch (tag) {
        case 2004:
            if ([girlOrBoy isEqualToString:@"公"]) {
                girlOrBoy = @"";
            }else{
            girlOrBoy = @"公";
            }
            break;
        case 2003:
            if ([girlOrBoy isEqualToString:@"母"]) {
                 girlOrBoy = @"";
            }else{
            girlOrBoy = @"母";
            }
            break;
            
        case 2005:
            if ([catOrDog isEqualToString:@"喵"]) {
                catOrDog = @"";
            }else{
                catOrDog = @"喵";
            }
            break;
            
        case 2006:
            
            if ([catOrDog isEqualToString:@"汪"]) {
                catOrDog = @"";
            }else{
                catOrDog = @"汪";
            }
            break;
            
            
        default:
            break;
    }
    
    
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
