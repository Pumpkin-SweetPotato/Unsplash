//
//  NewImageCollectionViewCell.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import UIKit

class NewImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: NewImageCollectionViewCell.self)
    
    let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        return artistNameLabel
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var newImageCollectionViewCellModel: NewImageCollectionViewCellModel! {
        didSet {
            guard newImageCollectionViewCellModel != nil else { return }
            artistNameLabel.text = newImageCollectionViewCellModel.artistName
            
            ImageDownloadManager.shared.downloadImage(newImageCollectionViewCellModel.thumbnailUrlString, indexPath: nil) { [weak self] (image, url, indexPath, error) in
                self?.imageView.image = image
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(artistNameLabel)
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        artistNameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15).isActive = true
    }
    
    
}

