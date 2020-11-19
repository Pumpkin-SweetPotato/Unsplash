//
//  DetailViewModel.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/18.
//

import UIKit

protocol DetailViewInput: AnyObject {
    func viewDidLoad()
    func shareButtonTapped()
    func infoButtonTapped()
    func likeButtonTapped()
    func plusButtonTapped()
    func downloadButtonTapped()
    func currentIndexChanged(indexPath: IndexPath)
}

protocol DetailViewOutput: AnyObject {
    func setArtistName(_ artistName: String)
}

class DetailViewModel: DetailViewInput {
        
    weak var detailViewOutput: DetailViewOutput?
    
    let initialState: State
    var currentState: State
    
    struct State {
        var photos: [Photo]
        var currentIndex: IndexPath
        var currentArtistName: String
    }
    
    let apiClient: APIClient = APIClient()
    
    init(photos: [Photo], selectedIndex: IndexPath) {
        initialState = State(photos: photos,
                             currentIndex: selectedIndex,
                             currentArtistName: photos[selectedIndex.row].user.username
        )
        currentState = initialState
    }
    
    func currentIndexChanged(indexPath: IndexPath) {
        currentState.currentIndex = indexPath
        let artistName = currentState.photos[indexPath.row].user.username
        detailViewOutput?.setArtistName(artistName)
    }
    
    func viewDidLoad() {
                
    }
    
    func shareButtonTapped() {
         
    }
    
    func infoButtonTapped() {
         
    }
    
    func likeButtonTapped() {
         
    }
    
    func plusButtonTapped() {
         
    }
    
    func downloadButtonTapped() {
         
    }
    

}
