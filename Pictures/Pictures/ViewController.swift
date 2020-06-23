//
//  ViewController.swift
//  Pictures
//
//  Created by Mishchenko YULIIA on 10/3/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var itemImageArray: [URL] = [
        URL(string: "https://images.unsplash.com/photo-1486068720048-47715511ce71?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3150&q=80")!,
        URL(string: "https://images.unsplash.com/photo-1515419682769-91a8a6bdaf68?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3000&q=80")!,
        URL(string: "https://images.unsplash.com/photo-1545852528-fa22f7fcd63e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3151&q=80")!,
        URL(string: "https://images.unsphoto-1545911678-09d0843ccef1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyDd9&auto=format&fit=crop&w=1268&q=80")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as? ImageCollectionViewCell {
            itemCell.backgroundColor = UIColor.black
            
            let URLImage = itemImageArray[indexPath.row]
    
            DispatchQueue.global().async {
               if let URLData = try? Data(contentsOf: URLImage){
                DispatchQueue.main.async {
                    itemCell.imageIndicator.hidesWhenStopped = true
                    itemCell.imageIndicator.stopAnimating()
                    itemCell.imageView.image = UIImage(data: URLData) }
                }
                else {
                    let URLName = self.itemImageArray[indexPath.row]
                    let alertController = UIAlertController(title: "Error", message: "Cannot access to \(URLName)", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                     self.present(alertController, animated: true, completion: nil) }
            }
            return itemCell
        }
        return UICollectionViewCell()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MyScrollView {
            if let vc = segue.destination as? MyScrollView {
                if let collectionView = self.collectionView,
                    let indexPath = collectionView.indexPathsForSelectedItems?.first,
                    let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell,
                    let data = cell.imageView.image {
                    vc.image = data
                }
            }
        }
    }
}
    

