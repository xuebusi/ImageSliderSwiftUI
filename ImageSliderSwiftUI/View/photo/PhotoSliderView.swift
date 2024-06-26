//
//  PhotoSliderView.swift
//  ImageSliderSwiftUI
//
//  Created by shiyanjun on 2024/6/26.
//

import SwiftUI
import Photos

/// - 实现上下滑动移除图片并通过动画展示下一张图片
struct PhotoSliderView: View {
    /// - 相册中的所有图片
    @Binding var photos: [Photo]
    /// - 当前图片
    @State private var image: UIImage?
    /// - 当前图片索引
    @Binding var currentIndex: Int
    @State private var animationEffect: AnimationEffect = .scaleFromCenter
    @State private var offset: CGSize = .zero
    
    init(photos: Binding<[Photo]>,
         currentIndex: Binding<Int>,
         animationEffect: AnimationEffect = .scaleFromCenter) {
        self._photos = photos
        self._currentIndex = currentIndex
        self._animationEffect = State(initialValue: animationEffect)
    }
    
    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size
                ZStack {
                    ForEach(photos.indices, id: \.self) { index in
                        if index == currentIndex {
                            if let uiImage = image {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.black.opacity(0.0000001))
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
                                                        let photoId = photos[currentIndex]
                                                        photos.remove(at: currentIndex)
                                                        print("移除图片:\(photoId)")
                                                        if photos.isEmpty {
                                                            currentIndex = 0
                                                            offset = .zero
                                                            return
                                                        }
                                                        
                                                        withAnimation {
                                                            // 重置属性以准备应用新动画效果
                                                            offset = .zero
                                                            image = nil
                                                            currentIndex = (currentIndex) % photos.count
                                                        }
                                                        
                                                        applyAnimationEffect()
                                                    }
                                                } else {
                                                    offset = .zero
                                                }
                                            }
                                    )
                            } else {
                                Color.clear
                                    .onAppear {
                                        getImage2(from: photos[currentIndex].asset) { uiImage in
                                            self.image = uiImage
                                            // 这里应用动画效果
                                            applyAnimationEffect()
                                        }
                                    }
                            }
                        }
                    }
                }
                .frame(width: size.width, height: size.height)
            }
        }
    }
    
    /// - 新图片入场动画
    private func applyAnimationEffect() {
        switch animationEffect {
        case .slideInFromRight:
            offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
        case .slideInFromLeft:
            offset = CGSize(width: -UIScreen.main.bounds.width, height: 0)
        case .slideInFromTop:
            offset = CGSize(width: 0, height: -UIScreen.main.bounds.height)
        case .slideInFromBottom:
            offset = CGSize(width: 0, height: UIScreen.main.bounds.height)
        case .scaleFromCenter:
            offset = .zero
        }
        
        withAnimation(.easeInOut(duration: 0.5)) {
            offset = .zero
        }
    }
}

/// - 从Photos获取UIImage
func getImage2(from asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.deliveryMode = .highQualityFormat
    options.resizeMode = .none
    manager.requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
        if let data = data {
            completion(UIImage(data: data))
        } else {
            completion(nil)
        }
    }
}

#Preview {
    PhotoSliderView(photos: .constant([]), currentIndex: .constant(0))
        .preferredColorScheme(.dark)
}
