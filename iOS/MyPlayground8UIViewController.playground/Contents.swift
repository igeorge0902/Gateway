//: A UIKit based Playground for presenting user interface
  
import UIKit
import Foundation
import PlaygroundSupport

class MyViewController : UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var nameTextView: UITextView!
    var nameTextViewT: UITextView!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: view.frame.width / 2, height: 20))
          btnNav.backgroundColor = UIColor.black
          btnNav.setTitle("Back", for: UIControl.State())
          view.addSubview(btnNav)
        
         let label = UILabel()
         label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
         label.text = "Hello World!"
         label.textColor = .black
        
         view.addSubview(label)

        
          /*
          scrollView = UIScrollView()
          scrollView.delegate = self
          scrollView.frame = view.bounds
          scrollView.alwaysBounceVertical = true
          scrollView.backgroundColor = UIColor.white
          scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
          scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 55.0, right: 0.0)
          
          // title
           nameTextViewT = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: view.frame.height * 0.15, width: view.frame.size.width * 0.8, height: view.frame.height / 7))
           nameTextViewT?.isEditable = false

           let myTextAttributeT = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
           let detailTextT = NSMutableAttributedString(string: "Title", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttributeT))

           nameTextViewT?.attributedText = detailTextT
           nameTextViewT?.textAlignment = NSTextAlignment.justified
           nameTextViewT?.alwaysBounceVertical = true
          
          // title text
          nameTextView = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: view.frame.height * 0.15, width: view.frame.size.width * 0.8, height: view.frame.height / 7))
          nameTextView?.isEditable = false

          let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
          let detailText = NSMutableAttributedString(string: "title", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

          nameTextView?.attributedText = detailText
          nameTextView?.textAlignment = NSTextAlignment.justified
          nameTextView?.alwaysBounceVertical = true
        
         let label = UILabel()
         label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
         label.text = "Hello World!"
         label.textColor = .black
         
         scrollView.addSubview(label)
         scrollView.addSubview(nameTextView!)
         view.addSubview(scrollView)
         view.sendSubviewToBack(scrollView)
        */
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
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
