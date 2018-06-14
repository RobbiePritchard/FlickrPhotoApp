//
//  ViewController.swift
//  WhoopProject
//
//  Created by Robbie Pritchard on 6/14/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flickrImages = [FlickrItem]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.placeholder = "Search Flickr!"
        searchBar.delegate = self
        
        // get default images
        getImages(withTag: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImages(withTag tag: String?){


        FlickrManager.shared.getImages(withTag: tag){ (response) in

            switch response{
                
            case .Success(let items):
                    self.flickrImages = items
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    }
            case .Failure(let errorMessage):
                self.showError(withMessage: errorMessage)
            }

        }
    }
    func showError(withMessage error: String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Network Error", message: error, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }

    }


}
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getImages(withTag: searchBar.text)
        searchBar.endEditing(true)
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        
        //get photo when were about to show the cell
        let flickerItem = flickrImages[indexPath.item]
        cell.imageView.downloadImage(from: flickerItem.media.m, withContentMode: .scaleAspectFill)
        
        return cell
    }
    
    //just some fun sizing stuff
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.width / 2)
        
    }
}


class ImageCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
}

