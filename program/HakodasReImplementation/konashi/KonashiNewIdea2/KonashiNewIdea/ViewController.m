//
//  ViewController.m
//  GettingStarted
//
//  Created by Yukai Engineering Inc on 2015/08/04.
//  Copyright (c) 2015年 Yukai Engineering Inc. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"
#import <mach/mach_time.h>

@interface ViewController (){
    UIImageView *imageView;
}
@end


@implementation ViewController

#define NONE 0
#define TOUCH 1
#define PUSH 2
#define UP 3
#define DOWN 4


int FLAG = 0;
int other = 0;
int first = 0;

int mNormalValue = 100;
int mTouchThreshold = 170;
int mWhatThreshold = 80;
uint64_t start, end, elapsed;
uint64_t printime;
mach_timebase_info_data_t base;
long long int motiontime;
int sensor[300]={0,};
int num = 0;
int fst,snd;
int i,j,k;
Boolean onoff = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //接続成功時
    [[Konashi shared] setConnectedHandler:^{
        NSLog(@"CONNECTED");
    }];
    
    //処理準備完了時
    [[Konashi shared] setReadyHandler:^{
        NSLog(@"READY");
        self.statusMessage.hidden = NO;
        [Konashi initialize];
        [Konashi analogReadRequest:KonashiAnalogIO0];
    }];
    
    //アナログピンの値が変化した時
    [[Konashi shared] setAnalogPinDidChangeValueHandler:^(KonashiAnalogIOPin pin, int value) {
        [Konashi analogReadRequest:KonashiAnalogIO0];
        NSLog(@"READ_AIO0: %d", [Konashi analogRead:KonashiAnalogIO0]);
        self.adcValue.text = [NSString stringWithFormat:@"%d",[Konashi analogRead:KonashiAnalogIO0]];
        
        //文字を表示する
        switch(FLAG){
            case NONE:
                self.jesture.text = [NSString stringWithFormat:@"NONE"];
                
                break;
            case TOUCH:
                self.jesture.text = [NSString stringWithFormat:@"TOUCH"];
                NSLog(@"TOUCH");
                sleep(0.5);
                break;
            case PUSH:
                self.jesture.text = [NSString stringWithFormat:@"PUSH"];
                NSLog(@"PUSH");
                sleep(0.5);
                break;
            case UP:
                self.jesture.text = [NSString stringWithFormat:@"UP"];
                NSLog(@"UP");
                sleep(0.5);
                break;
            case DOWN:
                self.jesture.text = [NSString stringWithFormat:@"DOWN"];
                NSLog(@"DOWN");
                sleep(0.5);
                break;
        }
        
        //時間測定(怪しい値を取得した時間)ここから
        if(first == 0){
            first = [Konashi analogRead:KonashiAnalogIO0];
        }
        if(other != 0){
            if(other > 10){
                FLAG = NONE;
            }
            other++;
            if(other > 30){
                other = 0;
            }
            NSLog(@"NUM: %d",other);
        }
        else if((mWhatThreshold+first < [Konashi analogRead:KonashiAnalogIO0])){
            if(num == 0){
                start = mach_absolute_time();
            }
            sensor[num] = [Konashi analogRead:KonashiAnalogIO0];
            num++;
            NSLog(@"NUM: %d", num);
        }
        end = mach_absolute_time();
        mach_timebase_info(&base);
        motiontime = (end-start)/base.denom;
        NSLog(@"TIME: %lld", motiontime);
        
        if((other == 0)&&(num != 0) &&((((end-start)/base.denom) > 3000000 )||([Konashi analogRead:KonashiAnalogIO0] < mWhatThreshold+first))){
            NSLog(@"get");
            
            //UP,DOWNの判定
            if(((end-start)/base.denom < 3000000)){
                fst = 0;    snd = 0;
                for(i = 0;i < num/2;i++){
                    fst += sensor[i];
                }for(i = num/2;i < num;i++){
                    snd += sensor[i];
                }
                if(fst < snd){
                    FLAG = DOWN;
                    other = 1;
                }else{
                    FLAG = UP;
                    other = 1;
                }
                num = 0;
                
                //TOUCH,PUSHの判定
            }else{
                if(([Konashi analogRead:KonashiAnalogIO0] <   mTouchThreshold+first*1.5)){
                    FLAG = TOUCH;
                    other = 1;
                }if((mTouchThreshold+first*1.5 < [Konashi analogRead:KonashiAnalogIO0])){
                    FLAG = PUSH;
                    other = 1;
                }
                num = 0;
            }
        }
    }];
    
    // パン（ドラッグ）
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 3;
    [self.view addGestureRecognizer:panGesture];
    
    
    [self initImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//数本指によるドラッグ・ピンチ操作
- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint tapPoint = [sender translationInView:self.view];
    NSLog(@"tapPoint xy : %f %f",tapPoint.x, tapPoint.y);
    self.xdata.text = [NSString stringWithFormat:@"%f",tapPoint.x];
    self.ydata.text = [NSString stringWithFormat:@"%f",tapPoint.y];
    if((FLAG == TOUCH) && (tapPoint.x < 1) && (tapPoint.y < 1))
        imageView.transform = CGAffineTransformMakeScale(tapPoint.x, tapPoint.y);
}

//画像の基本設定
- (void)initImageView {
    UIImage *image1 = [UIImage imageNamed:@"sample.jpeg"];
    imageView = [[UIImageView alloc] initWithImage:image1];
    [imageView setCenter:CGPointMake(160.0f, 100.0f)];
    imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self.view addSubview:imageView];
}

//findを押した場合
- (IBAction)find:(id)sender {
    [Konashi find];
}

//resetを押した場合
- (IBAction)reset:(id)sender{
    first = [Konashi analogRead:KonashiAnalogIO0];
}

@end
