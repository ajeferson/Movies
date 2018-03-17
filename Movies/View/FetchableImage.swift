////
////  FetchableImage.swift
////  Movies
////
////  Created by Alan Jeferson on 16/03/2018.
////  Copyright © 2018 ajeferson. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//class FetchableImage {
//
//    /// Directly acess the UIImage. Is preferrable to use getImage()
//    var _image: UIImage?
//
//    var fetching = false
//
//    var downloaded: Bool {
//        return _image != nil
//    }
//
//    var uploading = false
//    var uploaded: Bool {
//        return url != nil
//    }
//
//    var url: String?
//
//    var fullUrl: String? {
//        if let url = self.url {
//            return URLManager.completeImageURL(forRelativeURL: url)
//        }
//        return nil
//    }
//
//    init(url: String) {
//        self.url = url
//    }
//
//    init(image: UIImage) {
//        _image = image
//    }
//
//    init?(url: String?, image: UIImage?)
//    {
//        self.url = url
//        self._image = image
//
//        if self.url == nil && self._image == nil {
//            return nil
//        }
//    }
//
//    func getImage(_ completionHandler: @escaping ((_ image: UIImage?) -> Void)) {
//
//        // If Already fetching
//        if fetching {
//            DispatchQueue.main.async { completionHandler(nil) }
//            return
//        }
//        fetching = true
//
//        // Already here (on object?)
//        if let image = _image {
//            fetching = false
//            DispatchQueue.main.async { completionHandler(image) }
//            return
//        }
//
//        // Guarantee it has url
//        guard let url = url else {
//            fetching = false
//            completionHandler(nil);
//            return
//        }
//
//        // Already here (on cache?)
//        if let chachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
//            fetching = false
//            _image = chachedImage
//            DispatchQueue.main.async { completionHandler(self._image) }
//            return
//        }
//
//        let fetchURL = URLManager.completeImageURL(forRelativeURL: url)
//
//        // Go fetch on internet
//        Alamofire.request(fetchURL).validate().responseData { (response) in
//            self.fetching = false
//            if let data = response.result.value, let img = UIImage(data: data) {
//                imageCache.setObject(img, forKey: url as AnyObject)
//                self._image = img
//                DispatchQueue.main.async { completionHandler(self._image) }
//                return
//            } else {
//                completionHandler(nil)
//                return
//            }
//        }
//    }
//
//    func upload(toImageable imageable: Imageable, completion: @escaping ((_ url: String?) -> Void)) {
//
//        if uploaded || uploading {
//            completion(url)
//        }
//
//        uploading = true
//
//        let uploadUrl = URLManager.imageableUrl(imageable)
//
//        Alamofire.upload(multipartFormData: { [weak self] multiformatData in
//
//            guard let data = self?._image?.compressedJPEGData else {
//                self?.uploading = false
//                completion(nil)
//                return
//            }
//
//            let date = Date()
//            let filename = "\(arc4random())\(Int(date.timeIntervalSince1970))\(arc4random()).jpeg"
//            multiformatData.append(
//                data,
//                withName: "image[image]",
//                fileName : filename,
//                mimeType: "image/jpeg")
//
//            }, usingThreshold: 10_000_000,
//               to: uploadUrl,
//               method : .post,
//               headers: DatabaseConfig.userImagePostHeader) { [weak self] encodingResults in
//
//                switch encodingResults {
//
//                case .success(let upload, _, _):
//
//                    upload
//                        .validate()
//                        .responseJSON(completionHandler: { (response) in
//
//                            var url: String?
//
//                            switch response.result {
//
//                            case .success(let value):
//                                let json = JSON(value)
//                                url = json["image"]["url"].stringValue
//
//                            case .failure(let error):
//                                print(error)
//
//                            }
//
//                            self?.url = url
//                            self?.uploading = false
//                            DispatchQueue.main.async {
//                                completion(url)
//                            }
//
//                        })
//
//                case .failure(let error) :
//                    print(error)
//                    self?.uploading = false
//                    DispatchQueue.main.async {
//                        completion(nil)
//                    }
//                }
//        }
//
//    }
//
//    func copy() -> FetchableImage {
//        let fetchable = FetchableImage(url: url, image: _image)!
//        fetchable.fetching = false
//        fetchable.uploading = false
//        return fetchable
//    }
//
//}

