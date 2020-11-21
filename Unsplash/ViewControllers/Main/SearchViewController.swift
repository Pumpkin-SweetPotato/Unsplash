//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import UIKit

protocol PhotoSearch: class {
    associatedtype ViewMode
    func setViewMode(_ viewMode: ViewMode)
    func stickeyHeaderBehavior(_ scrollView: UIScrollView, _ parentViewMaxContentYOffset: CGFloat)
}

class SearchViewController: UIViewController, PhotoSearch {

    private let rootView: UIView = UIView()
    
    private let superScrollView: UIScrollView = {
        let superScrollView = UIScrollView()
        superScrollView.showsVerticalScrollIndicator = false
        return superScrollView
    }()
    
    private let scrollContentView: UIView = UIView()
    
    private let topContainer: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let topContainer = UIVisualEffectView(effect: effect)
        
        return topContainer
    }()
    
    private let topImageView: UIImageView = {
        let topImageView = UIImageView()
        topImageView.contentMode = .scaleAspectFill
        
        return topImageView
    }()
    
    private let appInfoButton: UIButton = {
        let appInfoButton = UIButton(type: .system)
        let iconImage = UIImage(named: "unsplashIcon")?.withRenderingMode(.alwaysTemplate)
        appInfoButton.setImage(iconImage, for: .normal)
        appInfoButton.tintColor = .white
        
        return appInfoButton
    }()
    
    private let userInfoButton: UIButton = {
        let userInfoButton = UIButton(type: .system)
        let iconImage = UIImage(named: "userIcon")?.withRenderingMode(.alwaysTemplate)
        userInfoButton.setImage(iconImage, for: .normal)
        userInfoButton.tintColor = .white
        
        return userInfoButton
    }()
    
    private let keytakeawayLabel: UILabel = {
        let keytakeawayLabel = UILabel()
        keytakeawayLabel.text = "Photos for everyone"
        keytakeawayLabel.textColor = .white
        keytakeawayLabel.font = .systemFont(ofSize: 26, weight: .bold)
        keytakeawayLabel.textAlignment = .center
        
        return keytakeawayLabel
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search photos"
        searchBar.isTranslucent = false

        return searchBar
    }()
    
    private let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 13, weight: .light)
        artistNameLabel.textColor = .white
        artistNameLabel.text = "Photo by Aaron Burden"
        artistNameLabel.textAlignment = .center
        
        return artistNameLabel
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let bottomExplorerImageContainer = UIView()
    
    private let explorerContainer: UIView = {
        let explorerContainer = UIView()
        explorerContainer.backgroundColor = .white
        
        return explorerContainer
    }()
    
    private let explorerLabel: UILabel = {
        let explorerLabel = UILabel()
        explorerLabel.text = "Explore"
        explorerLabel.textColor = .black
        explorerLabel.font = .systemFont(ofSize: 15)
        
        return explorerLabel
    }()
    
    let explorerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let explorerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        explorerCollectionView.register(ExplorerCollectionViewCell.self, forCellWithReuseIdentifier: ExplorerCollectionViewCell.reuseIdentifier)
        explorerCollectionView.backgroundColor = .white
        
        return explorerCollectionView
    }()
    
    private let newImagesContainer: UIView = {
        let newImagesContainer = UIView()
        newImagesContainer.backgroundColor = .white
        
        return newImagesContainer
    }()
    
    private let newImageLabel: UILabel = {
        let newImageLabel = UILabel()
        newImageLabel.text = "New"
        newImageLabel.font = .systemFont(ofSize: 15)
        
        return newImageLabel
    }()
    
    let newImagesCollectionView: UICollectionView = {
        let flowLayout = FlexibleHeightCollectionViewLayout()
        let newImagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        newImagesCollectionView.register(NewImageCollectionViewCell.self, forCellWithReuseIdentifier: NewImageCollectionViewCell.reuseIdentifier)
        newImagesCollectionView.backgroundColor = .white
        
        return newImagesCollectionView
    }()
    
    let searchContainer: UIView = {
        let container = UIView()
        container.isHidden = true
        return container
    }()
    
    
    let searchResultCollectionView: UICollectionView = {
        let flowLayout = FlexibleHeightCollectionViewLayout()
        let searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        searchResultCollectionView.register(NewImageCollectionViewCell.self, forCellWithReuseIdentifier: NewImageCollectionViewCell.reuseIdentifier)
        searchResultCollectionView.backgroundColor = .white
        
        return searchResultCollectionView
    }()
    
    var searchViewModel: SearchViewModel!
    var scrollGoingUp: Bool?
    var childScrollingDownDueToParent: Bool = false
    var topContainerHeightConstraint: NSLayoutConstraint!
    let stickeyViewHeight: CGFloat = 50
    var beforeContentOffset: CGPoint!
    
    enum ViewMode {
        case normal
        case search
    }
    
    var viewMode: ViewMode = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defer {
            searchViewModel = SearchViewModel()
            searchViewModel.searchViewOutput = self
            searchViewModel.viewDidLoad()
        }
        
        navigationController?.isNavigationBarHidden = true
        
        addViews()
        setConstraints()
        setDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
           let placeholderLabel = textField.value(forKey: "placeholderLabel") as? UILabel {
            let glassIconView = textField.leftView as? UIImageView
            glassIconView?.tintColor = .white
            
            placeholderLabel.textColor = .white
        }
    }
    
    private func addViews() {
        view.addSubview(rootView)
        rootView.addSubview(superScrollView)
        superScrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(topContainer)

        topContainer.contentView.addSubview(topImageView)
        topContainer.contentView.addSubview(appInfoButton)
        topContainer.contentView.addSubview(userInfoButton)
        topContainer.contentView.addSubview(keytakeawayLabel)
        topContainer.contentView.addSubview(artistNameLabel)
        topContainer.contentView.addSubview(searchBar)
    
        scrollContentView.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(bottomExplorerImageContainer)
        
        bottomExplorerImageContainer.addSubview(explorerContainer)
        explorerContainer.addSubview(explorerLabel)
        explorerContainer.addSubview(explorerCollectionView)
        
        bottomExplorerImageContainer.addSubview(newImagesContainer)
        newImagesContainer.addSubview(newImageLabel)
        newImagesContainer.addSubview(newImagesCollectionView)
        
        scrollContentView.addSubview(searchContainer)
        searchContainer.addSubview(searchResultCollectionView)
        
        scrollContentView.bringSubviewToFront(topContainer)
    }
    
    private func setConstraints() {
        rootView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.heightAnchor.constraint(equalTo: view.heightAnchor),
            rootView.widthAnchor.constraint(equalTo: view.widthAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        superScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        superScrollView.contentInsetAdjustmentBehavior = .never
        
        NSLayoutConstraint.activate([
            superScrollView.topAnchor.constraint(equalTo: rootView.topAnchor),
            superScrollView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            superScrollView.heightAnchor.constraint(equalTo: rootView.heightAnchor),
            superScrollView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            superScrollView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        ])
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: superScrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: superScrollView.leadingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: superScrollView.widthAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: superScrollView.trailingAnchor),
            scrollContentView.heightAnchor.constraint(greaterThanOrEqualTo: superScrollView.heightAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: superScrollView.bottomAnchor)
        ])
        
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainerHeightConstraint = topContainer.heightAnchor.constraint(equalToConstant: view.frame.height * 0.43)
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            topContainerHeightConstraint,
            topContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            topContainer.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor)
        ])

        topImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: topContainer.topAnchor),
            topImageView.heightAnchor.constraint(equalTo: topContainer.heightAnchor),
            topImageView.widthAnchor.constraint(equalTo: topContainer.widthAnchor),
            topImageView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
        ])
        
        appInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appInfoButton.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: ViewConstants.leading),
            appInfoButton.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 30),
            appInfoButton.widthAnchor.constraint(equalToConstant: 20),
            appInfoButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        userInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userInfoButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -ViewConstants.trailing),
            userInfoButton.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 30),
            userInfoButton.widthAnchor.constraint(equalToConstant: 20),
            userInfoButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        keytakeawayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keytakeawayLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            keytakeawayLabel.widthAnchor.constraint(equalTo: topContainer.widthAnchor),
            keytakeawayLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            keytakeawayLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -10)
        ])
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.bottomAnchor.constraint(greaterThanOrEqualTo: topContainer.bottomAnchor, constant: -70),
            searchBar.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            searchBar.widthAnchor.constraint(equalTo: topContainer.widthAnchor, constant:  -(ViewConstants.leading + ViewConstants.trailing)),
        ])
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            artistNameLabel.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -15),
            artistNameLabel.widthAnchor.constraint(equalTo: topContainer.widthAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
        ])
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor)
        ])
        
        bottomExplorerImageContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bottomExplorerImageContainer.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor),
            bottomExplorerImageContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        explorerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            explorerContainer.topAnchor.constraint(equalTo: bottomExplorerImageContainer.topAnchor),
            explorerContainer.leadingAnchor.constraint(equalTo: bottomExplorerImageContainer.leadingAnchor),
            explorerContainer.trailingAnchor.constraint(equalTo: bottomExplorerImageContainer.trailingAnchor),
            explorerContainer.widthAnchor.constraint(equalTo: bottomExplorerImageContainer.widthAnchor),
            explorerContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        explorerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            explorerLabel.topAnchor.constraint(equalTo: explorerContainer.topAnchor, constant: 15),
            explorerLabel.leadingAnchor.constraint(equalTo: explorerContainer.leadingAnchor, constant: ViewConstants.leading),
            explorerLabel.widthAnchor.constraint(lessThanOrEqualTo: explorerContainer.widthAnchor),
            explorerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])

        explorerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            explorerCollectionView.topAnchor.constraint(equalTo: explorerLabel.bottomAnchor),
            explorerCollectionView.heightAnchor.constraint(equalToConstant: 180),
            explorerCollectionView.widthAnchor.constraint(equalTo: explorerContainer.widthAnchor),
            explorerCollectionView.leadingAnchor.constraint(equalTo: explorerContainer.leadingAnchor),
            explorerCollectionView.trailingAnchor.constraint(equalTo: explorerContainer.trailingAnchor),
            explorerCollectionView.bottomAnchor.constraint(equalTo: explorerContainer.bottomAnchor),
        ])

        newImagesContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newImagesContainer.topAnchor.constraint(equalTo: explorerContainer.bottomAnchor),
            newImagesContainer.leadingAnchor.constraint(equalTo: bottomExplorerImageContainer.leadingAnchor),
            newImagesContainer.trailingAnchor.constraint(equalTo: bottomExplorerImageContainer.trailingAnchor),
            newImagesContainer.widthAnchor.constraint(equalTo: bottomExplorerImageContainer.widthAnchor),
            newImagesContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            newImagesContainer.bottomAnchor.constraint(equalTo: bottomExplorerImageContainer.bottomAnchor),
        ])

        newImageLabel.translatesAutoresizingMaskIntoConstraints = false
