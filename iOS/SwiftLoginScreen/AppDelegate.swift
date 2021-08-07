//
//  AppDelegate.swift
//  SwiftLoginScreen
//
//  Copyright (c) 2015 Gaspar Gyorgy. MIT
//

import Contacts
import CoreData
import CoreLocation
import Realm
import UIKit

var expiryDate: Date?
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var contactStore: CNContactStore?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        setenv("CFNETWORK_DIAGNOSTICS", "3", 1);
        return true;
    }
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // URL classes available
        // add from git if needed; discontinued
        URLProtocol.registerClass(MyURLProtocol.self)
        //URLProtocol.registerClass(MyURLProtocolSession.self)

        // Nav, Tool bar appearance tweaks
        UINavigationBar.appearance().barStyle = .blackTranslucent
        UINavigationBar.appearance().barTintColor = UIColor.darkGray
        UINavigationBar.appearance().backgroundColor = UIColor.darkGray

        UIToolbar.appearance().barStyle = .blackTranslucent
        UITabBar.appearance().barStyle = .black
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().tintColor = UIColor.white

        UIBarButtonItem.appearance().tintColor = UIColor.white
        UIButton.appearance().tintColor = UIColor.white

        // Apple Maps
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.allowsBackgroundLocationUpdates = true

        contactStore = CNContactStore()
        contactStore!.requestAccess(for: .contacts) { succeeded, err in
            guard err == nil, succeeded else {
                return
            }
        }

        checkRealm()

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         print("dB location: \(urls[urls.count-1] as URL)")

        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func checkRealm() {

            let p: NSPredicate = NSPredicate(format: "url == %@", argumentArray: ["https://"+serverURL+"/mbooks-1/rest/book/movies/paging"])

            // Query
        if let results = CachedResponse.objects(with: p) as AnyObject? {
            
            if results.count > 0 {

                for _ in 0 ..< results.count {
                    
                    let data = results.object(at: 0) as? CachedResponse
                    if ((data?.timestamp.addingTimeInterval(3600))! < Date()) {
                        
                        let realm = RLMRealm.default()
                        realm.beginWriteTransaction()
                        realm.delete(results.object(at: 0) as! RLMObject)

                        do {
                            try realm.commitWriteTransaction()
                            
                        } catch {
                            print("Something went wrong!")
                        }
                        
                    }
                }
            }
        }
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "org.CoreData" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CoreDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator

        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator

        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    func application(_: UIApplication, open _: URL, sourceApplication _: String?, annotation _: Any) -> Bool {
        return false
    }

    func applicationDidReceiveMemoryWarning(_: UIApplication) {}
}
