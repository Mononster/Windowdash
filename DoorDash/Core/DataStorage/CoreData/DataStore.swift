//
//  DataStore.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import CoreData

public protocol DataStoreType {
    var mainContext: NSManagedObjectContext { get }
    var newBackgroundContext: NSManagedObjectContext { get }
    func loadStore(completionClosure: @escaping () -> Void)
    func performBackgroundTask(_ block: @escaping (_ context: NSManagedObjectContext) -> Void)
    func saveMainContext(completion: @escaping (Bool) -> ())
    func destroyAndRecreateDataStore()
    func destroyDataStore()
}

// MARK: - Core Data stack
public final class DataStore: DataStoreType {

    public var mainContext: NSManagedObjectContext {
        do {
            try persistentContainer.viewContext.setQueryGenerationFrom(.current)
        } catch {
            #if DEBUG
                print("Cannot use query generation")
            #endif
        }
        return persistentContainer.viewContext
    }

    public var newBackgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    // MARK: - Private
    private var currentRetry = 0
    private static var maxRetry = 2

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UWLife", managedObjectModel: CoreModelVersion.current.managedObjectModel())

        let description = NSPersistentStoreDescription(url: self.storeURL)
        description.shouldMigrateStoreAutomatically = false
        container.persistentStoreDescriptions = [description]
        return container
    }()

    private var storeURL: URL {
        guard let rootDirectory = FileManager.default.createUserDirectory(searchPath: .applicationSupportDirectory) else {
            fatalError("Cannot find directory for data store")
        }

        let storeURL = URL(fileURLWithPath: rootDirectory).appendingPathComponent("UWLife.sqlite")
        return storeURL
    }

    public init(completionClosure: @escaping () -> Void) {
        loadStore(completionClosure: completionClosure)
    }

    public init() {}

    public func performBackgroundTask(_ block: @escaping (_ context: NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
        }
    }

    // MARK: - Core Data Saving support
    public func saveMainContext(completion: @escaping (Bool) -> ()) {
        if self.mainContext.hasChanges {
            do {
                try self.mainContext.save()
                completion(true)
            } catch {
                completion(false)
                #if DEBUG
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                #endif

            }
        }
        completion(true)
    }

    public func destroyAndRecreateDataStore() {
        destroyDataStore()
        loadStore {}
    }

    public func destroyDataStore() {
        do {
            let psc = persistentContainer.persistentStoreCoordinator
            try psc.destroyPersistentStore(at: self.storeURL, ofType: NSSQLiteStoreType, options: nil)
        } catch {
            print("Unable to destory store, removing file instead")
            try? FileManager.default.removeItem(at: storeURL)
        }
    }

    public func loadStore(completionClosure: @escaping () -> Void) {
        guard currentRetry < DataStore.maxRetry else {
            fatalError("Unable to recreate data store due to unknown reason.")
        }
        persistentContainer.loadPersistentStores { [unowned self] _, error in
            if error == nil {
                self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
                DispatchQueue.main.async(execute: completionClosure)
            } else {
                self.currentRetry += 1
                let model = CoreModelVersion.current.managedObjectModel()
                let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
                do {
                    try psc.destroyPersistentStore(at: self.storeURL, ofType: NSSQLiteStoreType, options: nil)
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.loadStore(completionClosure: completionClosure)
                    }
                } catch {
                    fatalError("Unable to destory and recover store")
                }
            }
        }
    }
}

