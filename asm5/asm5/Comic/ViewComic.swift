import UIKit

final class ViewComic: UIViewController {

    private static let EDIT_SEGUE = "editComic"
    private static let DELETE_SEGUE = "deleteComic"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    private var selectedComic: Comic? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBtn.layer.cornerRadius = 10
        updateBtn.clipsToBounds = true

        deleteBtn.layer.cornerRadius = 10
        deleteBtn.clipsToBounds = true

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == ViewComic.EDIT_SEGUE) {
            let editComic = segue.destination as? EditComic
            if let comic = self.selectedComic {
                editComic!.updateSelectedComic(comic: comic)
            } else {
                print("U got some problem here")
            }
        } else if (segue.identifier == ViewComic.DELETE_SEGUE) {
            let deleteComic = segue.destination as? DeleteComic
            if let comic = self.selectedComic {
                deleteComic!.updateSelectedComic(comic: comic)
            } else {
                print("U got some problem here")
            }
        }
    }

    public func updateSelectedComic(comic: Comic) {
        self.selectedComic = comic
    }
}
