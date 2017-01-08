//
//  UploadImageTools.h
//  HaierMall
//
//  Created by 赵新成 on 16/10/28.
//  Copyright © 2016年 Haier e Commerce Co., Ltd of Haier Group. All rights reserved.
//上传图片工具类

#import <Foundation/Foundation.h>

@interface UploadImageTools : NSObject
/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数(后台规定传的字段)
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */
+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id response, NSError *error ))succeedBlock
                           failedBlock:(void(^)(id response, NSError *error ))failedBlock
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;



//自定义请求头
+(AFHTTPRequestSerializer *)customHeader;
@end
