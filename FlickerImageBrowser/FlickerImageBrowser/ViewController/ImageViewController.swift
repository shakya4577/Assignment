import UIKit

class ImageViewController: UIViewController
{
    let fullImageView = UIImageView()
    var imageURL = String()
    var thumbImage = UIImage(named: "Placeholder")
    var startCoordinates: CGPoint = CGPoint(x: 0,y: 0)
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(imageURL)
        self.view.addSubview(fullImageView)
        setBackgroundImageButtonConstraint()
        fullImageView.image = UIImage(named: "Placeholder")
        fullImageView.contentMode = .scaleToFill
        
        //To dismiss on slide
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        ImageDownloadManager.shared.downloadHDImage(imgUrl: imageURL) { (downloadedImage:UIImage?) in
            self.fullImageView.image = downloadedImage
        }
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer)
    {
        let currentCoordinates = sender.location(in: self.view?.window)
        switch sender.state {
        case .began:startCoordinates = currentCoordinates;
        case .changed:
            do
            {
                if currentCoordinates.y - self.startCoordinates.y > 0
                {
                    self.view.frame = CGRect(x: 0, y: currentCoordinates.y - self.startCoordinates.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            }
        case .ended,.cancelled :
            do {
                if currentCoordinates.y - self.startCoordinates.y > 150
                {
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    UIView.animate(withDuration: 0.5, animations:
                        {
                            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    })
                }
            }
        default: break
            
        }
    }
    
    func setBackgroundImageButtonConstraint()
    {
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: fullImageView, attribute: .left, relatedBy: .equal, toItem: view, attribute:.left, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: fullImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: fullImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        let heightConstraint = NSLayoutConstraint(item: fullImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: self.view.frame.height)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
}