//
        NSLayoutConstraint.activate([
            newImageLabel.topAnchor.constraint(equalTo: newImagesContainer.topAnchor, constant: 15),
            newImageLabel.leadingAnchor.constraint(equalTo: newImagesContainer.leadingAnchor, constant: ViewConstants.leading),
            newImageLabel.widthAnchor.constraint(lessThanOrEqualTo: newImagesContainer.widthAnchor),
            newImageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])

        newImagesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newImagesCollectionView.topAnchor.constraint(equalTo: newImageLabel.bottomAnchor),
            newImagesCollectionView.leadingAnchor.constraint(equalTo: newImagesContainer.leadingAnchor),
            newImagesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -stickeyViewHeight),
            newImagesCollectionView.trailingAnchor.constraint(equalTo: newImagesContainer.trailingAnchor),
            newImagesCollectionView.bottomAnchor.constraint(equalTo: newImagesContainer.bottomAnchor),
        ])
        
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            searchContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            searchContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            searchContainer.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor),
            searchContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            searchContainer.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor)
        ])
        
        searchResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchResultCollectionView.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            searchResultCollectionView.widthAnchor.constraint(equalTo: searchContainer.widthAnchor),
            searchResultCollectionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            searchResultCollectionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            searchResultCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }

    private func setDelegates() {
        superScrollView.delegate = self
        searchBar.delegate = self
        explorerCollectionView.delegate = self
        explorerCollectionView.dataSource = self
        newImagesCollectionView.delegate = self
        newImagesCollectionView.dataSource = self
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        
        if let layout = newImagesCollectionView.collectionViewLayout as?  FlexibleHeightCollectionViewLayout {
            layout.delegate = self
        }
        
        if let layout = searchResultCollectionView.collectionViewLayout as?  FlexibleHeightCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    func setViewMode(_ viewMode: ViewMode) {
        self.viewMode = viewMode
        DispatchQueue.main.async {
            switch viewMode {
            case .normal:
                self.superScrollView.isScrollEnabled = true
                self.searchViewModel.searchCancel()
                self.searchBar.resignFirstResponder()
                self.searchBar.setShowsCancelButton(false, animated: true)
                
                UIView.animate(withDuration: 0.25) {
                    self.superScrollView.contentOffset = self.beforeContentOffset
                }
                
                self.bottomStackView.isHidden = false
                self.searchContainer.isHidden = true
            case .search:
                
                self.superScrollView.isScrollEnabled = false
                self.searchBar.setShowsCancelButton(true, animated: true)
                
                self.setCancelButtonColor(.black)
                
                self.beforeContentOffset = self.superScrollView.contentOffset
            
                UIView.animate(withDuration: 0.25) {
                    self.superScrollView.contentOffset.y = self.superScrollView.contentSize.height - self.superScrollView.frame.height
                    
                    self.searchResultCollectionView.transform =
                        CGAffineTransform(translationX: 0, y: self.superScrollView.contentSize.height - self.superScrollView.frame.height)
                }
                
                
                self.bottomStackView.isHidden = true
                self.searchContainer.isHidden = false
            }
        }
    }
    
    func setCancelButtonColor(_ color: UIColor) {
        if let cancelButton = self.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.tintColor = color
        }
    }

}

