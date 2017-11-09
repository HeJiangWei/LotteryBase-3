//
//  JXTAlertController.m
//  JXTAlertManager
//
//  Created by JXT on 2016/12/22.
//  Copyright © 2016年 JXT. All rights reserved.
//

#import "JXTAlertController.h"

//toast默认展示时间
static NSTimeInterval const JXTAlertShowDurationDefault = 1.0f;


#pragma mark - I.AlertActionModel
@interface JXTAlertActionModel : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) UIAlertActionStyle style;
@end
@implementation JXTAlertActionModel
- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}
@end



#pragma mark - II.JXTAlertController
/**
 AlertActions配置

 @param actionBlock JXTAlertActionBlock
 */
typedef void (^JXTAlertActionsConfig)(JXTAlertActionBlock actionBlock);


@interface JXTAlertController ()
//JXTAlertActionModel数组
@property (nonatomic, strong) NSMutableArray <JXTAlertActionModel *>* jxt_alertActionArray;
//是否操作动画
@property (nonatomic, assign) BOOL jxt_setAlertAnimated;
//action配置
- (JXTAlertActionsConfig)alertActionsConfig;
@end

@implementation JXTAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.alertDidDismiss) {
        self.alertDidDismiss();
    }
}
- (void)dealloc
{
//    NSLog(@"test-dealloc");
}

#pragma mark - Private
//action-title数组
- (NSMutableArray<JXTAlertActionModel *> *)jxt_alertActionArray
{
    if (_jxt_alertActionArray == nil) {
        _jxt_alertActionArray = [NSMutableArray array];
    }
    return _jxt_alertActionArray;
}
//action配置
- (JXTAlertActionsConfig)alertActionsConfig
{
    return ^(JXTAlertActionBlock actionBlock) {
        if (self.jxt_alertActionArray.count > 0)
        {
            //创建action
            __weak typeof(self)weakSelf = self;
            [self.jxt_alertActionArray enumerateObjectsUsingBlock:^(JXTAlertActionModel *actionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionModel.title style:actionModel.style handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                //可利用这个改变字体颜色，但是不推荐！！！
//                [alertAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
                //action作为self元素，其block实现如果引用本类指针，会造成循环引用
                [self addAction:alertAction];
            }];
        }
        else
        {
            NSTimeInterval duration = self.toastStyleDuration > 0 ? self.toastStyleDuration : JXTAlertShowDurationDefault;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:!(self.jxt_setAlertAnimated) completion:NULL];
            });
        }
    };
}

#pragma mark - Public

- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    if (!(title.length > 0) && (message.length > 0) && (preferredStyle == UIAlertControllerStyleAlert)) {
        title = @"";
    }
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (!self) return nil;
    
    self.jxt_setAlertAnimated = NO;
    self.toastStyleDuration = JXTAlertShowDurationDefault;
    
    return self;
}

- (void)alertAnimateDisabled
{
    self.jxt_setAlertAnimated = YES;
}

