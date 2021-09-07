import UIKit
import CoreData

final class ComicDetailVC: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var authorTF: UITextField!
    @IBOutlet weak var datePublished: UIDatePicker!
    @IBOutlet weak var summaryTF: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTF.delegate = self
        authorTF.delegate = self
        summaryTF.delegate = self
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        let author: String = authorTF.text!
        let title: String = titleTF.text!
        let summary = summaryTF.text!
        
        if (author.count != 0 && title.count != 0 && summary.count != 0) {
            
            let context = ComicUtil.getContext()
            let entity = NSEntityDescription.entity(forEntityName: "Comic", in: context)
            let newComic = Comic(entity: entity!, insertInto: context)
            
            newComic.id = UUID().uuidString
            newComic.author = author
            newComic.title = title
            newComic.date = datePublished.date as NSDate
            newComic.summary = summary
            
            do {
                try context.save()
                ComicTableView.addComic(comic: newComic)
                navigationController?.popViewController(animated: true)
            } catch {
                print("context save error")
            }
        } else {
            
            let alertController = UIAlertController(title: "Warning", message: "No empty fields are allowed", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ComicDetailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ComicDetailVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
