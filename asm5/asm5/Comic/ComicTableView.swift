import UIKit
import CoreData

final class ComicTableView : UITableViewController {
    
    private var notLoaded = true
    
    private static let IDENTIFIER = "comicCellID"
    private static let VIEW_SEGUE = "viewComic"
    
    private static var comicList = [Comic]()
    
    override func viewDidLoad() {
        if (notLoaded) {
            notLoaded = false

            let context = ComicUtil.getContext()
            let request = ComicUtil.getFetch()
            
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                ComicTableView.comicList = results.map{ $0 as! Comic }
            } catch {
                print("Fetch Failed")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comicCell = tableView.dequeueReusableCell(withIdentifier: ComicTableView.IDENTIFIER, for: indexPath) as! ComicCell
        let thisComic: Comic! = ComicTableView.comicList[indexPath.row]
        
        comicCell.authorLabel.text = thisComic.author
        let date: Date = thisComic.date! as Date
        comicCell.dateLabel.text = DateUtil.getSingletonInstance().formStringFromDate(date: date)
        comicCell.titleLabel.text = thisComic.title
        
        return comicCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComicTableView.comicList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ComicTableView.VIEW_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == ComicTableView.VIEW_SEGUE) {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let viewComic = segue.destination as? ViewComic
            
            let selectedComic: Comic! = ComicTableView.comicList[indexPath.row]
            viewComic!.updateSelectedComic(comic: selectedComic)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }
    
    public static func addComic(comic: Comic) {
        ComicTableView.comicList.append(comic)
    }
    
    public static func setComics(comics: Array<Comic>) {
        ComicTableView.comicList = comics
    }
    
    
}

final class DateUtil {
    
    private static let dateUtil = DateUtil()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
    }
    
    public func formStringFromDate(date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    public func formDateFromString(string: String) -> Date {
        return self.dateFormatter.date(from: string)!
    }
    
    public static func getSingletonInstance() -> DateUtil {
        return DateUtil.dateUtil
    }
}
