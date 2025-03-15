import UIKit

extension UIImageView {
    func loadImage(from url: URL?, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        guard let url = url else { return }
        if let cachedImage = ImageCache.shared.getImage(for: url.absoluteString) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                return
            }
            
            ImageCache.shared.saveImage(image, for: url.absoluteString)
            
            DispatchQueue.main.async {
                self.image = image
                self.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
            }
        }.resume()
    }
}

class ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func saveImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
} 
