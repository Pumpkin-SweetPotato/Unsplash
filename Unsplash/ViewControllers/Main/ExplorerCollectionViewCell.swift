//
//  ExplorerCollectionViewCell.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import UIKit

final class ExplorerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: ExplorerCollectionViewCell.self)
    
    private let label: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let imageView: UIImageView = {
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
