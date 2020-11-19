//
//  DetailCollectionViewCellModel.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import Foundation

class DetailCollectionViewCellModel {
    let photo: Photo
    let thumbnailUrlString: String
    
    init(photo: Photo) {
        self.photo = photo
        
        self.thumbnailUrlString = photo.urls.regular
    }
}
