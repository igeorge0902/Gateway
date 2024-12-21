import PlaygroundSupport
import UIKit

class QRCodeView: UIView {
    lazy var filter = CIFilter(name: "CIQRCodeGenerator")
    lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    func generateCode(_ string: String) {
        guard let filter = filter,
            let data = string.data(using: .isoLatin1, allowLossyConversion: false) else {
            return
        }

        filter.setValue(data, forKey: "inputMessage")

        guard let ciImage = filter.outputImage else {
            return
        }

        imageView.image = UIImage(ciImage: ciImage, scale: 2.0, orientation: .up)
    }
}

let frame = CGRect(origin: .zero, size: .init(width: 320, height: 320))
let view = QRCodeView(frame: frame)
view.generateCode("https://placekitten.com/500/500")
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
