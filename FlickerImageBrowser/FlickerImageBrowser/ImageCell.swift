import UIKit

class ImageCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!

    func setImage(imageUrl:String)
    {
        imageView.image = UIImage(named: "Placeholder")!
        ImageDownloadManager.shared.downloadImage(imgUrl: imageUrl) { (downloadedImage:UIImage?) in
            if let image = downloadedImage
            {
                self.imageView.image = image
            }
         }
    }
}
