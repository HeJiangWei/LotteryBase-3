//
//  BaseViewController.m
//  Array3
//
//  Created by 何江伟 on 2017/11/3.
//  Copyright © 2017年 何江伟. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#define kApplication ((AppDelegate*) [[UIApplication sharedApplication] delegate])
#define SCREEN_W kApplication.window.frame.size.width
#define SCREEN_H kApplication.window.frame.size.height



@interface BaseViewController ()

@property (strong , nonatomic)UIButton *backButton;


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    imageView.image = [UIImage imageNamed:@"图层2"];
    [self.view addSubview:imageView];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W + 50, 2)];
    lineView.center = self.view.center;
    lineView.alpha = 0.8;
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.backButton];
    
    
    UIButton *countButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2, SCREEN_H/4 - 30, 50, 50)];
    countButton.titleLabel.textAlignment = 1;
    [countButton setTitle:@"=" forState:0];
    countButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:30];
    [self.view addSubview:countButton];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
