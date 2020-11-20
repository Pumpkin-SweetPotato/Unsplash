//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import UIKit

class SearchViewController: UIViewController {

    private let rootView: UIView = UIView()
    private let scrollView: UIScrollView = UIScrollView()
    private let scrollContentView: UIView = UIView()
    
    //
    private let topContainer: UIView = {
        let topContainer = UIView()
        topContainer.backgroundColor = .red
        
        return topContainer
    }()
    
    private let topImageView: UIImageView = {
        let topImageView = UIImageView()
        
        return topImageView
    }()
    
    private let appInfoButton: UIButton = {
        let appInfoButton = UIButton()
        appInfoButton.setTitle("App", for: .normal)
        
        return appInfoButton
    }()
    
    private let userInfoButton: UIButton = {
        let userInfoButton = UIButton()
        userInfoButton.setTitle("User", for: .normal)
        
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
//        searchBar.searchTextField.textColor = .white
//        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        
        return searchBar
    }()
    
    private let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 9, weight: .light)
        artistNameLabel.textColor = .white
        artistNameLabel.text = "Photo by Aaron Burden"
        
        return artistNameLabel
    }()
    
    //
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    //
    
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
        newImagesContainer.backgroundColor = .gray
        
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
    
    lazy var explorerCellSize: CGSize = CGSize(width: explorerCollectionView.bounds.size.width - ViewConstants.leading * 2, height: 150)
    lazy var newImageCellSize: CGSize = CGSize(width: explorerCollectionView.bounds.size.width - ViewConstants.leading * 2, height: 300)

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    private func addViews() {
        view.addSubview(rootView)
        rootView.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(topContainer)

        topContainer.addSubview(topImageView)
        topContainer.addSubview(appInfoButton)
        topContainer.addSubview(userInfoButton)
        topContainer.addSubview(keytakeawayLabel)
        topContainer.addSubview(searchBar)
    
        scrollContentView.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(bottomExplorerImageContainer)
        
        bottomExplorerImageContainer.addSubview(explorerContainer)
        explorerContainer.addSubview(explorerLabel)
        explorerContainer.addSubview(explorerCollectionView)
        
        bottomExplorerImageContainer.addSubview(newImagesContainer)
        newImagesContainer.addSubview(newImageLabel)
        newImagesContainer.addSubview(newImagesCollectionView)
        
        bottomStackView.addArrangedSubview(searchContainer)
        searchContainer.addSubview(searchResultCollectionView)
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: rootView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            scrollView.heightAnchor.constraint(equalTo: rootView.heightAnchor),
            scrollView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        ])
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        scrollContentView.backgroundColor = .brown
        
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.backgroundColor = .cyan
//
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            topContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.43),
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
            appInfoButton.widthAnchor.constraint(equalToConstant: 35),
            appInfoButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        userInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userInfoButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -ViewConstants.trailing),
            userInfoButton.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 30),
            userInfoButton.widthAnchor.constraint(equalToConstant: 35),
            userInfoButton.heightAnchor.constraint(equalToConstant: 35),
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
        newImagesContainer.backgroundColor = .white
        

        NSLayoutConstraint.activate([
            newImagesContainer.topAnchor.constraint(equalTo: explorerContainer.bottomAnchor),
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
            newImagesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            newImagesCollectionView.trailingAnchor.constraint(equalTo: newImagesContainer.trailingAnchor),
            newImagesCollectionView.bottomAnchor.constraint(equalTo: newImagesContainer.bottomAnchor),
        ])
        
        searchContainer.translatesAutoresizingMaskIntoConstraints = false

        searchResultCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchResultCollectionView.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            searchResultCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            searchResultCollectionView.widthAnchor.constraint(equalTo: searchContainer.widthAnchor),
            searchResultCollectionView.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor)
        ])
    }

    private func setDelegates() {
        scrollView.delegate = self
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
        }
    }
    
    func didSearchImageItemAdded(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.searchResultCollectionView.insertItems(at: indexPaths)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentY = scrollView.contentOffset.y

    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("searchBarShouldBeginEditing")
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.setShowsCancelButton(true, animated: true)
            self.explorerContainer.isHidden = true
            self.newImagesContainer.isHidden = true
            self.searchResultCollectionView.isHidden = false
            self.bottomStackView.layoutIfNeeded()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.searchTextChanged(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.searchCancel()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
            self.searchResultCollectionView.isHidden = true
            self.explorerContainer.isHidden = false
            self.newImagesContainer.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.searchBegin()
    }
}
