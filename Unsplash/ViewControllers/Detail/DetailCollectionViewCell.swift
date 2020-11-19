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

    private let imageContainerView = UIView()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        return stackView
    }()
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
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
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
//        scrollContentView.addSubview(stackView)
//        stackView.addArrangedSubview(imageView)
    }

    private func setConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightAnchor = scrollContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            heightAnchor,
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor)
//        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            imageView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
//            imageView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollContentView.bottomAnchor)
        ])
    }

    private func setZoomable() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
    }
}

extension DetailCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.clipsToBounds = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale < 1.2 {
            scrollView.clipsToBounds = true
            scrollView.contentSize = scrollContentView.frame.size
            scrollView.setZoomScale(1.0, animated: true)
            
        }
    }
}
