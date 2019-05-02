//
//  CollectionViewManager.swift
//  CollectionManager
//
//  Created by Julio Fernandes on 24/12/17.
//

import UIKit

@objc public protocol CollectionManagerDelegate: NSObjectProtocol {
    @objc optional func collectionManager(collectionView: UICollectionView, didSelectItem item: CellController)
    @objc optional func collectionManager(collectionView: UICollectionView, didSelectIndexPath path: IndexPath)
    @objc optional func collectionManager(collectionView: UICollectionView, scrollView: UIScrollView)
    @objc optional func collectionManager(collectionView: UICollectionView, didEndScroll: UIScrollView)
}

public enum CollectionViewModeSection: Int {
    case single
    case multiple
}

open class CollectionViewManager: UICollectionView {
    
    deinit {
        managerDelegate = nil
        print(description)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
        if #available(iOS 10.0, *) {
            prefetchDataSource = self
        }
    }
    
    public var defaultEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    
    /// CollectionManagerDelegate protocol
    private weak var managerDelegate: CollectionManagerDelegate?
    @IBOutlet public weak var managerProtocol: AnyObject? {
        get { return managerDelegate }
        set { managerDelegate = newValue as? CollectionManagerDelegate }
    }
    
    /// MARK: Mode
    private var mode: CollectionViewModeSection = .single
    public func getCollectionViewMode() -> CollectionViewModeSection {
        return mode
    }
    
    /// MARK: Input data
    public var items = [AnyObject]() {
        willSet {
            self.items = newValue
            self.mode = .single
            registerAll(items: newValue, reload: true)
        }
    }
    
    public var setSectionsAndItems = [AnyObject]() {
        willSet { setSectionsAndItems(sequence: newValue) }
    }
    
    public private(set) var sections = [AnyObject]()
    private var sectionsAndItems = [AnyObject]()
    private func setSectionsAndItems(sequence: [AnyObject]) {
        guard hasSection(sequence: sequence) else {
            items = sequence
            return
        }
        
        registerAll(items: sequence, reload: false)

        var _items = [AnyObject]()
        var _newSections = [AnyObject]()
        var _cleanSecAndItems = [AnyObject]()
        var currentSection: SectionController?

        for (index, data) in sequence.enumerated() {
            
            if let item = data as? CellController { _items.append(item) }
            
            if let item = data as? SectionController {
                if currentSection != nil {
                    currentSection?.items = _items as [AnyObject]?
                    _cleanSecAndItems.append(contentsOf: _items)
                    _newSections.append(currentSection!)
                }
                
                _items.removeAll()
                _items = [AnyObject]()
                currentSection = item
                _cleanSecAndItems.append(currentSection!)
            }

            if index + 1 == sequence.count {
                if currentSection != nil {
                    currentSection?.items = _items as [AnyObject]?
                    _cleanSecAndItems.append(contentsOf: _items)
                    _newSections.append(currentSection!)
                }
                
                if let item = data as? SectionController {
                    _items.removeAll()
                    _items = [AnyObject]()
                    currentSection = item
                    _cleanSecAndItems.append(currentSection!)
                }
            }
        }
        
        sectionsAndItems.removeAll(keepingCapacity: false)
        sectionsAndItems = _cleanSecAndItems
        
        sections.removeAll(keepingCapacity: false)
        sections = _newSections
        
        mode = .multiple
    }
    
    //MARK: Register Xib
    private func registerAll(items:[AnyObject], reload: Bool) {
        for item in items {
            if let controller = item as? CellController, controller.isUsedNib == true {
                let nib = UINib(nibName: controller.reuseIdentifier(), bundle: nil)
                self.register(nib, forCellWithReuseIdentifier: controller.reuseIdentifier())
            }
        }
        
        if reload { reloadData() }
    }
    
    /// Validamos se o array contains objeto do tipo SectionController
    ///
    /// - Parameter sequence: lista de collectionView
    /// - Returns: returna se achou ou não a sessão
    private func hasSection(sequence: [AnyObject]) -> Bool {
        return sequence.contains(where: { $0 is SectionController })
    }
    
    /// Busca a cell controller e retorna o indexPath
    ///
    /// - Parameter cell: cell controller
    /// - Returns: return o indexPath
    private func searchCellControllerForMultipleMode(cell: CellController) -> IndexPath? {
        for (i, aSection) in sections.enumerated() {
            if let section = aSection as? SectionController, let rows = section.items {
                for (j, aCell) in rows.enumerated() {
                    if let aCell = aCell as? CellController {
                        if aCell == cell {
                            return IndexPath(row: j, section: i)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /// Busca a cell controller e retorna o indexPath
    ///
    /// - Parameter cell: cell controller
    /// - Returns: return o indexPath
    private func searchCellControllerForSingleMode(cell: CellController) -> IndexPath? {
        for (index, aCell) in items.enumerated() {
            if let aCell = aCell as? CellController {
                if(aCell == cell) {
                    return IndexPath(row: index, section: 0)
                }
            }
        }
        
        return nil
    }
    
    /// Retorna a cellController
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: return a cell controller
    public func findControllerAtIndexPath(indexPath: IndexPath) -> CellController? {
        var controller: CellController?
        if mode == .single {
            if items.count > indexPath.row {
                controller = items[indexPath.row] as? CellController
            }
        } else {
            if let section = sections[indexPath.section] as? SectionController, let rows = section.items {
                controller = rows[indexPath.row] as? CellController
            }
        }
        
        return controller
    }
    
    //MARK: Items manipulation
    
    /// Retorna o indexPath de uma cell controller
    ///
    /// - Parameter cell: cell controller
    /// - Returns: indexPath
    public func indexPathForCellController(cell: CellController) -> IndexPath? {
        return mode == .multiple ?
            searchCellControllerForMultipleMode(cell: cell) :
            searchCellControllerForSingleMode(cell: cell)
    }
    
    /// Remove as CollectionViewCell's a partir da posição determinada, X Cell's
    ///
    /// - Parameters:
    ///   - position: posição inicial
    ///   - count: quantidade de itens a serem removidos
    public func removeAt(position: Int, rowsCount count: Int) {

        var paths = [IndexPath]()
        var discardRows = [AnyObject]()
        
        let allRows = NSMutableArray(array: items)
        
        for (index, cellController) in items.enumerated() {
            if index >= position && index <= (position + count) {
                discardRows.append(cellController)
                let path: IndexPath = indexPathForCellController(cell: cellController as! CellController)!
                paths.append(path)
            }
        }
        
        allRows.removeObjects(in: discardRows)
        
        performBatchUpdates({
            self.items.removeAll()
            self.items = allRows as [AnyObject]
            self.deleteItems(at: paths)
        })
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching
@available(iOS 10.0, *)
extension CollectionViewManager: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return }
            controller.collectionView = collectionView
            controller.collectionView(collectionView, prefetchItem: indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        //TODO
    }
}


// MARK: - UICollectionViewDataSource Methods
extension CollectionViewManager: UICollectionViewDataSource {
    
    override open func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CellView
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mode == .single ? 1 : sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .single {
            return items.count
        } else {
            if sections.count == 0 { return 0 }
            if let controller = sections[section] as? SectionController { return controller.items!.count }
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return UICollectionViewCell() }
        controller.collectionView = collectionView
        return controller.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return }
        guard let delegate = self.managerDelegate else { return }
        
        if delegate.responds(to: #selector(CollectionManagerDelegate.collectionManager(collectionView:didSelectItem:))) {
            delegate.collectionManager!(collectionView:self, didSelectItem: controller)
        }
        
        if delegate.responds(to: #selector(CollectionManagerDelegate.collectionManager(collectionView:didSelectIndexPath:))) {
            delegate.collectionManager!(collectionView:self, didSelectIndexPath: indexPath)
        }
        
        return controller.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return }
        controller.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension CollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return CGSize(width: 100, height: 100) }
        controller.collectionView = collectionView
        return controller.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if sections.count == 0 { return defaultEdgeInsets
        } else if let sectionController = sections[section] as? SectionController { return sectionController.edgeInsets
        } else { return defaultEdgeInsets }
    }
}

// MARK: - UIScrollViewDelegate Methods
extension CollectionViewManager: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.managerDelegate else { return }
        if delegate.responds(to: #selector(CollectionManagerDelegate.collectionManager(collectionView:scrollView:))) {
            delegate.collectionManager!(collectionView: self, scrollView: scrollView)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = self.managerDelegate else { return }
        if delegate.responds(to: #selector(CollectionManagerDelegate.collectionManager(collectionView:didEndScroll:))) {
            delegate.collectionManager!(collectionView:self, didEndScroll: scrollView)
        }
    }
    
}

