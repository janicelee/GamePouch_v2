//
//  GalleryImages.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-24.
//

import Foundation

struct GalleryImages: Codable {
    let images: [GalleryImage]
}

struct GalleryImage: Codable {
    let imageurl_lg: String
}
