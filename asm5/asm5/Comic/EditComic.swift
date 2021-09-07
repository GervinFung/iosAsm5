import UIKit
import CoreData

final class EditComic : UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var authorTF: UITextField!
    @IBOutlet weak var datePublished: UIDatePicker!
    @IBOutlet weak var summaryTF: UITextView!
    
    private var selectedComic: Comic? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTF.delegate = self
        authorTF.delegate = self
        summaryTF.delegate = self
        
        if let comic = self.selectedComic {
            titleTF.text = comic.title
            authorTF.text = comic.author
            summaryTF.text = comic.summary
            let date: Date = comic.date! as! Date
            self.datePublished.setDate(date, animated:true)

        } else {
            print("No Comic? Something is wrong, only through segue can reach here")
        }
    }
    
    @IBAction func saveEdit(_ sender: Any) {
        
        let author: String = authorTF.text!
        let title: String = titleTF.text!
        let summary = summaryTF.text!
        
        if (author.count != 0 && title.count != 0 && summary.count != 0) {
            
            let context = ComicUtil.getContext()
            let request = ComicUtil.getFetch()
            
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                
                let comic = results.first(where: {($0 as! Comic).id == self.selectedComic?.id}) as! Comic
                
                comic.author = authorTF.text
                comic.title = titleTF.text
                comic.date = datePublished.date as NSDate
                comic.summary = summaryTF.text
                try context.save()
                navigationController?.popToRootViewController(animated: true)
                
            } catch {
                print("Fetch Failed")
            }
            
        } else {
            
            let alertController = UIAlertController(title: "Warning", message: "No empty fields are allowed", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    public func updateSelectedComic(comic: Comic) {
        self.selectedComic = comic
    }
}

extension EditComic: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditComic: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
