//
//  NewImageCollectionViewCell.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import UIKit

class NewImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: NewImageCollectionViewCell.self)

    private let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        artistNameLabel.textColor = .white
        
        return artistNameLabel
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var newImageCollectionViewCellModel: NewImageCollectionViewCellModel! {
        didSet {
            guard newImageCollectionViewCellModel != nil else { return }
            artistNameLabel.text = newImageCollectionViewCellModel.artistName

            let imageUrl = newImageCollectionViewCellModel.thumbnailUrlString
            
            ImageDownloadManager.shared.downloadImage(imageUrl, indexPath: nil) { [weak self] (image, url, indexPath, error) in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
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

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            artistNameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            artistNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15)
        ])
    }
    
}

