import XCTest
import RealmSwift
import Savior

class Tests: XCTestCase {
    
    private let stressCount = 10000
    
    override class func setUp() {
        
        super.setUp()
        
        try! Savior.useProvider(Realm.self, encryptionKey: nil, enableMigrations: true)
    }
        
    override func setUp() {
        super.setUp()
        
        do { try Savior.clear() } catch { print("An error occurred: \(error)") }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCrudOperations() {
    
        do {
            
            let preCount = try Pet.query().count
            
            let petId: Int64 = 12345
            let ownerId: Int64 = 67890
            
            // Add Pet
            let json: [String : Any] = ["id" : petId, "name" : "Lily Wily Bily Bear", "ownerId" : ownerId]
            let pet = try Pet.from(json: json)
            try pet.save()
            
            // Query all Pets
            let pets = try Pet.query()
            let postCount = pets.count
            print("There are \(postCount) pets - \(pets.map { $0.name })")
        
            if preCount == 0 { XCTAssertEqual(postCount, 1) }
            else { XCTAssertEqual(preCount, postCount) }
            
            // Find Pet by Id
            let foundPet = try Pet.find(byId: petId)
            let unfoundPet = try Pet.find(byId: 000000)
            XCTAssertNotNil(foundPet)
            print("Found pet with id \(petId) named \(foundPet!.name)")
            XCTAssertNil(unfoundPet)
            XCTAssertEqual(foundPet?.name, pet.name)
            
            if try foundPet?.owner() == nil { print("\(foundPet!.name) doesn't have an owner yet :(") }
            
            // Add owner
            let owner = Person(name: "Ephraim", id: ownerId)
            try owner.save()
    
            XCTAssertEqual(owner.name, try foundPet?.owner()?.name)
            
            print("\(foundPet!.name)'s new owner is \(owner.name)!")
            
            let newOwner = Person(name: "Tianchun", id: ownerId)
            try newOwner.save()
        
            XCTAssertEqual(newOwner.name, try foundPet?.owner()?.name)
            XCTAssertEqual(try Person.count(), 1)
            
            try newOwner.delete()
            XCTAssertEqual(try Person.count(), 0)
            
            try Pet.deleteAll()
            XCTAssertEqual(try Pet.count(), 0)
            
            let array: [Pet] = [Pet(name: "Billy"), Pet(name: "Bobby")]
            try array.save()
            XCTAssertEqual(try Pet.count(), array.count)
            try array.delete()
            XCTAssertEqual(try Pet.count(), 0)

        } catch { print("An error occurred: \(error)") }
    }
    
    func testStorageObserver() {
    
        let initialExpection = XCTestExpectation()
        let updatedExpection = XCTestExpectation()
        
        let observer = StorageObserver()
        observer.intialCollectionHander = { [weak observer] items, predicate in
            
            print(items, predicate ?? "")
            
            XCTAssertTrue(observer?.pets.isEmpty ?? false)
            
            observer?.updateUI()
            
            initialExpection.fulfill()
        }
        
        observer.updatedCollectionHander = { [weak observer] items, predicate, deleted, inserted, modified in
            
            print(items, predicate ?? "", deleted, inserted, modified)
            
            XCTAssertEqual(items.count, observer?.pets.count ?? 0)
            
            observer?.updateUI()

            updatedExpection.fulfill()
        }
        
        observer.setup()
        print("Finished set up")
        
        let pug = Pet(name: "Mr. Pug")
        let frenchie = Pet(name: "Lily Wily")
        
        do { try [pug, frenchie].save() } catch { print("An error occurred: \(error)") }
        
        do { try pug.delete() } catch { print("An error occurred: \(error)") }

        wait(for: [initialExpection, updatedExpection], timeout: 5)
    }
    /*
    func testManagedSyncWrite() {

        self.measure() {
            // Put the code you want to measure the time of here.
            
            do { try Savior.clear() } catch { print("An error occurred: \(error)") }
            
            for i in 0..<stressCount {
                
                let pet = Pet(name: "Pet \(i)")
                
                try! pet.save()
            }
            
            let result = try! Pet.query()
            
            XCTAssertEqual(result.count, stressCount)
        }
    }
    
    func testManagedTotalWrite() {
        
        self.measure() {
            // Put the code you want to measure the time of here.
            
            do { try Savior.clear() } catch { print("An error occurred: \(error)") }
            
            var pets: [Pet] = []
            
            for i in 0..<stressCount {
                
                let pet = Pet(name: "Pet \(i)")
                pets.append(pet)
            }
            
            try! pets.save()
            
            let result = try! Pet.query()
            
            XCTAssertEqual(result.count, stressCount)
        }
    }
    
    func testDirectSyncWrite() {

        self.measure() {
            // Put the code you want to measure the time of here.

            do { try Savior.clear() } catch { print("An error occurred: \(error)") }

            for i in 0..<stressCount {

                let pet = ManagedPet(name: "Pet \(i)", identifier: String(Int64.random(in: 0..<Int64.max-1)), ownerId: nil)

                try! pet.save()
            }
            
            let result = try! ManagedPet.query()
            
            XCTAssertEqual(result.count, stressCount)
        }
    }
    
    func testDirectTotalWrite() {
        
        self.measure() {
            // Put the code you want to measure the time of here.
            
            do { try Savior.clear() } catch { print("An error occurred: \(error)") }
            
            var pets: [ManagedPet] = []
            
            for i in 0..<stressCount {
                
                let pet = ManagedPet(name: "Pet \(i)", identifier: String(Int64.random(in: 0..<Int64.max-1)), ownerId: nil)
                pets.append(pet)
            }
            
            try! pets.save()
            
            let result = try! ManagedPet.query()
            
            XCTAssertEqual(result.count, stressCount)
        }
    }
 */
}

class StorageObserver: NSObject, StorageObserving {
    
    var storageObservingToken: StorageObservingToken!
    
    var intialCollectionHander: ((_ items: [Any], _ predicate: String?)-> Void)?
    
    var updatedCollectionHander: ((_ items: [Any], _ predicate: String?, _ deleted: [Int], _ inserted: [Int], _ modified: [Int])-> Void)?

    var pets: [Pet] = []
    
    func setup() {
        
        print(#function)
        
        do { self.pets = try Pet.query("name BEGINSWITH 'M'", observer: self, keyPath: \StorageObserver.pets) } catch { print("An error occurred: \(error)") }
    }
    
    func updateUI() {
        
        print(#function)
    }
    
    func didObserveInitialCollection<T: Storable>(items: [T], predicate: String?, keyPath: AnyKeyPath) {
        
        print(#function)
        
        // if keyPath == \StorageObserver.pets { }
        
        self.intialCollectionHander?(items, predicate)
    }
    
    func didObserveUpdatedCollection<T: Storable>(items: [T], predicate: String?, deleted: [Int], inserted: [Int], modified: [Int], keyPath: AnyKeyPath) {
        
        print(#function)
        
        self.updatedCollectionHander?(items, predicate, deleted, inserted, modified)
    }
    
    deinit {
        
        storageObservingToken.invalidate()
    }
}
