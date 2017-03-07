//
// Created by Chope on 2017. 3. 1..
// Copyright (c) 2017 TeamCNN. All rights reserved.
//

import UIKit

open class ChopeColorButton: UIButton {
    public var touched: ((ChopeColorButton)->Void)?
    public var color: UIColor = UIColor.white {
        didSet {
            backgroundColor = color
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        adjustBorder(width: 1, color: color.contrast())
        addTarget(self, action: #selector(onTouch), for: .touchUpInside)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    open override var isSelected: Bool {
        didSet {
            if isSelected {
                adjustBorder(width: 1, color: color.contrast())
            } else {
                adjustBorder(width: 0, color: color.contrast())
            }
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                adjustBorder(width: 1, color: color.contrast())
            } else {
                adjustBorder(width: 0, color: color.contrast())
            }
        }
    }

    @objc func onTouch() {
        touched?(self)
    }
}

// from ChopeLibrary (https://github.com/yoonhg84/ChopeLibrary)
private extension UIView {
    func adjustBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}

private extension UIColor {
    func contrast() -> UIColor {
        return isLight() ? .black : .white
    }
    
    func isLight() -> Bool {
        let ciColor: CIColor = CIColor(color: self)
        let lumaRed: CGFloat = 0.299 * ciColor.red
        let lumaGreen: CGFloat = 0.587 * ciColor.green
        let lumaBlue: CGFloat = 0.114 * ciColor.blue
        let luma: CGFloat = 1 - CGFloat(lumaRed + lumaGreen + lumaBlue)
        return luma < 0.5
    }
}
