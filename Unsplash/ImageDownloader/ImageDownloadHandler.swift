//
//  ImageDownloadHandler.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import Foundation
import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ imageUrl: String, _ IndexPath: IndexPath?, _ error: Error?) -> Void

typealias ImageDownloadResult = (image: UIImage?, imageUrlString: String, indexPath: IndexPath?, error: Error?)

final class ImageDownloadManager {
    private var completionHandler: ImageDownloadHandler?
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "net.eazel.Eazel.imageDownloadQueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = ImageDownloadManager()
    private init () {}
    
    func downloadImage(_ imageUrl: String, indexPath: IndexPath? = nil, handler: ImageDownloadHandler?) {
        
        if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
            handler?(cachedImage, imageUrl, indexPath, nil)
        } else {
            if let operations = imageDownloadQueue.operations as? [ImageOperation],
                let operation = operations.filter({ $0.imageUrlString == imageUrl && !$0.isFinished && $0.isExecuting }).first {
                
                operation.queuePriority = .high
            } else {
                let operation = ImageOperation(url: imageUrl, indexPath: indexPath)
                if indexPath == nil {
                    operation.queuePriority = .veryHigh
                }
                operation.downloadHandler = { (image, url, indexPath, error) in
                    if error != nil {
                        print("image downloading error \(url) \(error!.localizedDescription)")
                    }
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: url as NSString)
                    }
                    
                    handler?(image, url, indexPath, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }

    
    func cancelDownloadImage(_ imageUrlString: String, indexPath: IndexPath?) {
        guard let operation = getOperation(with: imageUrlString) else { return }
        
        operation.downloadHandler = nil
        operation.cancelDownloadImageTask()
    }
    
    func getOperation(with imageUrlString: String) -> ImageOperation? {
        guard let operations = imageDownloadQueue.operations as? [ImageOperation],
        let operation = operations.filter({ $0.imageUrlString == imageUrlString && !$0.isFinished && $0.isExecuting }).first else { return nil }
        
        return operation
    }
}


