import XCTest
import CollectionManager

class Tests: XCTestCase {
    
    var systemUnderTest: TestViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "TestViewController") as!
        TestViewController
        _ = systemUnderTest.view
    }
    
    override func tearDown() {
        super.tearDown()
        systemUnderTest = nil
    }
    
    func testCanInstantiateViewController() {
        XCTAssertNotNil(systemUnderTest)
    }
    
    func testCollectionViewManagerNotNill() {
        XCTAssertNotNil(systemUnderTest.collectionView)
    }
    
    func testShouldSetCollectionViewDataSource() {
        XCTAssertNotNil(systemUnderTest.collectionView.dataSource)
    }
    
    func testShouldSetCollectionViewDelegate() {
        XCTAssertNotNil(systemUnderTest.collectionView.delegate)
    }
    
    func testShouldSetCollectionViewManagerProtocol() {
        XCTAssertNotNil(systemUnderTest.collectionView.managerProtocol)
    }
    
    func testCollectionViewManagerMode() {
        let collection = systemUnderTest.collectionView!
        XCTAssertEqual(collection.getCollectionViewMode(), CollectionViewModeSection.single)
    }
    
    func testCollectionViewManagerDefaultEdgeInsets() {
        let collection = systemUnderTest.collectionView!
        XCTAssertEqual(collection.defaultEdgeInsets, UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    func testCustomCollectionViewManagerDefaultEdgeInsets() {
        let collection = systemUnderTest.collectionView!
        collection.defaultEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        XCTAssertEqual(collection.defaultEdgeInsets, UIEdgeInsetsMake(10, 10, 10, 10))
    }
    
    func testCollectionViewManagerItemsCount() {
        let collection = systemUnderTest.collectionView!
        let items = [CellController(nib: true), CellController(), CellController()]
        collection.items = items
        XCTAssertEqual(collection.items.count, items.count)
    }
    
    func testCollectionViewManagerModeMultiple() {
        let collection = systemUnderTest.collectionView!
        let items = [SectionController(), CellController(nib: true), CellController()]
        collection.setSectionsAndItems = items
        XCTAssertEqual(collection.getCollectionViewMode(), CollectionViewModeSection.multiple)
    }
    
    func testSetSectionAndItemsWithoutSection() {
        let collection = systemUnderTest.collectionView!
        let items = [CellController(), CellController()]
        collection.setSectionsAndItems = items
        XCTAssertEqual(collection.getCollectionViewMode(), CollectionViewModeSection.single)
    }
    
    func testCollectionViewManagerSectionCount() {
        let collection = systemUnderTest.collectionView!
        let items = [SectionController(), CellController(), SectionController(insets: UIEdgeInsetsMake(10, 10, 10, 10))]
        collection.setSectionsAndItems = items
        XCTAssertEqual(collection.sections.count, 2)
    }
    
    func testIndexPathForCellControllerSimpleMode() {
        let collection = systemUnderTest.collectionView!
        let items = [CellController(), CellController(), CellController()]
        collection.items = items
        let indexPath = collection.indexPathForCellController(cell: items[1])
        XCTAssertEqual(indexPath, IndexPath(item: 1, section: 0))
    }
    
    func testIndexPathForCellControllerMultipleMode() {
        let collection = systemUnderTest.collectionView!
        let cell = CellController()
        let items = [SectionController(), CellController(nib: true), SectionController(), cell, CellController()]
        collection.setSectionsAndItems = items
        let indexPath = collection.indexPathForCellController(cell: cell)
        XCTAssertEqual(indexPath, IndexPath(item: 0, section: 1))
    }
    
    func testIndexPathForNilCellControllerSimpleMode() {
        let collection = systemUnderTest.collectionView!
        let items = [CellController(), CellController(), CellController()]
        collection.items = items
        let indexPath = collection.indexPathForCellController(cell: CellController())
        XCTAssertNil(indexPath)
    }
    
    func testIndexPathForNilCellControllerMultipleMode() {
        let collection = systemUnderTest.collectionView!
        let items = [SectionController(), CellController(), SectionController(), CellController(), CellController()]
        collection.setSectionsAndItems = items
        let indexPath = collection.indexPathForCellController(cell: CellController())
        XCTAssertNil(indexPath)
    }
    
    func testFindControllerAtIndexPathForSimpleMode() {
        let cell = CellController()
        let index = IndexPath(item: 1, section: 0)
        let collection = systemUnderTest.collectionView!
        let items = [CellController(), cell, CellController()]
        collection.items = items
        let findCell = collection.findControllerAtIndexPath(indexPath: index)
        XCTAssertEqual(cell, findCell)
    }
    
    func testFindControllerAtIndexPathForMultipleMode() {
        let cell = CellController()
        let index = IndexPath(item: 0, section: 1)
        let collection = systemUnderTest.collectionView!
        let items = [SectionController(), CellController(), SectionController(), cell, CellController()]
        collection.setSectionsAndItems = items
        let findCell = collection.findControllerAtIndexPath(indexPath: index)
        XCTAssertEqual(cell, findCell)
    }
    
    func testRemoveAtPositionWithRowsCount() {
        let collection = systemUnderTest.collectionView!
        let items = [CustomXibCell(nib: true), CustomXibCell(nib: true), CustomTestCell(), CustomTestCell()]
        collection.items = items
        collection.removeAt(position: 1, rowsCount: 1)
        XCTAssertEqual(collection.items.count, 2)
    }
    
    func testCollectionViewManagerCache() {
        let cacheCell = CollectionViewManagerCache.shared().loadNib(path: "CustomXibCell", owner: self)
        XCTAssertNotNil(cacheCell)
    }
    
}
