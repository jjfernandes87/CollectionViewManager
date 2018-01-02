//
//  CustomXibCell.swift
//  CollectionManager
//
//  Created by Julio Fernandes on 02/01/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CollectionManager

@objc(CustomXibCell)
class CustomXibCell: CellController {
    override func collectionView(_ collectionView: UICollectionView, prefetchItem indexPath: IndexPath) {
        let cell = loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CustomXibCellView
        cell.label.text = "index: \(indexPath.item)"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CustomXibCellView
        cell.label.text = "index: \(indexPath.item)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CustomXibCellView
        cell.label.text = "index: \(indexPath.item)"
    }
}

class CustomXibCellView: CellView {
    @IBOutlet weak var label: UILabel!
}
