//
//  ImageSliderView.swift
//  ImageSliderSwiftUI
//
//  Created by shiyanjun on 2024/6/26.
//

import SwiftUI

/// - 实现上下滑动移除图片并通过动画展示下一张图片
struct ImageSliderView: View {
    @Binding var images: [String]
    @Binding var currentIndex: Int
    @State private var animationEffect: AnimationEffect = .scaleFromCenter
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    
    init(images: Binding<[String]>, 
         currentIndex: Binding<Int>,
         animationEffect: AnimationEffect = .scaleFromCenter) {
        self._images = images
        self._currentIndex = currentIndex
        self._animationEffect = State(initialValue: animationEffect)
    }
    
    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size
                ZStack {
                    ForEach(images.indices, id: \.self) { index in
                        if index == currentIndex {
                            Image(images[index])
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.black.opacity(0.0000001))
                                .scaleEffect(scale)
                                .opacity(opacity)
                                .offset(offset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            let dragHeight = gesture.translation.height
                                            offset = CGSize(width: 0, height: dragHeight)
                                        }
                                        .onEnded { gesture in
                                            let screenHeight = UIScreen.main.bounds.height
                                            let dragHeight = gesture.translation.height
                                            
                                            if abs(dragHeight) > screenHeight / 3 {
                                                let newOffset = dragHeight > 0 ? screenHeight : -screenHeight
                                                withAnimation {
                                                    offset = CGSize(width: 0, height: newOffset)
                                                }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    images.remove(at: currentIndex)
                                                    print("移除图片:\(currentIndex)")
                                                    if images.isEmpty {
                                                        currentIndex = 0
                                                        offset = .zero
                                                        scale = 1
                                                        opacity = 1
                                                        return
                                                    }
                                                    
                                                    currentIndex = currentIndex % images.count
                                                    applyAnimationEffect()
                                                }
                                            } else {
                                                withAnimation {
                                                    offset = .zero
                                                }
                                            }
                                        }
                                )
                        }
                    }
                }
                .frame(width: size.width, height: size.height)
            }
        }
    }
    
    private func applyAnimationEffect() {
        switch animationEffect {
        case .slideInFromRight:
            offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
            scale = 0
            opacity = 0
        case .slideInFromLeft:
            offset = CGSize(width: -UIScreen.main.bounds.width, height: 0)
            scale = 0
            opacity = 0
        case .slideInFromTop:
            offset = CGSize(width: 0, height: -UIScreen.main.bounds.height)
            scale = 0
            opacity = 0
        case .slideInFromBottom:
            offset = CGSize(width: 0, height: UIScreen.main.bounds.height)
            scale = 0
            opacity = 0
        case .scaleFromCenter:
            offset = .zero
            scale = 0
            opacity = 0
        case .fadeIn:
            opacity = 0
        case .rotate:
            scale = 0.5
            opacity = 0
        case .elasticSlideIn:
            offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
        case .flip:
            opacity = 0
        case .diagonalSlideIn:
            offset = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        case .combinedEffect:
            offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
            scale = 0.5
            opacity = 0
        }
        
        withAnimation(.easeInOut(duration: 0.5)) {
            offset = .zero
            scale = 1
            opacity = 1
        }
    }
    
    private func loadImages() {
        images = (1...10).map { "Pic \($0)" }
    }
}

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
    
    /// 淡入淡出效果
    case fadeIn
    
    /// 旋转效果
    case rotate
    
    /// 带有弹性效果的滑入
    case elasticSlideIn
    
    /// 翻转效果
    case flip
    
    /// 从斜角滑入
    case diagonalSlideIn
    
    /// 组合效果，例如从右侧滑入并伴随旋转
    case combinedEffect
}

#Preview {
    ImageSliderView(images: .constant(["Pic 1"]), currentIndex: .constant(0))
        .preferredColorScheme(.dark)
}
