//
//  NewImageCollectionViewCellModel.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import UIKit

class NewImageCollectionViewCellModel {
    let photo: Photo
    let artistName: String
    let thumbnailUrlString: String
    
    init(photo: Photo) {
        self.photo = photo
        
        self.artistName = photo.user.username
        self.thumbnailUrlString = photo.urls.regular
    }
}
