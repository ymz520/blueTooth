//
//  ViewController.m
//  blueTooth
//
//  Created by 张 荣桂 on 16/6/2.
//  Copyright © 2016年 张 荣桂. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,GKPeerPickerControllerDelegate>
@property(nonatomic,strong)GKSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark——建立蓝牙连接
- (IBAction)connect:(UIButton *)sender
{
    //1.创建
    GKPeerPickerController *peerctl=[[GKPeerPickerController alloc]init];
    //2.
    peerctl.delegate=self;
    //3.显示蓝牙控制器
    [peerctl show];

    
    
}
#pragma mark-代理方法
//    4.实现代理方法
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    NSLog(@"%@",peerID);
    //保存会话
    self.session=session;
    //接收会话Handler(处理程序)
    [self.session setDataReceiveHandler:self withContext:nil];
    //关闭显示蓝牙控制器
    [picker dismiss];
    
}
#pragma mark-接收到其他的设备
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    NSLog(@"%s",__func__);
}
-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{

}
- (IBAction)addimg:(UIButton *)sender
{
    //1.创建图片选择器
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    //2.判断图库是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        //设置打开图库类型
        imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate=self;
        //打开图片选择控制器
        [self presentViewController:imagePicker animated:YES completion:nil ];
    }
    
}

#pragma mark-实现代理里的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.imgs.image=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@",info);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)send:(UIButton *)sender
{
    //1.
    NSData *dataimg=UIImagePNGRepresentation(self.imgs.image);
    [self.session sendDataToAllPeers:dataimg withDataMode:GKSendDataReliable error:nil];
//    self.session sendData:dataimg toPeers: withDataMode: error:nil
}
@end
