import Foundation
import UIKit

public class TvOSAVPlayer: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!

    var text = "Hello, World!, Welcome to Swift Package Manager"
    
    var fileURL: URL!
    var enableControls: Bool = true
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func printHelloWorld() {
        print("\(text)")
    }
}
