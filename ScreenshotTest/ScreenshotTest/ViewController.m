//
//  ViewController.m
//  ScreenshotTest
//
//  Created by huangjian on 2018/8/16.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenShoting:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    //你还好吗
}
-(void)screenShoting:(NSNotification *)noti
{
    NSLog(@"截图ing");
}
-(void)screenShot
{
    UIWindow *screenWindow = [[UIApplication sharedApplication]keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [@"我了个去" drawInRect:CGRectMake(20, 40, 80, 30) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage,nil,nil,nil);
}
//清晰度高点
-(void)screenShot1
{
    UIImage *image=[UIImage imageWithData:[self dataWithScreenshotInPNGFormat]];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    // opaque 透明度，不透明设为YES； scale  缩放因子，设0时系统自动设置缩放比例图片清晰；设1.0时模糊
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    [@"蛮漂亮的哟" drawInRect:CGRectMake(20, 100, 300, 30) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30],NSForegroundColorAttributeName:[UIColor redColor]}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self screenShot1];
}
@end
