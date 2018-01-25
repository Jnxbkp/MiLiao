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

/*! \file NvsTrack.h
 */
#pragma once

#import "NvsObject.h"

typedef enum NvsTrackType {
    NvsTrackType_Video = 0,  /*!< 视频(0)*/
    NvsTrackType_Audio,      /*!< 音频 */
} NvsTrackType;              /*!< NvsTrackType表示轨道类型 */

/*!
     \brief 轨道，容纳片段的实体
 
     轨道可视作片段的集合,分为音频轨道(Audio Track)和视频轨道(Video Track)。创建时间线实例后，可添加或移除多条轨道。在每一条轨道上，可以添加多个要编辑的视音频片段，并对片段进行音量设置，也可以进行移除和位置移动。
 */
@interface NvsTrack : NvsObject

@property (readonly) NvsTrackType type;  //!< 轨道类型设置[NvsTrackType] (@ref NvsTrackType) (0表示视频，1表示音频)

@property (readonly) unsigned int index; //!< 轨道索引

@property (readonly) int64_t duration;  //!< 轨道长度(单位微秒)

@property (readonly) unsigned int clipCount; //!< 轨道上的片段数量

/*!
 *  \brief 修改片段时间线上的入点
 *  \param clipIndex 片段索引
 *  \param newInPoint 新时间线上的入点（单位微秒）
 *  \return 返回实际可到达的时间线上的入点（单位微秒）。注意：实际可达到的时间线上的入点范围在前一个片段的时间线出点与此片段的时间线出点的开区间内
 *  \warning 此接口会引发流媒体引擎状态跳转到引擎停止状态，具体情况请参见[引擎变化专题] (\ref EngineChange.md)。
 *  \since 1.6.0
 *  \sa changeOutPoint:newOutPoint:
 */
- (int64_t)changeInPoint:(unsigned int)clipIndex newInPoint:(int64_t)newInPoint;

/*!
 *  \brief 修改片段时间线上的出点
 *  \param clipIndex 片段索引
 *  \param newOutPoint 新时间线上的出点（单位微秒）
 *  \return 返回实际可到达的时间线上的出点（单位微秒）。注意：实际可达到的时间线上的出点范围在此片段的时间线入点与后一个片段的时间线入点的开区间内
 *  \warning 此接口会引发流媒体引擎状态跳转到引擎停止状态，具体情况请参见[引擎变化专题] (\ref EngineChange.md)。
 *  \since 1.6.0
 *  \sa changeInPoint:newInPoint:
 */
- (int64_t)changeOutPoint:(unsigned int)clipIndex newOutPoint:(int64_t)newOutPoint;

/*!
    \brief 分割指定的片段
    \param clipIndex 片段索引
    \param splitPoint 分割点（单位微秒）
    \return 判断是否分割成功，YES为分割成功； NO则不成功

    分割片段，即对指定索引值的片段进行分割而变为两个片段的操作，对应的轨道上片段的索引值也会进行相应变化。

    示例如下:

    ![] (@ref TrackClip.PNG)
    上图中轨道上有三个视频片段C1、C2、C3，对片段C2进行分割，分割后的片段分别命名为C2和C4。通过获取轨道上当前片段数来判定是否分割成功，分割成功则C2和C4索引值对应为1和2。

    结果如下图：
    ![] (@ref afterSplitClip.PNG)
    \warning 此接口会引发流媒体引擎状态跳转到引擎停止状态，具体情况请参见[引擎变化专题] (\ref EngineChange.md)。
    \sa removeClip
 */
- (BOOL)splitClip:(unsigned int)clipIndex splitPoint:(int64_t)splitPoint;

/*!
	\brief 移除指定的片段
	\param clipIndex 片段索引
    \param keepSpace 片段移除后，是否保留该片段在轨道上的空间。值为true则保留，false则不保留。
    \return 判断是否移除成功。返回YES则移除成功，NO则失败。
    \warning 此接口会引发流媒体引擎状态跳转到引擎停止状态，具体情况请参见[引擎变化专题] (\ref EngineChange.md)。
    \sa  removeAllClips
 */
- (BOOL)removeClip:(unsigned int)clipIndex keepSpace:(BOOL)keepSpace;

/*!
    \brief 移除指定的区间内的所有片段，如果片段只有部分与该区间重合则调整其时间线入点或者出点
    \param startTimelinePos 区间的起始时间线位置（单位微秒）
    \param endTimelinePos 区间的结束时间线位置（单位微秒）
    \param keepSpace 区间内的片段移除后，是否保留该区间所占轨道上的空间。值为true则保留，false则不保留
    \return 是否移除成功。返回true则移除成功，false则移除不成功
    \warning 此接口会引发流媒体引擎状态跳转到引擎停止状态，具体情况请参见[引擎变化专题] (\ref EngineChange.md)。
 */
- (BOOL)removeRange:(int64_t)startTimelinePos endTimelinePos:(int64_t)endTimelinePos keepSpace:(BOOL)keepSpace;

/*!
	\brief 移动指定的片段
	\param clipIndex 片段索引
	\param destClipIndex 片段移动的目标索引
    \return 判断是否移动成功。返回YES为移动成功，NO则失败。
    \warning 此接口会引发流媒体引擎状态跳转到引擎停止状态，具体情况请参见[引擎变化专题] (\ref EngineChange.md)。
 */
- (BOOL)moveClip:(unsigned int)clipIndex destClipIndex:(unsigned int)destClipIndex;

/*! 	
	\brief 移除所有片段
    \return 判断是否移除成功。返回YES为移除成功，NO则失败。
    \warning 此接口会引发流媒体引擎状态跳转到引擎停止状态，具体情况请参见[引擎变化专题] (\ref EngineChange.md)。
    \sa removeClip:keepSpace:
 */
- (BOOL)removeAllClips;

/*! 	
	\brief 设置音量
    \param leftVolumeGain 设置音量的左声道
    \param rightVolumeGain 设置音量的右声道
    \sa getVolumeGain:rightVolumeGain:
 
 */
- (void)setVolumeGain:(float)leftVolumeGain rightVolumeGain:(float)rightVolumeGain;

/*! 
	\brief 获取音量
    \param leftVolumeGain 返回值，获取音量的左声道
    \param rightVolumeGain 返回值，获取音量的右声道
    \sa setVolumeGain:rightVolumeGain:
 */
- (void)getVolumeGain:(float *)leftVolumeGain rightVolumeGain:(float *)rightVolumeGain;

@end
