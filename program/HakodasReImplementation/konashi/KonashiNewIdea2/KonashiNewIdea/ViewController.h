//
//  ViewController.h
//  GettingStarted
//
//  Created by Yukai Engineering Inc on 2015/08/04.
//  Copyright (c) 2015年 Yukai Engineering Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//ラベル定義
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UILabel *adcValue;
@property (weak, nonatomic) IBOutlet UILabel *jesture;
@property (weak, nonatomic) IBOutlet UILabel *xdata;
@property (weak, nonatomic) IBOutlet UILabel *ydata;

//ボタン定義
- (IBAction)find:(id)sender;
- (IBAction)requestRead:(id)sender;
- (IBAction)reset:(id)sender;

@end

