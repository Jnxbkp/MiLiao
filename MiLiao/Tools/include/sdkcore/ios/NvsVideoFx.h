﻿//================================================================================
//
// (c) Copyright China Digital Video (Beijing) Limited, 2016. All rights reserved.
//
// This code and information is provided "as is" without warranty of any kind,
// either expressed or implied, including but not limited to the implied
// warranties of merchantability and/or fitness for a particular purpose.
//
//--------------------------------------------------------------------------------
//   Birth Date:    Dec 29. 2016
//   Author:        NewAuto video team
//================================================================================
#pragma once

#import "NvsFx.h"


/*!
 *  \brief
 *  视频特效类型
 */
typedef enum {
    NvsVideoFxType_Builtin = 0,
    NvsVideoFxType_Package,
    NvsVideoFxType_Custom
} NvsVideoFxType;

/*!
    \brief 视频特效

    视频特效是显示在视频片段上的特效，能够改变视频图像整体或者局部的颜色、亮度、透明度等，使视频显示出特殊的效果。在视频片段(Video Clip)上，可以添加、移除、获取多个视频特效。
 */
@interface NvsVideoFx : NvsFx

@property (readonly) NvsVideoFxType videoFxType; //!< 视频特效类型
@property (readonly) NSString *bultinVideoFxName; //!< 内嵌视频特效名字。如果不是内嵌视频特效返回nil
@property (readonly) NSString *videoFxPackageId; //!< 视频特效资源包ID。如果不是资源包视频特效返回nil
@property (readonly) unsigned int index;  //!< 视频特效索引

@end

