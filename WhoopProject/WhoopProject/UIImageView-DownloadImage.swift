//
//  UIImageView-DownloadImage.swift
//  WhoopProject
//
//  Created by Robbie Pritchard on 6/14/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from link:String, withContentMode: UIViewContentMode) {
        
        URLSession.shared.dataTask(with: URL(string: link)!){(data, response, error) in
            DispatchQueue.main.async {
                self.contentMode =  withContentMode
                if let data = data { self.image = UIImage(data: data) }
            }
            }.resume()
    }
}
