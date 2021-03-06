//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import UIKit

protocol SearchViewInput: AnyObject {
    func viewDidLoad()
    func aboutToReachingBottom()
    func aboutToReachingBottomSearchResult()
    func searchTextChanged(_ text: String)
    func searchBegin()
}

protocol SearchViewOutput: AnyObject {
    func setTopPhoto(_ photo: Photo)
    func needReloadExplorerCollectionView()
    func needReloadNewImageCollectionView()
    func needReloadSearchResultCollectionView()
    func didImageItemAdded(indexPaths: [IndexPath])
    func didSearchImageItemAdded(indexPaths: [IndexPath])
    func isLoading(_ isLoading: Bool)
}

class SearchViewModel: SearchViewInput {
    weak var searchViewOutput: SearchViewOutput?
    
    let initialState: State
    var currentState: State
    
    struct State {
        var topImage: UIImage?
        var explorerPhotos: [Photo]
        var newImagePhotos: [Photo]
        var newImagePage: Int
        var searchText: String
        var searchResultPhotos: [Photo]
        var searchPage: Int
        var searchingRequest: URLSessionTask?
        var isRequestingNewPhotos: Bool
        var isLastPageOfNewPhotos: Bool
        var isLastPageOfSearch: Bool
    }
    
    let apiClient: APIClient = APIClient()
    
    init() {
        initialState = State(
            topImage: nil,
            explorerPhotos: [],
            newImagePhotos: [],
            newImagePage: 1,
            searchText: "",
            searchResultPhotos: [],
            searchPage: 1,
            searchingRequest: nil,
            isRequestingNewPhotos: false,
            isLastPageOfNewPhotos: false,
            isLastPageOfSearch: false
        )
        currentState = initialState
    }
    
    func viewDidLoad() {
        searchViewOutput?.isLoading(true)
        
        apiClient.reqeust(PhotoResponse.self, apiRouter: .getPhoto(page: currentState.newImagePage, perPage: 10, orderBy: .latest)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.currentState.newImagePhotos = response.photos
                self?.currentState.isLastPageOfNewPhotos = response.isLastPage
                self?.searchViewOutput?.needReloadNewImageCollectionView()
                self?.setTopPhoto(Array(response.photos[1...]))
            case .failure(let error):
                print("error \(error)")
            }
            
            self?.searchViewOutput?.isLoading(false)
        }
    }
    
    func aboutToReachingBottom() {
        guard !currentState.isRequestingNewPhotos else { return }
        guard !currentState.isLastPageOfNewPhotos else {
            print("Rechead last page.")
            return
        }

        currentState.isRequestingNewPhotos = true
        currentState.newImagePage += 1
        
        let beforeCount: Int = currentState.newImagePhotos.count

        apiClient.reqeust(PhotoResponse.self, apiRouter: .getPhoto(page: currentState.newImagePage, perPage: 10, orderBy: .latest)) { [weak self] result in
            guard let self = self else { return }
            self.currentState.isRequestingNewPhotos = false
            switch result {
            case .success(let response):
                self.currentState.isLastPageOfNewPhotos = response.isLastPage
                self.currentState.newImagePhotos.append(contentsOf: response.photos)
                var addedIndexPaths: [IndexPath] = []

                for index in beforeCount ..< self.currentState.newImagePhotos.count {
                    addedIndexPaths.append(IndexPath(row: index, section: 0))
                }

                self.searchViewOutput?.didImageItemAdded(indexPaths: addedIndexPaths)
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    func searchCancel() {
        currentState.searchText = ""
        currentState.searchPage = 1
        currentState.searchingRequest?.cancel()
        currentState.searchingRequest = nil
    }
    
    func searchTextChanged(_ text: String) {
        currentState.searchText = text
    }
    
    func searchBegin() {
        guard !currentState.searchText.isEmpty else {
            print("Keyword is empty.")
            return
        }
        
        currentState.searchPage = 1
        
        if currentState.searchingRequest != nil {
            currentState.searchingRequest?.cancel()
            currentState.searchingRequest = nil
        }
        
        let keyword = currentState.searchText
        
        let request = apiClient.reqeust(SearchPhotoResponse.self, apiRouter: .searchPhoto(keyword: keyword, page: 1)) { [weak self] result in
            guard let self = self else { return }
            self.currentState.isRequestingNewPhotos = false
            switch result {
            case .success(let response):
                self.currentState.searchResultPhotos = response.results
                self.searchViewOutput?.needReloadSearchResultCollectionView()
            case .failure(let error):
                print("error \(error)")
            }
            
            self.searchViewOutput?.isLoading(false)
        }
        
        self.currentState.searchingRequest = request
        
        if request != nil {
            self.searchViewOutput?.isLoading(true)
        }
    }
    
    func aboutToReachingBottomSearchResult() {
        guard !currentState.isLastPageOfSearch else {
            print("This is last page.")
            return
        }
        
        let keyword = currentState.searchText
        currentState.searchPage += 1
        
        let beforeCount = currentState.searchResultPhotos.count
        
        let request = apiClient.reqeust(SearchPhotoResponse.self, apiRouter: .searchPhoto(keyword: keyword, page: currentState.searchPage)) { [weak self] result in
            guard let self = self else { return }
            self.currentState.isRequestingNewPhotos = false
            switch result {
            case .success(let response):
                self.currentState.searchResultPhotos.append(contentsOf: response.results)
                
                var addedIndexPaths: [IndexPath] = []
                for index in beforeCount ..< self.currentState.searchResultPhotos.count {
                    addedIndexPaths.append(IndexPath(row: index, section: 0))
                }
                
                self.searchViewOutput?.didSearchImageItemAdded(indexPaths: addedIndexPaths)
            case .failure(let error):
                print("error \(error)")
            }
        }
        
        currentState.searchingRequest = request
    }
    
    
    func setTopPhoto(_ photos: [Photo]) {
        guard let randomPhoto = photos.randomElement() else { return }
        
        searchViewOutput?.setTopPhoto(randomPhoto)
    }
}
