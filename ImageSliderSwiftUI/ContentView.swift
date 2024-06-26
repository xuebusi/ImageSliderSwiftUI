//
//  ContentView.swift
//  ImageSliderSwiftUI
//
//  Created by shiyanjun on 2024/6/26.
//

import SwiftUI

struct ContentView: View {
    @State private var images: [String] = []
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            if !images.isEmpty {
                ImageSliderView(images: $images, currentIndex: $currentIndex, animationEffect: .scaleFromCenter)
            } else {
                Text("没有图片了")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            loadImages()
        }
        .overlay(alignment: .top) {
            VStack {
                if !images.isEmpty {
                    Text("当前索引:\(currentIndex)")
                    Text("图片数量:\(images.count)")
                }
            }
            .padding()
            .background(.black.opacity(0.5))
            .cornerRadius(10)
        }
        .overlay(alignment: .bottom) {
            Button("重置") {
                loadImages()
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple.opacity(0.5))
        }
    }
    
    /// - 初始化图片数组
    private func loadImages() {
        images = (1...2).map { "Pic \($0)" }
    }
}

#Preview {
    ContentView()
}
