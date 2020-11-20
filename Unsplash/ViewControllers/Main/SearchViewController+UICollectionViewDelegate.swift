//
//  SearchViewController+UICollectionViewDelegate.swift
//  Unsplash
//
//  Created by ZES2017MBP on 2020/11/20.
//

import UIKit

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case explorerCollectionView:
                break
            case newImagesCollectionView:
                let detailViewModel = DetailViewModel(photos: searchViewModel.currentState.newImagePhotos, selectedIndex: indexPath)

                let detailViewController = DetailViewController(detailViewModel: detailViewModel)
                
                detailViewController.modalPresentationStyle = .overFullScreen
                detailViewController.dismissDelegate = self

                self.present(detailViewController, animated: true)
            case searchResultCollectionView:
                let detailViewModel = DetailViewModel(photos: searchViewModel.currentState.searchResultPhotos, selectedIndex: indexPath)

                let detailViewController = DetailViewController(detailViewModel: detailViewModel)
                
                detailViewController.modalPresentationStyle = .overFullScreen
                detailViewController.dismissDelegate = self

                self.present(detailViewController, animated: true)
            
            default:
                break
        }
       
    }
}

extension SearchViewController: FlexibleHeightCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        switch collectionView {
        case newImagesCollectionView:
            let photo = searchViewModel.currentState.newImagePhotos[indexPath.row]
            let imageWidthRatio: CGFloat = collectionView.bounds.width / CGFloat(photo.width)
            let imageHeight: CGFloat = CGFloat(photo.height) * imageWidthRatio
            
            return imageHeight
        case searchResultCollectionView:
            let photo = searchViewModel.currentState.searchResultPhotos[indexPath.row]
            let imageWidthRatio: CGFloat = collectionView.bounds.width / CGFloat(photo.width)
            let imageHeight: CGFloat = CGFloat(photo.height) * imageWidthRatio
            
            return imageHeight
        default:
            return .zero
        }
        
    }
}


extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        UICollectionViewFlowLayout.automaticSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case explorerCollectionView:
            return searchViewModel.currentState.explorerPhotos.count
        case newImagesCollectionView:
            return searchViewModel.currentState.newImagePhotos.count
        case searchResultCollectionView:
            return searchViewModel.currentState.searchResultPhotos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case explorerCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorerCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? ExplorerCollectionViewCell else { fatalError() }

            let photo = searchViewModel.currentState.explorerPhotos[indexPath.row]
            
            return cell
        case newImagesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewImageCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? NewImageCollectionViewCell else { fatalError() }
            
            let photo = searchViewModel.currentState.newImagePhotos[indexPath.row]
            
            cell.newImageCollectionViewCellModel = NewImageCollectionViewCellModel(photo: photo)
            
            return cell
        case searchResultCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewImageCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? NewImageCollectionViewCell else { fatalError() }
            
            let photo = searchViewModel.currentState.searchResultPhotos[indexPath.row]
            
            cell.newImageCollectionViewCellModel = NewImageCollectionViewCellModel(photo: photo)
            
            return cell
        default:
            fatalError()
        }
    }
}
