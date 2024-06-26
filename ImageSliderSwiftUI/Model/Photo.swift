//
//  Photo.swift
//  ImageSliderSwiftUI
//
//  Created by shiyanjun on 2024/6/26.
//

import SwiftUI
import Photos

struct Photo: Identifiable {
    var id: String
    var photoId: String
    var asset: PHAsset
    
    init(asset: PHAsset) {
        self.id = UUID().uuidString
        self.asset = asset
        self.photoId = asset.localIdentifier
    }
}
