
import UIKit

class AddViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var titleField:UITextField!
    @IBOutlet var bodyField:UITextField!
    @IBOutlet var datePicker:UIDatePicker!
    
    let userDef = UserDefaults()
    public var completion:((String,String,Date)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate=self
        bodyField.delegate=self
        userDef.value(forKey: "title")
        userDef.value(forKey: "body")
        userDef.value(forKey: "date")
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
    }
    @objc func didTapSaveButton()
    {
        if let titleText=titleField.text, !titleText.isEmpty,
           let bodyText=bodyField.text, !bodyText.isEmpty{
            
            let targetDate=datePicker.date
            completion?(titleText,bodyText,targetDate)
        }
    }
    
    func shouldReturn(_ textField:UITextField)->Bool
    {
        textField.resignFirstResponder()
        return true
    }

}
