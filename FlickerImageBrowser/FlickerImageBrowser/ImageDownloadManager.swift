
import UIKit
import Alamofire
import SwiftyJSON

class ImageDownloadManager: NSObject
{
   private let API_KEY = "9d4b93cc06502918b7091d801c4a5010"
   private let FLICKR_URL = "https://api.flickr.com/services/rest/"
   private let METHOD = "flickr.photos.search"
   private let FORMAT_TYPE:String = "json"
   private let JSON_CALLBACK:Int = 1
   private let PRIVACY_FILTER:Int = 1
   private let EXTRA_URL = "url_o"
   static let shared = ImageDownloadManager()
   let imageCache = NSCache<NSString, UIImage>()
   lazy var downloadingImages = [String]()
    
    
    func getImagesUrl(searchText: String,completion: @escaping ([String]?) -> Void)
    {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach{ $0.cancel() }
        }
        let flickrUrl = URL(string: FLICKR_URL)
        Alamofire.request(flickrUrl!,
                          method: .get,
                          parameters:  ["method": METHOD, "api_key": API_KEY, "tags":searchText,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK,"extras":EXTRA_URL])
            .validate()
            .responseJSON
            {
                response in
                guard response.result.isSuccess else
                {
                    print("Error while loading url")
                    completion(nil)
                    return
                }
                guard  let value = response.result.value as? [String: Any] else
                {
                    print("Failed To Load Images URL")
                    completion(nil)
                    return
                }
                let json:JSON = JSON(value["photos"] as Any)
                let arrayNames =  json["photo"].arrayValue.map {$0["url_o"].stringValue}.filter({$0 != ""})
                completion(arrayNames)
        }
    }
    
    func downloadImage(imgUrl:String,completion: @escaping (UIImage?) -> Void)
    {
        let url = URL(string: imgUrl)
        if let cachedImage = imageCache.object(forKey: imgUrl as NSString)
        {
            completion(cachedImage)
        }
        else
        {
            if downloadingImages.contains((url?.lastPathComponent)!)
            {
                return
            }
            downloadingImages.append(imgUrl)
            Alamofire.request(url!, method: .get).responseData {
                response in
                self.downloadingImages = self.downloadingImages.filter({$0 != imgUrl})
                guard let data = response.result.value else {
                    completion(nil)
                    return
                }
                let image = UIImage(data: data)
                self.imageCache.setObject(image!, forKey: imgUrl as NSString)
                completion(image)
            }
        }
     }
    
    func downloadHDImage(imgUrl:String,completion: @escaping (UIImage?) -> Void)
    {
        let url = URL(string: imgUrl)
        Alamofire.request(url!, method: .get).responseData {
            response in
            guard let data = response.result.value else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
}
