import UIKit

extension BrowserViewController
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        browseImages(tag: searchBar.text!,upto: imgCanFit)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return visibleImageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: cellReusableIdentifier, for: indexPath as IndexPath) as! ImageCell
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: cellReusableIdentifier, for: indexPath as IndexPath) as! ImageCell
        let vc = ImageViewController()
        vc.imageURL = visibleImageURL[indexPath.row]
        vc.thumbImage =  cell.imageView.image
        vc.modalPresentationStyle = .overFullScreen;
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let cell:ImageCell = cell as! ImageCell
        cell.setImage(imageUrl: visibleImageURL[indexPath.row])
        cellCounter = indexPath.row
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = (imageCollectionView.frame.width / CGFloat(numberOfCellInARow)) - 20.0
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if cellCounter == 0
        {
            return
        }
        if cellCounter == visibleImageURL.count-1
        {
            let diff = lastY - scrollView.contentOffset.y
            if diff >  -50
            {
                var downloadUpto = imgCanFit + visibleImageURL.count-1
                if downloadUpto > allImageURL.count-1
                {
                    downloadUpto = allImageURL.count - 1
                }
                browseImages(tag:lastSearchedTag, upto: downloadUpto)
            }
            else
            {
                lastY = scrollView.contentOffset.y
            }
        }
    }
    
}
