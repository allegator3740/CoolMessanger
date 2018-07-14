//
//  Extensions.swift
//  
//
//  Created by Oleg on 14.07.2018.
//

import UIKit

let imageCached = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        let url = URL(string: urlString)
        
        //checf cache for image first
        if let cached = imageCached.object(forKey: urlString as AnyObject) {
            self.image = cached as? UIImage
            return
        }
        
        //otherwise fire off a new download
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCached.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
            })
            }.resume()
    }
}
