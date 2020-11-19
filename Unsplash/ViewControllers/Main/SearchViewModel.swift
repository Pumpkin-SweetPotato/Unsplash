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
}

protocol SearchViewOutput: AnyObject {
    func needReloadExplorerCollectionView()
    func needReloadNewImageCollectionView()
    func didImageItemAdded(indexPaths: [IndexPath])
}

class SearchViewModel: SearchViewInput {
    
    weak var searchViewOutput: SearchViewOutput?
    
    let initialState: State
    var currentState: State
    
    struct State {
        var explorerPhotos: [Photo]
        var newImagePhotos: [Photo]
        var newImagePage: Int
        var isRequestingNewPhotos: Bool
        var isLastPageOfNewPhotos: Bool
    }
    
    let apiClient: APIClient = APIClient()
    
    init() {
        initialState = State(
            explorerPhotos: [],
            newImagePhotos: [],
            newImagePage: 6903,
            isRequestingNewPhotos: false,
            isLastPageOfNewPhotos: false
        )
        currentState = initialState
    }
    
    func viewDidLoad() {
        apiClient.reqeust(PhotoResponse.self, apiRouter: .getPhoto(page: currentState.newImagePage, perPage: 10, orderBy: .latest)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.currentState.newImagePhotos = response.photos
                self?.currentState.isLastPageOfNewPhotos = response.isLastPage
                self?.searchViewOutput?.needReloadNewImageCollectionView()
            case .failure(let error):
                print("error \(error)")
            }
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
                print("isLastPageOfNewPhotos \(self.currentState.isLastPageOfNewPhotos)")
                print("response.isLastPage \(response.isLastPage)")
                self.currentState.isLastPageOfNewPhotos = response.isLastPage
                print("isLastPageOfNewPhotos \(self.currentState.isLastPageOfNewPhotos)")
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
    
}
