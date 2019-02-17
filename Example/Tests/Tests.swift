import XCTest
import RealmSwift
import Savior

class Tests: XCTestCase {
    
    private let stressCount = 10000
    
    override class func setUp() {
        
        super.setUp()
        
        Savior.shared.use(provider: Realm.self, encryptionKey: nil, enableMigrations: false)
    }
        
    override func setUp() {
        
        super.setUp()
        Savior.shared.clear(provider: Realm.self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAdd() {
        
        var preCount = 0
        
        let total = 20
        let range = 0..<total
        for i in range {
            
            // Add Pet
            let pet = Pet(name: "Pet \(i)", id: "\(i)", ownerId: nil)
            pet.save()
            
            XCTAssertEqual(Pet.count(), preCount+1)
            
            preCount += 1
        }
        
        XCTAssertEqual(Pet.all().count, total)
        
        XCTAssertEqual(Pet.identifiers().map { Int($0)! }.sorted(), Array(range))
        
        let idArr = ["3","7","4","9"]
        let idPets = Pet.find(byIds: idArr)
                
        XCTAssertEqual(idPets.map { $0.name }.sorted(), idArr.map { "Pet \($0)" }.sorted())
    }
    
    func testCrudOperations() {
    
        let preCount = Pet.query().count

        XCTAssertEqual(preCount, 0)

        let petId  = "12345"
        let ownerId = "67890"
        
        // Add Pet
        let pet = Pet(name: "Lily Wily Bily Bear", id: petId, ownerId: ownerId)
        pet.save()
        
        XCTAssertEqual(preCount+1, Pet.count())

        // Query all Pets
        let pets = Pet.query()
        let postCount = pets.count
        print("There are \(postCount) pets - \(pets)")

        if preCount == 0 { XCTAssertEqual(postCount, 1) }
        else { XCTAssertEqual(preCount, postCount) }

        // Find Pet by Id
        let foundPet = Pet.find(byId: petId)
        let unfoundPet = Pet.find(byId: "000000")
        XCTAssertNotNil(foundPet)
        print("Found pet with id \(petId) named \(foundPet!.name)")
        XCTAssertNil(unfoundPet)
        XCTAssertEqual(foundPet?.name, pet.name)

        if foundPet?.owner() == nil { print("\(foundPet!.name) doesn't have an owner yet :(") }

        // Add owner
        let owner = Person(name: "Ephraim", id: ownerId)
        owner.save()

        XCTAssertEqual(owner.name, foundPet?.owner()?.name)

        print("\(foundPet!.name)'s new owner is \(owner.name)!")

        let newOwner = Person(name: "Tianchun", id: ownerId)
        newOwner.save()

        XCTAssertEqual(newOwner.name, foundPet?.owner()?.name)
        XCTAssertEqual(Person.count(), 1)

        newOwner.delete()
        XCTAssertEqual(Person.count(), 0)

        Pet.deleteAll()
        XCTAssertEqual(Pet.count(), 0)

        let array: [Pet] = [Pet(name: "Billy", id: "gwehwergreg"), Pet(name: "Bobby", id: "wegerh45ergh5ergf")]
        array.save()
        XCTAssertEqual(Pet.count(), array.count)
        array.delete()
        XCTAssertEqual(Pet.count(), 0)
    }

    func testStorageObserver() {
    
        let initialExpection = XCTestExpectation()
        let savedExpection = XCTestExpectation()
        let deletedExpection = XCTestExpectation()
        let modifiedExpection = XCTestExpectation()

        let observer = StorageObserver()
        observer.intialCollectionHander = { [weak observer] items, predicate in
            
            print(items, predicate ?? "")
            
            XCTAssertTrue(items.isEmpty)
            
            XCTAssertTrue(observer?.pets.isEmpty ?? false)
            
            observer?.updateUI()
            
            initialExpection.fulfill()
        }
        
        observer.updatedCollectionHander = { [weak observer] items, predicate, deleted, inserted, modified in
            
            print(items, predicate ?? "", deleted, inserted, modified)
            
            XCTAssertEqual(items.count, observer?.pets.count ?? 0)
            
            observer?.updateUI()
            
            if !inserted.isEmpty { savedExpection.fulfill() }
            
            else if !deleted.isEmpty { deletedExpection.fulfill() }
            
            else if !modified.isEmpty { modifiedExpection.fulfill() }
        }
        
        observer.pets = Pet.query(observer: observer, keyPath: \StorageObserver.pets)
        
        print("Finished set up")
        
        let pug = Pet(name: "Mr. Pug", id: "wfweg4egqwagergqwf")
        let frenchie = Pet(name: "Lily Wily", id: "rhrewegwrth56rhtgwef")
        
        [pug, frenchie].save()
        pug.ownerId = "12345"
        pug.save()
        pug.delete()

        wait(for: [initialExpection, savedExpection, deletedExpection, modifiedExpection], timeout: 500)
    }
    
    func testJoinQuery() {
        
        let ephraim = Person(name: "Ephraim", id: "1")
        let chloe = Person(name: "Chloe", id: "2")
        
        let lilly = Pet(name: "Lilly", id: "1", ownerId: "2")
        let pug = Pet(name: "Mr. Pug", id: "2", ownerId: "1")
        
        [ephraim, chloe].save()
        [lilly, pug].save()
        
        XCTAssertEqual(Person.count(), 2)
        XCTAssertEqual(Pet.count(), 2)
        
        let pets = Pet.query(nil, joining: Person.self, foreignKey: "ownerId", joinedPredicateFormat: "name BEGINSWITH 'E'")
        XCTAssertEqual(pets.first!.name, pug.name)
    }
    
    func testValueQuery() {
        
        let pets: [Pet] = Array(0..<100).map { Pet(name: "Pet_\($0)", id: String($0), ownerId: nil) }
        
        pets.save()
        
        let values = Pet.values(filteredBy: nil, keyPath: "name", type: String.self)
        print(values)
        XCTAssertEqual(values.count, pets.count)
    }
    
    func testThreading() {
                
        let expectation = XCTestExpectation()
    
        DispatchQueue.global(qos: .utility).async {
            
            let pets: [Pet] = Array(0..<100).map { Pet(name: "Pet_\($0)", id: String($0), ownerId: nil) }

            pets.save()
            
            let values = Pet.values(filteredBy: nil, keyPath: "name", type: String.self)
            print(values)
            XCTAssertEqual(values.count, pets.count)
            Pet.deleteAll()
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                //print(Pet.query())
                let values0 = Pet.query()
                let count0 = Pet.count()
                XCTAssertEqual(values0.count, count0)
                XCTAssertEqual(count0, 0)
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5000)
    }
    
    /*
    func testJoinQueryWithObserver() {
        
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
            
            XCTAssertEqual((items as! [Pet]), observer!.pets)
            
            observer?.updateUI()
            
            updatedExpection.fulfill()
        }
        
        observer.pets = try! Pet.query(nil, joining: Person.self, foreignKey: "ownerId", joinedPredicateFormat: "name BEGINSWITH 'E'", observer: observer, keyPath: \StorageObserver.pets)
        
        XCTAssertTrue(observer.pets.isEmpty)
        
        let owners = [Person(name: "Eric", id: 1), Person(name: "Erlich", id: 2), Person(name: "Johnny", id: 3), Person(name: "Bobby", id: 4)]
        try! owners.save()
        
        let pets = [Pet(name: "Kitty", id: 1, ownerId: 1), Pet(name: "Lucky", id: 2, ownerId: 1), Pet(name: "Roket", id: 3, ownerId: 4)]
        try! pets.save()
    
        wait(for: [initialExpection, updatedExpection], timeout: 5)

    }
     */
    
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
    
    var intialCollectionHander: ((_ items: [Any], _ predicate: NSPredicate?)-> Void)?
    
    var updatedCollectionHander: ((_ items: [Any], _ predicate: NSPredicate?, _ deleted: [Int], _ inserted: [Int], _ modified: [Int])-> Void)?

    var pets: [Pet] = []
    
    func updateUI() {
        
        print(#function)
    }
    
    func didObserveInitialCollection<T: Storable>(items: [T], predicate: NSPredicate?, keyPath: AnyKeyPath) {
        
        print(#function)
        
        // if keyPath == \StorageObserver.pets { }
        
        self.intialCollectionHander?(items, predicate)
    }
    
    func didObserveUpdatedCollection<T: Storable>(items: [T], predicate: NSPredicate?, deleted: [Int], inserted: [Int], modified: [Int], keyPath: AnyKeyPath) {
        
        print(#function)
        
        self.updatedCollectionHander?(items, predicate, deleted, inserted, modified)
    }
    
    deinit {
        
        storageObservingToken.invalidate()
    }
}
