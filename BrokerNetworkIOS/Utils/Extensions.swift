//
//  Extensions.swift
//  BrokerNetworkIOS
//
//  Created by Gaurav on 17/05/22.
//

import Foundation
import UIKit
extension UIView {
    
    func cornerRadius(borderColor: UIColor = UIColor.white, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 10) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIButton {
    func setRoundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}


var imageCache = NSMutableDictionary()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        if let img = imageCache.value(forKey: urlString) as? UIImage{
            self.image = img
        } else {
            let session = URLSession.shared
            if let url = URL(string: urlString) {
                let task = session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                    if(error == nil){
                        if let img = UIImage(data: data!) {
                            imageCache.setValue(img, forKey: urlString)
                            DispatchQueue.main.async {
                                self.image = img
                            }
                        }
                    }
                })
                task.resume()
            } else {
                print("Invalid Image Url")
            }
            
        }
    }
}
