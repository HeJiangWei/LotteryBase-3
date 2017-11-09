//
//  CViewController.h
//  Array3
//
//  Created by 何江伟 on 2017/11/3.
//  Copyright © 2017年 何江伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *thirdTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourthTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDis;


@property(nonatomic,assign)NSInteger selectIndex;

@end
