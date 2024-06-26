//
//  PhotoHomeView.swift
//  ImageSliderSwiftUI
//
//  Created by shiyanjun on 2024/6/26.
//

import SwiftUI
import Photos

struct PhotoHomeView: View {
    @State private var photos: [Photo] = []
    @State private var images: [String] = []
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            if !photos.isEmpty {
                PhotoSliderView(photos: $photos, currentIndex: $currentIndex, animationEffect: .scaleFromCenter)
            } else {
                Text("没有图片了")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            requestPhotoLibraryAccess()
        }
        .overlay(alignment: .top) {
            VStack {
                if !photos.isEmpty {
                    Text("当前索引:\(currentIndex)")
                    Text("图片数量:\(photos.count)")
                }
            }
            .padding()
            .background(.black.opacity(0.5))
            .cornerRadius(10)
        }
        .overlay(alignment: .bottom) {
            Button("重置") {
                loadPhotos()
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple.opacity(0.5))
        }
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            if status == .authorized || status == .limited {
                self.loadPhotos()
            }
        }
    }
    
    func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        var assets: [Photo] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(Photo(asset: asset))
        }
        
        DispatchQueue.main.async {
            self.photos = assets
        }
    }
}

#Preview {
    PhotoHomeView()
}
