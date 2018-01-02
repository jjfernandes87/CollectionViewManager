//
//  CollectionViewManagerCache.swift
//  CollectionManager
//
//  Created by Julio Fernandes on 24/12/17.
//

import UIKit

open class CollectionViewManagerCache: NSObject {
    
    private var items = NSMutableDictionary()
    
    static var instance: CollectionViewManagerCache!
    
    deinit { NSLog("Dealloc CollectionViewManagerCache") }
    
    public class func shared() -> CollectionViewManagerCache {
        self.instance = (self.instance ?? CollectionViewManagerCache())
        return self.instance
    }
    
    override init() {
        super.init()
        let selector = #selector(clearCache)
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    public func loadNib(path: String?, owner: AnyObject) -> Any? {
        guard let pathItem = path else {
            return nil
        }
        
        var cached: UINib?
        objc_sync_enter(items)
        cached = items.object(forKey: pathItem) as? UINib
        objc_sync_exit(items)
        
        if let cachedNib = cached {
            return cachedNib.instantiate(withOwner: owner, options: [:])
        } else {
            let newNib = UINib(nibName: pathItem, bundle: nil)
            objc_sync_enter(items)
            items.setValue(newNib, forKey: pathItem)
            objc_sync_exit(items)
            
            return newNib.instantiate(withOwner: owner, options: [:])
        }
    }
    
    @objc func clearCache() {
        items.removeAllObjects()
    }
}


