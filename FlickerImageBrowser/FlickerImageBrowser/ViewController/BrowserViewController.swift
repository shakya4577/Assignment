
import UIKit

class BrowserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate,UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var allImageURL = [String]()
    var visibleImageURL = [String]()
    var cellReusableIdentifier = "ImageCell"
    var searchBar:UISearchBar =  UISearchBar()
    var actionSheetController = UIAlertController()
    var imgCanFit = Int()
    var numbOfCellInRow = Int()
    var cellCounter = 0
    var lastSearchedTag = String()
    var numberOfCellInARow:Int
    {
        set
        {
            numbOfCellInRow = newValue
            let cellSize = (imageCollectionView.frame.width / CGFloat(numbOfCellInRow)) * (imageCollectionView.frame.width / CGFloat(numbOfCellInRow))
            let areaOfView = view.frame.width * view.frame.height
            imgCanFit = Int(areaOfView / cellSize)
            browseImages(tag: "IOS", upto: imgCanFit)
        }
        get
        {
            return numbOfCellInRow
        }
    }
    var lastY = CGFloat(Int.min)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        uiElementInit()
        
        //Setting Delegates
        searchBar.delegate = self
        numberOfCellInARow = 2
    }
    
    
    @objc func collectionViewLayoutChange()
    {
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func browseImages(tag:String, upto:Int)
    {
        if lastSearchedTag != tag
        {
            lastSearchedTag = tag
            showLoading()
            ImageDownloadManager.shared.getImagesUrl(searchText: tag) { (imgURLArray: [String]!) in
                self.dismiss(animated: false, completion: nil)
                self.allImageURL = imgURLArray
                if self.allImageURL.count == 0
                {
                    self.noImagePopUp()
                }
                self.visibleImageURL = upto < self.allImageURL.count ? Array(self.allImageURL[0...upto]): imgURLArray
                self.imageCollectionView.reloadData()
            }
        }
        else
        {
            self.visibleImageURL = Array(self.allImageURL[0...upto])
            self.imageCollectionView.reloadData()
        }
       
    }
    
    func noImagePopUp()
    {
        let alert = UIAlertController(title: "Image Browser", message: "No Image Found.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoading()
    {
        let alert = UIAlertController(title: nil, message: "Loading Images...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func uiElementInit()
    {
        //Top Search Bar
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-60, height: 20))
        searchBar.placeholder = "Search for Image here"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)
        
        //Right Navigation Button
        let righBarButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(collectionViewLayoutChange))
        self.navigationItem.rightBarButtonItem = righBarButton
        
        //Action Sheet to show options
        actionSheetController = UIAlertController(title: "Please select", message: "How many images you want to see in a row", preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) {
            action -> Void in
        }
        
        actionSheetController.addAction(cancelButton)
        let option2 = UIAlertAction(title: "2", style: .default)
        { action -> Void in
            self.numberOfCellInARow = 2
            self.imageCollectionView.reloadData()
        }
        actionSheetController.addAction(option2)
        let option3 = UIAlertAction(title: "3", style: .default)
        { action -> Void in
            self.numberOfCellInARow = 3
            self.imageCollectionView.reloadData()
        }
        actionSheetController.addAction(option3)
        
        let option4 = UIAlertAction(title: "4", style: .default)
        { action -> Void in
            self.numberOfCellInARow = 4
            self.imageCollectionView.reloadData()
        }
        actionSheetController.addAction(option4)
        actionSheetController.popoverPresentationController?.sourceView = self.view
    }
}

