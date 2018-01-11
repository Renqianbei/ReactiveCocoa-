//
//  ViewController.m
//  HelloReactiveCocoa
//
//  Created by 任前辈 on 2018/1/11.
//  Copyright © 2018年 任前辈. All rights reserved.
//

#import "ViewController.h"
#import "loginViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginF;
@property (weak, nonatomic) IBOutlet UITextField *pwdF;
@property (weak, nonatomic) IBOutlet UIButton *loginB;
@property (nonatomic, strong)loginViewModel * viewModel;
@property (nonatomic, strong)UIActivityIndicatorView*juhua;

@end

@implementation ViewController
-(UIActivityIndicatorView *)juhua{
    if (!_juhua) {
        _juhua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _juhua.center = self.view.center;
        _juhua.hidden = true;
        [self.view addSubview:_juhua];
    }
    return _juhua;
}
-(loginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[loginViewModel alloc] init];
    }
    return _viewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)bindViewModel{
    //给模型的属性绑定信号
    // 只要账号文本框一改变，就会给account赋值
    RAC(self.viewModel.user,account) = _loginF.rac_textSignal ;
    RAC(self.viewModel.user,pwd)  = _pwdF.rac_textSignal;
    //绑定登录按钮
//    RAC(_loginB,enabled) = self.viewModel.loginEnabledSingle;
//    //监听登录按钮点击事件
//    [[_loginB rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        //执行登录事件
//        [self.viewModel.loginComand execute:x];
//    }];
    _loginB.rac_command = self.viewModel.login2Comand;
    [[self.viewModel.login2Comand.executing skip:1] subscribeNext:^(NSNumber * _Nullable isloging){
        if (isloging.boolValue) {
            [self.juhua startAnimating];
        } else {
            [self.juhua stopAnimating];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
