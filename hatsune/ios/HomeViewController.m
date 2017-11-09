//
//  HomeViewController.m
//  Array3
//
//  Created by 何江伟 on 2017/11/3.
//  Copyright © 2017年 何江伟. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseViewController.h"
#import "CViewController.h"
#import "AppDelegate.h"

#define kApplication ((AppDelegate*) [[UIApplication sharedApplication] delegate])


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    backImageView.image = [UIImage imageNamed:@"选择公式界面"];
//    [self.view addSubview:backImageView];
    
    
    
    // Do any additional setup after loading the view from its nib.
//    NSArray *familyNames = [UIFont familyNames];
//    for( NSString *familyName in familyNames )
//    {
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for( NSString *fontName in fontNames )
//        {
//            printf( "\tFont: %s \n", [fontName UTF8String] );
//        }
//
//    }
    

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

- (IBAction)firstAction:(id)sender {
    
    AppDelegate *delegate = kApplication;
    CViewController *nvc = [CViewController new];

    [UIView transitionWithView:delegate.window duration:0.5f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        delegate.window.rootViewController = nvc;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userInfoDic"];
    }];
    nvc.selectIndex = 0;

    
}

- (IBAction)secondAction:(id)sender {
    
    AppDelegate *delegate = kApplication;
    CViewController *nvc = [CViewController new];
    [UIView transitionWithView:delegate.window duration:0.5f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        delegate.window.rootViewController = nvc;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userInfoDic"];
    }];
    nvc.selectIndex = 1;

}

- (IBAction)thirdAction:(id)sender {
    
    AppDelegate *delegate = kApplication;
    CViewController *nvc = [CViewController new];

    [UIView transitionWithView:delegate.window duration:0.5f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        delegate.window.rootViewController = nvc;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userInfoDic"];
    }];
    nvc.selectIndex = 2;

}
@end
