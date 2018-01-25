//
//  ChatRoomController.h
//  XinMart
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@class VideoUserModel;
@interface ChatRoomController : RCConversationViewController
@property (nonatomic, strong) VideoUserModel *videoUser;
@end
