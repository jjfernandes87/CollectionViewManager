//
//  ViewController.swift
//  CollectionManager_Example
//
//  Created by Julio Fernandes on 31/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CollectionManager

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: CollectionViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.items = [CustomCell(),CustomCell(),CustomCell(),CustomCell(),CustomCell(),CustomCell()]
    }

}

@objc(CustomCell)
class CustomCell: CellController {
    override func collectionView(_ collectionView: UICollectionView, prefetchItem indexPath: IndexPath) {
        let cell = loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CustomCellView
        cell.label.text = "index: \(indexPath.item)"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CustomCellView
        cell.label.text = "index: \(indexPath.item)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}

class CustomCellView: CellView {
    @IBOutlet weak var label: UILabel!
}