//MARK: CellController
@objc(CellController)
open class CellController: NSObject {
    
    @IBOutlet public weak var controllerCell: CellView!
    
    fileprivate var collectionView: UICollectionView?
    fileprivate var tag: Int?
    fileprivate var identifier: String?
    fileprivate var currentObject: AnyObject?
    fileprivate var isUsedNib = false
    
    deinit {
        collectionView = nil
        controllerCell = nil
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(nib: Bool) {
        self.init()
        isUsedNib = nib
    }
    
    open func reloadMe() {
        if let index: IndexPath = (collectionView as! CollectionViewManager).indexPathForCellController(cell: self) {
            collectionView?.performBatchUpdates({ self.collectionView?.reloadItems(at: [index]) }, completion: nil)
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return loadDefaultCellForCollection(collectionView: collectionView, atIndexPath: indexPath) as! CellView
    }
    
    open func loadDefaultCellForCollection(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> AnyObject {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier(), for: indexPath) as? CellView
        
        if cell == nil {
            let _ = CollectionViewManagerCache.shared().loadNib(path: reuseIdentifier(), owner: self)
            cell = controllerCell;
            controllerCell = nil
        }
        
        cell!.controller = self
        
        return cell!
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    open func collectionView(_ collectionView: UICollectionView, prefetchItem indexPath:IndexPath) {}
    
    fileprivate func reuseIdentifier() -> String { return NSStringFromClass(object_getClass(self)!) }
}

//MARK: CellView
open class CellView: UICollectionViewCell {
    
    fileprivate var loadedKey: String?
    
    @IBOutlet public weak var controller: CellController!
    
    deinit {
        controller = nil
        loadedKey = nil
    }
}

//MARK: SectionController
open class SectionController: NSObject {
    
    var items: [AnyObject]?
    var edgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    
    public convenience init(insets: UIEdgeInsets) {
        self.init()
        edgeInsets = insets
    }
    
    deinit{ items = nil }
}
