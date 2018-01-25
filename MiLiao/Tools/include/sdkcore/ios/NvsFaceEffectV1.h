//================================================================================
//
// (c) Copyright China Digital Video (Beijing) Limited, 2017. All rights reserved.
//
// This code and information is provided "as is" without warranty of any kind,
// either expressed or implied, including but not limited to the implied
// warranties of merchantability and/or fitness for a particular purpose.
//
//--------------------------------------------------------------------------------
//   Birth Date:    Aug 2. 2017
//   Author:        NewAuto video team
//================================================================================
#pragma once

#import <Foundation/Foundation.h>

@interface NvsFaceEffectV1 : NSObject

/*!
   \brief 初始化人脸特效
*/
+(void) InitFaceEffectV1:(NSString*) bundlePath authPackage:(void *)package authSize:(int)size;


/*!
    \brief 开启多人检测模式，最多可同时检测 8 张人脸，默认检测 1 张人脸
*/
+(void) SetMaxFaces:(int) maxFaceCount;

@end
