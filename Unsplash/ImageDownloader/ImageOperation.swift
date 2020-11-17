//
//  ImageOperation.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import UIKit

class ImageOperation: Operation {
    var downloadHandler: ImageDownloadHandler?
    var imageUrlString: String
    var dataTask: URLSessionDataTask?
    private var indexPath: IndexPath?
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    required init (url: String, indexPath: IndexPath?) {
        self.imageUrlString = url
        self.indexPath = indexPath
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        self.executing(true)
        //Asynchronous logic (eg: n/w calls) with callback
        self.startDownloadImageTask()
    }
    
    func startDownloadImageTask() {
        guard let url = URL(string: self.imageUrlString) else { return }
        
        self.dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                self.downloadHandler?(nil, self.imageUrlString, self.indexPath, error)
                return
            }
            self.finish(true)
            self.executing(false)
            self.downloadHandler?(UIImage(data: data), self.imageUrlString, self.indexPath, nil)
        }
        
        self.executing(true)
        
        self.dataTask?.resume()
    }
    
    func cancelDownloadImageTask() {
        self.dataTask?.cancel()
        self.dataTask = nil
        
        cancel()
    }
}