extension SearchViewController: SearchViewOutput {
    func needReloadExplorerCollectionView() {
        DispatchQueue.main.async {
            self.explorerCollectionView.reloadData()
        }
    }
    
        
    func needReloadNewImageCollectionView() {
        DispatchQueue.main.async {
            self.newImagesCollectionView.reloadData()
        }
    }

    func didImageItemAdded(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.newImagesCollectionView.insertItems(at: indexPaths)
        }
    }
    
    func needReloadSearchResultCollectionView() {
        DispatchQueue.main.async {
            self.searchResultCollectionView.reloadData()
            self.searchResultCollectionView.contentOffset = .zero
        }
    }
    
    func didSearchImageItemAdded(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.searchResultCollectionView.insertItems(at: indexPaths)
        }
    }
    
    func setTopPhoto(_ photo: Photo) {
        ImageDownloadManager.shared.downloadImage(photo.urls.regular) { [weak self] (image, _, _, _) in
            DispatchQueue.main.async {
                self?.topImageView.image = image
                self?.artistNameLabel.text = "Photo by \(photo.user.username)"
            }
        }
    }
}

extension SearchViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard velocity.y > 0 else { return }
        
        let height = scrollView.contentSize.height
        
        if height * 0.7 < velocity.y + targetContentOffset.pointee.y {
            if scrollView == newImagesCollectionView {
                searchViewModel.aboutToReachingBottom()
            } else if true {
                searchViewModel.aboutToReachingBottomSearchResult()
            }
        }
    }
    
    func stickeyHeaderBehavior(_ scrollView: UIScrollView, _ parentViewMaxContentYOffset: CGFloat) {
        if scrollGoingUp == true {
            if scrollView == newImagesCollectionView {
                if superScrollView.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    superScrollView.contentOffset.y = min(superScrollView.contentOffset.y + newImagesCollectionView.contentOffset.y, parentViewMaxContentYOffset)
                    
                    newImagesCollectionView.contentOffset.y = 0
                }
            }
            
        } else {
            if scrollView == newImagesCollectionView {
                if newImagesCollectionView.contentOffset.y < 0 && superScrollView.contentOffset.y > 0 {
                    superScrollView.contentOffset.y = max(superScrollView.contentOffset.y - abs(newImagesCollectionView.contentOffset.y), 0)
                }
            }
            
            if scrollView == superScrollView {
                if newImagesCollectionView.contentOffset.y > 0 && superScrollView.contentOffset.y < parentViewMaxContentYOffset {
                    childScrollingDownDueToParent = true
                    
                    newImagesCollectionView.contentOffset.y = max(newImagesCollectionView.contentOffset.y - (parentViewMaxContentYOffset - superScrollView.contentOffset.y), 0)
                    
                    superScrollView.contentOffset.y = parentViewMaxContentYOffset
                    
                    childScrollingDownDueToParent = false
                }
            }
        }
        
        if scrollView != searchResultCollectionView {
            let contentOffsetY = superScrollView.contentOffset.y
            
            keytakeawayLabel.transform = CGAffineTransform(translationX: 0, y: contentOffsetY * 0.135)
            
            keytakeawayLabel.alpha = 1 / max(contentOffsetY, 1) * 50
            topImageView.alpha = 1 / max(contentOffsetY, 1) * 50
            
            searchBar.transform = CGAffineTransform(translationX: 0, y: contentOffsetY * 0.135)
            
            topContainer.transform = CGAffineTransform(translationX: 0, y: contentOffsetY * (topContainer.frame.height - stickeyViewHeight + 35) / parentViewMaxContentYOffset)
            
            if contentOffsetY + 30 >= parentViewMaxContentYOffset {
                topImageView.alpha = 0
                keytakeawayLabel.alpha = 0
                artistNameLabel.alpha = 0
            }
            
            if contentOffsetY < 0 {
                let scale = 1 + (-contentOffsetY * 1.0 / topImageView.frame.height)
                
                let transform = CGAffineTransform(translationX: 0, y: contentOffsetY / 2)
                topImageView.transform = transform.scaledBy(x: scale, y: scale)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollGoingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        
        let parentViewMaxContentYOffset = superScrollView.contentSize.height - superScrollView.frame.height
        
        stickeyHeaderBehavior(scrollView, parentViewMaxContentYOffset)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setViewMode(.search)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.searchTextChanged(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setViewMode(.normal)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.searchBegin()
    }
}

extension SearchViewController: ViewControllerDismissDelegate {
    func dismissCalledFromChild(lastIndexPath: IndexPath) {
        self.superScrollView.contentOffset.y = self.superScrollView.contentSize.height - self.superScrollView.frame.height

        switch self.viewMode {
        case .normal:
            self.newImagesCollectionView.scrollToItem(at: lastIndexPath, at: .centeredVertically, animated: false)
        case .search:
            self.searchResultCollectionView.scrollToItem(at: lastIndexPath, at: .centeredVertically, animated: false)
            self.searchResultCollectionView.contentOffset.y += stickeyViewHeight
        }

        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
    }
}
