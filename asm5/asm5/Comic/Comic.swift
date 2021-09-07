import CoreData
import UIKit

@objc(Comic)
final class Comic: NSManagedObject {
    
    @NSManaged var id: String!
    @NSManaged var author: String!
    @NSManaged var title: String!
    @NSManaged var summary: String!
    @NSManaged var date: NSDate!
    
}

final class ComicUtil {
    
    public static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    public static func getFetch() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "Comic")
    }
}
