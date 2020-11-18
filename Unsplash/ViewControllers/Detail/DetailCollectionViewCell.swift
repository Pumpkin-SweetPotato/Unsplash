//
//  DetailCollectionViewCell.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/18.
//

import UIKit

class DetailCollectionViewCell:  UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: DetailCollectionViewCell.self)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        return scrollView
    }()

    private let scrollContentView = UIView()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var detailCollectionViewCellModel: DetailCollectionViewCellModel! {
        didSet {
            guard let detailCollectionViewCellModel = detailCollectionViewCellModel else { return }
            let imageUrl = detailCollectionViewCellModel.thumbnailUrlString

            ImageDownloadManager.shared.downloadImage(imageUrl, indexPath: nil) { [weak self] (image, url, indexPath, error) in
                self?.imageView.image = image
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setConstraints()
        setZoomable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)

        scrollContentView.addSubview(imageView)
    }

    private func setConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.active([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.active([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.active([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func setZoomable() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
    }
}