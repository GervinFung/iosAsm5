import UIKit
import CoreData

final class DeleteComic : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    private var selectedComic: Comic? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryLabel.numberOfLines = 0
        
        if let comic = self.selectedComic {
            titleLabel.text = comic.title
            authorLabel.text = comic.author
            summaryLabel.text = comic.summary
            let date: Date = comic.date! as! Date
            dateLabel.text = DateUtil.getSingletonInstance().formStringFromDate(date: date)
        } else {
            print("No Comic? Something is wrong, only through segue can reach here")
        }
    }
    
    private func delete() {
        let context = ComicUtil.getContext()
        let request = ComicUtil.getFetch()
        
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            
            let comic = results.first(where: {($0 as! Comic).id == self.selectedComic?.id}) as! Comic
            
            context.delete(comic)
            ComicTableView.setComics(comics: results.filter({($0 as! Comic).id != self.selectedComic?.id}) as! Array<Comic>)
            
            try context.save()
            navigationController?.popToRootViewController(animated: true)
            
        } catch {
            print("Fetch Failed")
        }
    }
    
    @IBAction func deleteComic(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete. This cannot be undone", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.delete()
        }
        alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:nil)
    }

    public func updateSelectedComic(comic: Comic) {
        self.selectedComic = comic
    }
}
