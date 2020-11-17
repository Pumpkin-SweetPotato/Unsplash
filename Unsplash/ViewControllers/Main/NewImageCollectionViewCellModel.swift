//
//  NewImageCollectionViewCellModel.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import Foundation

class NewImageCollectionViewCellModel {
    let photo: Photo
    let artistName: String
    let thumbnailUrlString: String
    
    init(photo: Photo) {
        self.photo = photo
        
        self.artistName = photo.user.username
        self.thumbnailUrlString = photo.urls.thumb
    }
}
