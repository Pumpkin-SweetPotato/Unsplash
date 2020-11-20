//
//  DetailViewController.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/18.
//

import UIKit

final class DetailViewController: UIViewController {
    let closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.tintColor = .white
        if #available(iOS 13.0, *) {
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }

        return closeButton
    }()

    let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 14)
        artistNameLabel.textColor = .white
        
        return artistNameLabel
    }()

    let shareButton: UIButton = {
        let shareButton = UIButton(type: .system)
        shareButton.tintColor = .white
        if #available(iOS 13.0, *) {
            shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        return shareButton
    }()

    let infoButton: UIButton = {
        let infoButton = UIButton(type: .system)
        
        if #available(iOS 13.0, *) {
            infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
            infoButton.tintColor = .white
        } else {
            infoButton.setTitle("Info", for: .normal)
            // Fallback on earlier versions
        }
        
        
        return infoButton
    }()

    let verticalButtonStackView: UIStackView = {
        let verticalButtonStackView = UIStackView()
        verticalButtonStackView.distribution = .fill
        verticalButtonStackView.axis = .vertical
        verticalButtonStackView.alignment = .center
        verticalButtonStackView.spacing = 15

        return verticalButtonStackView
    }()

    let likeButton: UIButton = {
        let likeButton = UIButton(type: .system)
        
        if #available(iOS 13.0, *) {
            likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            likeButton.tintColor = .white
        } else {
            likeButton.setTitle("Like", for: .normal)
        }
        
        return likeButton
    }()

    let plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        
        if #available(iOS 13.0, *) {
            plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
            plusButton.tintColor = .white
        } else {
            plusButton.setTitle("Add", for: .normal)
        }
        
        return plusButton
    }()

    let downloadButton: UIButton = {
        let downloadButton = UIButton(type: .system)
        downloadButton.backgroundColor = .white
        if #available(iOS 13.0, *) {
            downloadButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
            downloadButton.tintColor = .black
        } else {
            downloadButton.setTitle("Down", for: .normal)
        }
        
        return downloadButton
    }()

    let imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        imageCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseIdentifier)
        imageCollectionView.showsHorizontalScrollIndicator = false
        
        return imageCollectionView
    }()
    
    var detailViewModel: DetailViewModel!
    weak var dismissDelegate: ViewControllerDismissDelegate?
    var initialIndexLayouted: Bool = false

    init(detailViewModel: DetailViewModel) {
        super.init(nibName: nil, bundle: nil)

        defer {
            self.detailViewModel = detailViewModel
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defer {
            detailViewModel.detailViewOutput = self
        }
        
        addViews()
        setConstraints()
        setDelegates()
        setCloseButtonAction()
    }

    private func setDelegates() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !initialIndexLayouted {
            initialIndexLayouted = true
            imageCollectionView.setNeedsLayout()
            imageCollectionView.layoutIfNeeded()
            imageCollectionView.scrollToItem(at: detailViewModel.currentState.currentIndex, at: .centeredHorizontally, animated: false)
        }
    }

    private func addViews() {
        view.addSubview(imageCollectionView)
        view.addSubview(closeButton)
        view.addSubview(artistNameLabel)
        view.addSubview(shareButton)
        view.addSubview(infoButton)
        view.addSubview(verticalButtonStackView)

        verticalButtonStackView.addArrangedSubview(likeButton)
        verticalButtonStackView.addArrangedSubview(plusButton)
        verticalButtonStackView.addArrangedSubview(downloadButton)
    }
    
    private func setConstraints() {
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.leading),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25)
        ])

        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            artistNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            artistNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            artistNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
        ])

        shareButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.trailing)
        ])

        infoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            infoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.leading),
            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])

        verticalButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.trailing),
            verticalButtonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }
    
    func setCloseButtonAction() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func closeButtonTapped() {
        dismissDelegate?.dismissCalledFromChild(lastIndexPath: detailViewModel.currentState.currentIndex)
    }
}



extension DetailViewController: UICollectionViewDelegate {
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let imageCount = detailViewModel.currentState.photos.count
        
        targetContentOffset.pointee = scrollView.contentOffset
        
        let targetIndex: CGFloat = scrollView.contentOffset.x / imageCollectionView.bounds.width
        
        var factor: CGFloat = 0.5
        
        if velocity.x < 0 {
            factor = -factor
        }
        
        var index = Int(round(targetIndex + factor))
        
        if index < 0 {
            index = 0
        } else {
            index = min(imageCount - 1, index)
        }
        let targetIndexPath = IndexPath(row: index, section: 0)
        imageCollectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: true)
        detailViewModel.currentIndexChanged(indexPath: targetIndexPath)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailViewModel.currentState.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
             collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? DetailCollectionViewCell else { fatalError() }
            
        let photo = detailViewModel.currentState.photos[indexPath.row]
        
        cell.detailCollectionViewCellModel = DetailCollectionViewCellModel(photo: photo)
        
        return cell
    }
}

extension DetailViewController: DetailViewOutput {
    func setArtistName(_ artistName: String) {
        self.artistNameLabel.text = artistName
    }
}
