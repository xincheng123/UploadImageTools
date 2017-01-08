//
//  UploadImageTools.m
//  HaierMall
//
//  Created by 赵新成 on 16/10/28.
//  Copyright © 2016年 Haier e Commerce Co., Ltd of Haier Group. All rights reserved.
//

#import "UploadImageTools.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@implementation UploadImageTools
//实现：
+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id response, NSError *error ))succeedBlock
                           failedBlock:(void(^)(id response, NSError *error ))failedBlock
                   uploadProgressBlock:(void (^)(float, long long, long long))uploadProgressBlock{
    
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //超时时长,默认是60秒,设置为120秒
    manager.requestSerializer.timeoutInterval = 120.f;
    //2.设置请求头
    manager.requestSerializer = [self customHeader];
    // 设置请求格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/xml",@"text/json",@"text/javascript",@"text/htnnml",@"text/plain",@"multipart/form-data",nil];
    //3.开始post请求
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (images.count > 0) {
            
            //根据当前系统时间生成图片名称
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:date];
            
            
            [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSData *imageData;
                
                //调整存储大小
                imageData = UIImageJPEGRepresentation(image,ratio);
                CGFloat sizeOriginKB = imageData.length / 1024.0;
//
                CGFloat resizeRate = ratio/2.0;
                //限制上传图片大小在250Kb之内
                while (sizeOriginKB > 250 && resizeRate > 0.01) {
                    imageData = UIImageJPEGRepresentation(image,resizeRate);
                    sizeOriginKB = imageData.length / 1024.0;
                    resizeRate = resizeRate/2.0;
                }

//                if (ratio > 0.0f && ratio < 1.0f) {
//                    imageData = UIImageJPEGRepresentation(image, ratio);
//                }else{
//                    imageData = UIImageJPEGRepresentation(image, 1.0f);
//                }
//                NSLog(@"fafafaaffaf");
//                imageData = UIImageJPEGRepresentation(image, 1.0f);
//                if (sizeOriginKB > 200) {
//                    [Tools alertWithMessage:@"图片过大,请更换图片"];
//                    return ;
//                }else{
//                    [SVProgressHUD dismiss];

                    NSLog(@"%tu(kB)",imageData.length/1024);
                    
                    //拼接图片数据
                    [formData appendPartWithFileData:imageData name:parameter fileName:[NSString stringWithFormat:@"%@%@.jpeg",dateString,@(idx)] mimeType:@"image/jpeg"];
                
                
//                }
               }];
        }
        
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            //成功的回调
            succeedBlock(responseObject,nil);
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"上传失败%@",error);
            failedBlock(nil,error);
        }];
}



//自定义请求头(这个请求头根据公司后台要求决定是否需要传)
+(AFHTTPRequestSerializer *)customHeader{
    
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //传token
    NSString *tokenStr = [LoginModel getLoginUserID];
    NSString *apiToken = [LLUserDefaults getValueWithKey:Api_Token];
    NSString *token = @""
    
    //添加请求头
    [requestSerializer setValue:token forHTTPHeaderField:@"key"];
    
    return requestSerializer;
}

@end