- (JXTAlertActionTitle)addActionDefaultTitle
{
    //该block返回值不是本类属性，只是局部变量，不会造成循环引用
    return ^(NSString *title) {
        JXTAlertActionModel *actionModel = [[JXTAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.jxt_alertActionArray addObject:actionModel];
        return self;
    };
}

- (JXTAlertActionTitle)addActionCancelTitle
{
    return ^(NSString *title) {
        JXTAlertActionModel *actionModel = [[JXTAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleCancel;
        [self.jxt_alertActionArray addObject:actionModel];
        return self;
    };
}

- (JXTAlertActionTitle)addActionDestructiveTitle
{
    return ^(NSString *title) {
        JXTAlertActionModel *actionModel = [[JXTAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.jxt_alertActionArray addObject:actionModel];
        return self;
    };
}

@end



#pragma mark - III.UIViewController扩展
@implementation UIViewController (JXTAlertController)

- (void)jxt_showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle title:(NSString *)title message:(NSString *)message appearanceProcess:(JXTAlertAppearanceProcess)appearanceProcess actionsBlock:(JXTAlertActionBlock)actionBlock
{
    if (appearanceProcess)
    {
        JXTAlertController *alertMaker = [[JXTAlertController alloc] initAlertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        //防止nil
        if (!alertMaker) {
            return ;
        }
        //加工链
        appearanceProcess(alertMaker);
        //配置响应
        alertMaker.alertActionsConfig(actionBlock);
//        alertMaker.alertActionsConfig(^(NSInteger buttonIndex, UIAlertAction *action){
//            if (actionBlock) {
//                actionBlock(buttonIndex, action);
//            }
//        });
        
        if (alertMaker.alertDidShown)
        {
            [self presentViewController:alertMaker animated:!(alertMaker.jxt_setAlertAnimated) completion:^{
                alertMaker.alertDidShown();
            }];
        }
        else
        {
            [self presentViewController:alertMaker animated:!(alertMaker.jxt_setAlertAnimated) completion:NULL];
        }
    }
}

- (void)jxt_showAlertWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(JXTAlertAppearanceProcess)appearanceProcess actionsBlock:(JXTAlertActionBlock)actionBlock
{
    [self jxt_showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

- (void)jxt_showActionSheetWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(JXTAlertAppearanceProcess)appearanceProcess actionsBlock:(JXTAlertActionBlock)actionBlock
{
    [self jxt_showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}


//#pragma mark alert使用示例
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (indexPath.section == 0)
//    {
//        if (indexPath.row == 0)
//        {
//            //1.
//            //            [JXTAlertView showAlertViewWithTitle:@"title" message:@"message" cancelButtonTitle:@"cancel" otherButtonTitle:@"other" cancelButtonBlock:^(NSInteger buttonIndex) {
//            //                NSLog(@"cancel");
//            //            } otherButtonBlock:^(NSInteger buttonIndex) {
//            //                NSLog(@"other");
//            //            }];
//            //2.
//            jxt_showAlertTwoButton(@"常规两个按钮alert", @"支持按钮点击回调，支持C函数快速调用", @"cancel", ^(NSInteger buttonIndex) {
//                NSLog(@"cancel");
//            }, @"other", ^(NSInteger buttonIndex) {
//                NSLog(@"other");
//            });
//        }
//        else if (indexPath.row == 1)
//        {
//            jxt_showAlertTitle(@"简易调试使用alert，单按钮，标题默认为“确定”");
//        }
//        else if (indexPath.row == 2)
//        {
//            [JXTAlertView showAlertViewWithTitle:@"不定数量按钮alert" message:@"支持按钮点击回调，根据按钮index区分响应，有cancel按钮时，cancel的index默认0，无cancel时，按钮index根据添加顺序计算" cancelButtonTitle:@"cancel" buttonIndexBlock:^(NSInteger buttonIndex) {
//                if (buttonIndex == 0) {
//                    NSLog(@"cancel");
//                }
//                else if (buttonIndex == 1) {
//                    NSLog(@"按钮1");
//                }
//                else if (buttonIndex == 2) {
//                    NSLog(@"按钮2");
//                }
//                else if (buttonIndex == 3) {
//                    NSLog(@"按钮3");
//                }
//                else if (buttonIndex == 4) {
//                    NSLog(@"按钮4");
//                }
//                else if (buttonIndex == 5) {
//                    NSLog(@"按钮5");
//                }
//            } otherButtonTitles:@"按钮1", @"按钮2", @"按钮3", @"按钮4", @"按钮5", nil];
//        }
//        else if (indexPath.row == 3)
//        {
//            //1.
//            [JXTAlertView showToastViewWithTitle:@"无按钮toast样式" message:@"可自定义展示延时时间，支持关闭回调" duration:2 dismissCompletion:^(NSInteger buttonIndex) {
//                NSLog(@"关闭");
//            }];
//            //2.
//            //            jxt_showToastTitleDismiss(@"无按钮toast样式", 2, ^(NSInteger buttonIndex) {
//            //                NSLog(@"关闭");
//            //            });
//            //3.
//            //            jxt_showToastMessage(@"无按钮toast样式", 0);
//        }
//        else if (indexPath.row == 4)
//        {
//            //1.
//            //            jxt_showTextHUDTitle(@"单文字HUD");
//            //2.
//            jxt_showTextHUDTitleMessage(@"单文字HUD", @"支持子标题，手动执行关闭，可改变显示状态");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                jxt_dismissHUD();
//            });
//        }
//        else if (indexPath.row == 5)
//        {
//            jxt_showLoadingHUDTitleMessage(@"带indicatorView的HUD", @"支持子标题，手动执行关闭，可改变显示状态");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                jxt_dismissHUD();
//            });
//        }
//        else if (indexPath.row == 6)
//        {
//            jxt_showProgressHUDTitleMessage(@"带进度条的HUD", @"支持子标题，手动执行关闭，可改变显示状态");
//            __block float count = 0;
//#warning timer block ios10 only
//            [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                count += 0.05;
//                jxt_setHUDProgress(count);
//                if (count > 1) {
//                    [timer invalidate];
//                    jxt_setHUDSuccessTitle(@"加载成功！");
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        jxt_dismissHUD();
//                    });
//                }
//            }];
//        }
//        else if (indexPath.row == 7)
//        {
//            jxt_showProgressHUDTitleMessage(@"带进度条的HUD", @"支持子标题，手动执行关闭，可改变显示状态");
//            __block float count = 0;
//#warning timer block ios10 only
//            [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                count += 0.05;
//                jxt_setHUDProgress(count);
//                if (count > 1) {
//                    [timer invalidate];
//                    jxt_setHUDFailMessage(@"加载失败！");
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        jxt_dismissHUD();
//                    });
//                }
//            }];
//        }
//    }
//    else if (indexPath.section == 1)
//    {
//        if (indexPath.row == 0)
//        {
//            [self jxt_showAlertWithTitle:@"常规alertController-Alert" message:@"基于系统UIAlertController封装，按钮以链式语法模式快捷添加，可根据按钮index区分响应，可根据action区分响应，支持配置弹出、关闭回调，可关闭弹出动画" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//                alertMaker.
//                addActionCancelTitle(@"cancel").
//                addActionDestructiveTitle(@"按钮1");
//            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
//                if (buttonIndex == 0) {
//                    NSLog(@"cancel");
//                }
//                else if (buttonIndex == 1) {
//                    NSLog(@"按钮1");
//                }
//                NSLog(@"%@--%@", action.title, action);
//            }];
//        }
//        else if (indexPath.row == 1)
//        {
//            [self jxt_showActionSheetWithTitle:@"常规alertController-ActionSheet" message:@"基于系统UIAlertController封装，按钮以链式语法模式快捷添加，可根据按钮index区分响应，可根据action区分响应，支持配置弹出、关闭回调，可关闭弹出动画" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//                alertMaker.
//                addActionCancelTitle(@"cancel").
//                addActionDestructiveTitle(@"按钮1").
//                addActionDefaultTitle(@"按钮2").
//                addActionDefaultTitle(@"按钮3").
//                addActionDestructiveTitle(@"按钮4");
//            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
//                
//                if ([action.title isEqualToString:@"cancel"]) {
//                    NSLog(@"cancel");
//                }
//                else if ([action.title isEqualToString:@"按钮1"]) {
//                    NSLog(@"按钮1");
//                }
//                else if ([action.title isEqualToString:@"按钮2"]) {
//                    NSLog(@"按钮2");
//                }
//                else if ([action.title isEqualToString:@"按钮3"]) {
//                    NSLog(@"按钮3");
//                }
//                else if ([action.title isEqualToString:@"按钮4"]) {
//                    NSLog(@"按钮4");
//                }
//            }];
//        }
//        else if (indexPath.row == 2)
//        {
//            [self jxt_showAlertWithTitle:@"无按钮alert-toast" message:@"toast样式，可自定义展示延时时间，支持配置弹出、关闭回调，可关闭弹出动画" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//                alertMaker.toastStyleDuration = 2;
//                [alertMaker setAlertDidShown:^{
//                    [self logMsg:@"alertDidShown"];//不用担心循环引用
//                }];
//                alertMaker.alertDidDismiss = ^{
//                    [self logMsg:@"alertDidDismiss"];
//                };
//            } actionsBlock:NULL];
//        }
//        else if (indexPath.row == 3)
//        {
//            [self jxt_showActionSheetWithTitle:@"无按钮actionSheet-toast" message:@"toast样式，可自定义展示延时时间，支持配置弹出、关闭回调，可关闭弹出动画" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//                alertMaker.toastStyleDuration = 3;
//                //关闭动画效果
//                [alertMaker alertAnimateDisabled];
//                
//                [alertMaker setAlertDidShown:^{
//                    NSLog(@"alertDidShown");
//                }];
//                alertMaker.alertDidDismiss = ^{
//                    NSLog(@"alertDidDismiss");
//                };
//            } actionsBlock:NULL];
//        }
//        else if (indexPath.row == 4)
//        {
//            [self jxt_showAlertWithTitle:@"带输入框的alertController-Alert" message:@"点击按钮，控制台打印对应输入框的内容" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//                alertMaker.
//                addActionDestructiveTitle(@"获取输入框1").
//                addActionDestructiveTitle(@"获取输入框2");
//                
//                [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                    textField.placeholder = @"输入框1-请输入";
//                }];
//                [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                    textField.placeholder = @"输入框2-请输入";
//                }];
//            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
//                if (buttonIndex == 0) {
//                    UITextField *textField = alertSelf.textFields.firstObject;
//                    [self logMsg:textField.text];//不用担心循环引用
//                }
//                else if (buttonIndex == 1) {
//                    UITextField *textField = alertSelf.textFields.lastObject;
//                    [self logMsg:textField.text];
//                }
//            }];
//        }
//    }
//}



@end

