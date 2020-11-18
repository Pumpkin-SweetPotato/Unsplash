//
//  DetailViewController.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/18.
//

import UIKit

final class DetailViewController: UIViewController {
    let closeButton: UIButton = {
        let closeButton = UIButton()

        return closeButton
    }()

    let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()

        return artistNameLabel
    }()

    let shareButton: UIButton = {
        let shareButton = UIButton()
        return shareButton
    }()

    let infoButton: UIButton = {
        let infoButton = UIButton()
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
        let likeButton = UIButton()
        return likeButton
    }()

    let plusButton: UIButton = {
        let plusButton = UIButton()
        return plusButton
    }()

    let downloadButton: UIButton = {
        let downloadButton = UIButton()
        return downloadButton
    }()

    let imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        imageCollectionView.register(DetailCollecionViewCell.self, forCellWithReuseIdentifier: DetailCollecionViewCell.reuseIdentifier)
        
        return imageCollectionView
    }()
    
    var detailViewModel: DetailViewModel!

    init(detailViewModel: DetailViewModel) {
        super.init()

        defer {
            self.detailViewModel = detailViewModel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defer {
            detailViewModel.viewDidLoad()
        }
        
        addViews()
        setConstraints()
        setDelegates()
        setZoomable()
    }

    private func setDelegates() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
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

        NSLayoutConstraint.active([
            imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.active([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.active([
            artistNameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            artistNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        shareButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.active([
            shareButton.topAnchor.constraint(equalTo: view.topAnchor),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        infoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.active([
            infoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        verticalButtonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.active([
            verticalButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalButtonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}



extension SearchViewController: UICollectionViewDelegate {
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailViewModel.currentState.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollecionViewCell.reuseIdentifier, for: indexPath)
                    as? DetailCollecionViewCell else { fatalError() }
            
        let photo = detailViewModel.currentState.newImagePhotos[indexPath.row]
        
        cell.detailCollectionViewCellModel = DetailCollecionViewCellModel(photo: photo)
        
        return cell
    }
}

extension SearchViewController: SearchViewOutput {
    func needReloadNewImageCollectionView() {
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }

    func needReloadExplorerCollectionView() {
        DispatchQueue.main.async {
            self.explorerCollectionView.reloadData()
        }
    }

    func didImageItemAdded(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.imageCollectionView.insertItems(at: indexPaths)
        }
    }
}


extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentY = scrollView.contentOffset.y
        // let height = initialImageHeight - contentY
        // imageViewHeightConstraint.constant = height
    }
}