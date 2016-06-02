//
//  ViewController.h
//  blueTooth
//
//  Created by 张 荣桂 on 16/6/2.
//  Copyright © 2016年 张 荣桂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgs;
- (IBAction)connect:(UIButton *)sender;
- (IBAction)addimg:(UIButton *)sender;
- (IBAction)send:(UIButton *)sender;

@end

