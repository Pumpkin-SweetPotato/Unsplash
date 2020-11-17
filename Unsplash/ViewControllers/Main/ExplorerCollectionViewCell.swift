//
//  ExplorerCollectionViewCell.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import UIKit

class ExplorerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: ExplorerCollectionViewCell.self)
    
    let label: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
