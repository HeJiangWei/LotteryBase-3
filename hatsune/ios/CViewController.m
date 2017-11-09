//
//  CViewController.m
//  Array3
//
//  Created by 何江伟 on 2017/11/3.
//  Copyright © 2017年 何江伟. All rights reserved.
//

#import "CViewController.h"
#import "AppDelegate.h"
#import "JXTAlertManagerHeader.h"
#import "HomeViewController.h"
#define kApplication ((AppDelegate*) [[UIApplication sharedApplication] delegate])
#define SCREEN_W kApplication.window.frame.size.width
#define SCREEN_H kApplication.window.frame.size.height

@interface CViewController ()<UITextFieldDelegate>
@property (strong , nonatomic)UIButton *backButton;

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
//    imageView.image = [UIImage imageNamed:@"图层2"];
//    [self.view addSubview:imageView];
    
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W + 50, 2)];
//    lineView.center = self.view.center;
//    lineView.alpha = 0.8;
//    lineView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lineView];
    
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.backButton];
    
    
    
    UIButton *countButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2, SCREEN_H/4 - 30, 50, 50)];
    countButton.titleLabel.textAlignment = 1;
    [countButton setTitle:@"=" forState:0];
    countButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:40];
    [self.view addSubview:countButton];
    
    self.typeLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:100];
    
    [self.firstTextField becomeFirstResponder];
    
    
    self.firstTextField.delegate = self;
    self.firstTextField.tag = 99;
    self.secondTextField.delegate = self;
    
    NSLog(@"===%ld",[self cacluteSum:4]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(tongzhi:) name:UITextFieldTextDidChangeNotification object:nil];
    self.topDis.constant = self.view.frame.size.height/4 - 50;
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
//        UIUserInterfaceIdiomPad){
//        self.topDis.constant = self.view.frame.size.height/4 - 80 ;
//        self.leftDis.constant = 50;
////    self.leftDis.constant = 50;
//    }
//    else{
//        self.topDis.constant = self.view.frame.size.height/4 ;
//
//
//    }
    
    if ([self getIsIpad]){
        self.topDis.constant = self.view.frame.size.height/4 - 80 ;
        self.leftDis.constant = 0;
    }
    else{
        
        NSLog(@"---%f",self.view.frame.size.width);
        self.topDis.constant = self.view.frame.size.height/4 ;
        if (self.view.frame.size.width < 601) {
            self.topDis.constant = self.view.frame.size.height/4 - 30 ;
        }
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    
    if (selectIndex == 0) {
        self.thirdTextField.hidden = YES;
        self.fourthTextField.hidden = YES;
        self.typeLabel.text = @"A";
    }else if (selectIndex  == 1){
        self.thirdTextField.hidden = YES;
        self.fourthTextField.hidden = YES;
        self.typeLabel.text = @"c";
        
    }else if (selectIndex == 2){
        self.firstTextField.hidden = YES;
        self.secondTextField.hidden = YES;
        self.typeLabel.text = @"∑";
        
    }
    
    _selectIndex = selectIndex;
}




-(void)tongzhi:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    if (textField.text.length > 4) {
        jxt_showAlertTitleMessage(@"提示消息", @"最大数值不能大于9999");
        textField.text = [textField.text substringToIndex:4];
    }
    
    NSLog(@"%@",textField.text);
    
    
    if (self.selectIndex < 2) {
        if (self.firstTextField.text.length > 0 && self.secondTextField.text.length > 0 ) {
            
            
            if ( [self.firstTextField.text integerValue]>[self.secondTextField.text integerValue]) {
//                self.resultLabel.text = @"0.00";
                [self resuletLabelError:YES];
                return;
            }
            NSInteger fenzi = [self cacluteSum:[self.secondTextField.text integerValue]];
            NSInteger fenmu  = [self cacluteSum:([self.secondTextField.text integerValue]-[self.firstTextField.text integerValue])];
            self.resultLabel.text = [NSString stringWithFormat:@"%0.2f",(float)fenzi/fenmu];
            [self resuletLabelError:NO];

        }
    }else{
        if (self.thirdTextField.text.length > 0 && self.fourthTextField.text.length > 0 ) {
            
            
            if ( [self.fourthTextField.text integerValue]>[self.thirdTextField.text integerValue]) {
//                self.resultLabel.text = @"0";
                [self resuletLabelError:YES];

                return;
            }
//            NSInteger fenzi = [self cacluteSum:[self.thirdTextField.text integerValue]];
            NSInteger fenmu  = [self cacluteSum:[self.thirdTextField.text integerValue]] - [self cacluteSum:[self.fourthTextField.text integerValue]];
            self.resultLabel.text = [NSString stringWithFormat:@"%ld",fenmu];
            [self resuletLabelError:NO];

        }
        
    }
  
    
}

- (void)resuletLabelError:(BOOL)isright
{
    if (isright) {
        self.resultLabel.textColor = [UIColor lightGrayColor];
        self.resultLabel.text = @"m must bigger than n";

    }else{
        self.resultLabel.textColor = [UIColor whiteColor];

    }
    
}




-(UIButton *)backButton
{
    
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 70, 20, 50, 50)];
        [_backButton setImage:[UIImage imageNamed:@"返回键"] forState:0];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    }
    return _backButton;
}


- (void)back
{
    AppDelegate *delegate = kApplication;
    HomeViewController *nvc = [HomeViewController new];
    [UIView transitionWithView:delegate.window duration:0.5f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        delegate.window.rootViewController = nvc;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userInfoDic"];
    }];
    
}



-(NSInteger)cacluteSum:(NSInteger )number
{
    NSInteger sum = 0;
    for (int i = 1; i <= number; i ++) {
        sum += i;
        }
    return sum;
}




//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//
//
//    NSLog(@"=======%@===%@",textField.text,string);
//
//    if (textField.tag == 99) {
//        if (textField.text.length > 0 && self.secondTextField.text.length > 0) {
//            NSInteger fenzi = [self cacluteSum:[self.secondTextField.text integerValue]];
//            NSInteger fenmu  = [self cacluteSum:([self.secondTextField.text integerValue]-[textField.text integerValue])];
//            self.resultLabel.text = [NSString stringWithFormat:@"%0.2f",(float)fenzi/fenmu];
//
//        }
//    }else{
//        if (self.firstTextField.text.length > 0 && textField.text > 0) {
//            NSInteger fenzi = [self cacluteSum:[textField.text integerValue]];
//            NSInteger fenmu  = [self cacluteSum:([textField.text integerValue]-[self.firstTextField.text integerValue])];
//            self.resultLabel.text = [NSString stringWithFormat:@"%0.2f",(float)fenzi/fenmu];
//        }
//
//    }
//
//
//
//    return YES;
//
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


//如果想要判断设备是ipad，要用如下方法
- (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}


@end

