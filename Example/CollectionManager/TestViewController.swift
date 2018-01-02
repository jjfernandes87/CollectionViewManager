//
//  TestViewController.swift
//  CollectionManager
//
//  Created by jjfernandes87 on 12/24/2017.
//  Copyright (c) 2017 jjfernandes87. All rights reserved.
//

import UIKit
import CollectionManager

class TestViewController: UIViewController {
    
    @IBOutlet weak var collectionView: CollectionViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.managerProtocol = self
    }
}

extension TestViewController: CollectionManagerDelegate {
    
}

@objc(CustomTestCell)
class CustomTestCell: CellController {
    override func collectionView(_ collectionView: UICollectionView, prefetchItem indexPath: IndexPath) {
        let cell = loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CustomTestCellView
        cell.label.text = "index: \(indexPath.item)"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CustomTestCellView
        cell.label.text = "index: \(indexPath.item)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CustomTestCellView
        cell.label.text = "index: \(indexPath.item)"
    }
}

class CustomTestCellView: CellView {
    @IBOutlet weak var label: UILabel!
}

