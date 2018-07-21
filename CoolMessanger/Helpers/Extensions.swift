//
//  Extensions.swift
//  
//
//  Created by Oleg on 14.07.2018.
//

import UIKit

let imageCached = NSCache<AnyObject, AnyObject>()

public extension UIDevice {
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case Unknown
    }
    
    var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5     //Iphon SE
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        default:
            return .Unknown
        }
    }
    
}


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
