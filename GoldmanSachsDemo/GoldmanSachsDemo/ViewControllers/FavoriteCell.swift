//
//  FavoriteCell.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var cacheManager = ImageCacheManager()
 
    /// This will load image from cache
    ///
    /// - Parameter imageURL: path(URL) to load image form cache.
    private func displayImage(image : UIImage) {
        self.imgView.image = image
    }
    
    func loadImage(fromImageURL imageURL: String? , completion: @escaping ()->()) {
        
        guard let imagePath = imageURL else {
            return
        }
        if let imageURL: URL = URL(string: imagePath) {
            if cacheManager.checkImageCacheExistance(fromURL: imagePath) {
                let imageData = cacheManager.fetchImageFromCache(imagePath: imagePath)
                displayImage(image: imageData)
                setNeedsLayout()
                completion()
            }
            else{
                self.imgView.af_setImage(withURL: imageURL,
                                         imageTransition: .crossDissolve(0.5),
                                         runImageTransitionIfCached: true,
                                         completion: { response in
                                            if response.result.error != nil{
                                                self.cacheManager.saveImageIntoCache(imageURL: imagePath, withImageData: #imageLiteral(resourceName: "loading"))
                                                self.displayImage(image: self.cacheManager.fetchImageFromCache(imagePath: imagePath))
                                            } else {
                                                if let imageToCache = response.result.value{
                                                    self.cacheManager.imageCache.setObject(imageToCache, forKey: imagePath as NSString)
                                                    self.setNeedsLayout()
                                                    completion()
                                                }
                                            }
                })
            }
        }
    }
}
