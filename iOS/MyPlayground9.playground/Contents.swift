//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
class MyViewController : UIViewController, UITextFieldDelegate {
    
    lazy var nameTextView = UITextView()
    lazy var nameTextView_ = UITextView()
    lazy var nameTextViewX = UITextView()
    lazy var textfield = UITextField()

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        
        // create the textView
        nameTextView = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: 25 * 3.0, width: view.frame.size.width * 0.8, height: view.frame.height / 10))
        nameTextView.isEditable = false

        let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
        let detailText = NSMutableAttributedString(string: "user", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

        nameTextView.attributedText = detailText
        nameTextView.textAlignment = NSTextAlignment.justified
        nameTextView.alwaysBounceVertical = true
        nameTextView.layer.borderWidth = 2
        nameTextView.layer.borderColor = UIColor.darkGray.cgColor
        
        // create the textView
        nameTextView_ = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: view.frame.height / 4.5, width: view.frame.size.width * 0.8, height: view.frame.height / 10))
        nameTextView_.isEditable = false

        let myTextAttribute_ = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                
        let detailText_ = NSMutableAttributedString(string: "JSESSION cookie", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute_))

        nameTextView_.attributedText = detailText_
        nameTextView_.textAlignment = NSTextAlignment.justified
        nameTextView_.alwaysBounceVertical = true
        nameTextView_.layer.borderWidth = 2
        nameTextView_.layer.borderColor = UIColor.darkGray.cgColor
        
        let cookieStorage = HTTPCookieStorage.shared
             if let cookies_ = cookieStorage.cookies {
                 for cookie in cookies_ {
                     if (cookie.name == "JSESSIONID") {
                        self.nameTextView_.text = cookie.value
                     }
                 }
         }
        
        // create the textView
        nameTextViewX = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: (view.frame.height / 4.5)+(view.frame.height / 10)+2, width: view.frame.size.width * 0.8, height: view.frame.height / 10))
        nameTextViewX.isEditable = false

        let myTextAttributeX = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                
        let detailTextX = NSMutableAttributedString(string: "x-cookie", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttributeX))

        nameTextViewX.attributedText = detailTextX
        nameTextViewX.textAlignment = NSTextAlignment.justified
        nameTextViewX.alwaysBounceVertical = true
        nameTextViewX.layer.borderWidth = 2
        nameTextViewX.layer.borderColor = UIColor.darkGray.cgColor
        
        if let cookies_ = cookieStorage.cookies {
                 for cookie in cookies_ {
                     if (cookie.name == "XSRF-TOKEN") {
                        self.nameTextViewX.text = cookie.value
                     }
                 }
         }
        
        textfield = UITextField(frame: CGRect(x: view.frame.size.height * 0.05, y: (view.frame.height / 4.5)+(view.frame.height / 10)+2, width: view.frame.size.width * 0.8, height: 25))
        textfield.layer.borderColor = UIColor.darkGray.cgColor
        textfield.layer.borderWidth = 1
        textfield.drawPlaceholder(in: CGRect(x: view.frame.size.height * 0.05, y: (view.frame.height / 4.5)+(view.frame.height / 10)+2, width: view.frame.size.width * 0.8, height: 25))
        textfield.placeholder = "category like troll"
        view.addSubview(nameTextView)
        view.addSubview(nameTextView_)
        view.addSubview(textfield)
        

    }
    
    func textFieldShouldEndEditing(_ textfield: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textfield: UITextField) {
        print("hello")
    }
    
    func textFieldDidBeginEditing(_ textfield: UITextField) {
        print("hello")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
}


// Helper function inserted by Swift 4.2 migrator.
private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value) })
}
