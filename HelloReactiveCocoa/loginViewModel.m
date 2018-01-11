//
//  loginViewModel.m
//  HelloReactiveCocoa
//
//  Created by 任前辈 on 2018/1/11.
//  Copyright © 2018年 任前辈. All rights reserved.
//

#import "loginViewModel.h"

@implementation Account


@end

@implementation loginViewModel

-(Account *)user{
    if (!_user) {
        _user = [[Account alloc] init];
        [RACObserve(_user, account) subscribeNext:^(id  _Nullable x) {
            NSLog(@"发生了变化哟%@",x);
        }];

    }
    return _user;
}
-(instancetype)init{
    self = [super init];
    [self initBind];
    return self;
}
//初始化信号
-(void)initBind{
    
    //监听账号的属性值改变，把他们聚合成一个信号。
    _loginEnabledSingle = [RACSignal combineLatest:@[RACObserve(self.user, account),RACObserve(self.user, pwd)] reduce:^id(NSString *account,NSString*pwd){
        return @(account.length==6&&pwd.length==7);
    }];
    
    //处理登录业务逻辑
    _loginComand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"点击登录%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //网络请求
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"登录成功"];
                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            });
//            [self loadData] subscribeNext:^(id  _Nullable x) {
//                [subscriber sendNext:x];
//                [subscriber sendCompleted];
//            }
            return nil;
        }]  ;
    }];
    // 监听登录产生的数据
    [_loginComand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@" 监听登录产生的数据==%@",x);
    }];
    
    //监听登录状态 command创建的时候 也会调用一次信号,所以过滤掉第一条信号
    [[_loginComand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            //
            NSLog(@"正在登录ing");
        }else{
            NSLog(@"登录结束");
        }
    }];
    
    
    //
    
    _login2Comand = [[RACCommand alloc] initWithEnabled:self.loginEnabledSingle signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       //点击logini
        NSLog(@"%@",input);
        return [[self loadData] map:^id _Nullable(id  _Nullable value) {
            return [NSString stringWithFormat:@"请求结果组合值%@",value];
        }]  ;
        
    }];
    
    [[_login2Comand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            NSLog(@"正在登录ing");
        }else{
            NSLog(@"登录结束");
        }
    }];
    // 监听登录产生的数据
    [_login2Comand.executionSignals.switchToLatest subscribeNext:^(NSString* x) {
        // 监听登录产生的数据
        NSLog(x);
    } error:^(NSError * _Nullable error) {
        NSLog(error);
    }];
}


-(RACSignal*)loadData{
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"未分配威锋网IE服务if接我ewjfpew"];
        [subscriber sendCompleted];
        return  nil;
    }]delay:3] ;
}

@end


