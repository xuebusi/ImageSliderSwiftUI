//
//  AnimationEffect.swift
//  ImageSliderSwiftUI
//
//  Created by shiyanjun on 2024/6/26.
//

import SwiftUI

/// 表示图片出现的动画效果的枚举
enum AnimationEffect {
    /// 从屏幕右侧滑入
    case slideInFromRight
    
    /// 从屏幕左侧滑入
    case slideInFromLeft
    
    /// 从屏幕上方滑入
    case slideInFromTop
    
    /// 从屏幕底部滑入
    case slideInFromBottom
    
    /// 从屏幕中心缩放显示
    case scaleFromCenter
}
