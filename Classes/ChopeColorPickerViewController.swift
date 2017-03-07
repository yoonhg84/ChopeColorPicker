//
// Created by Chope on 2017. 3. 1..
// Copyright (c) 2017 TeamCNN. All rights reserved.
//

import UIKit

public protocol ChopeColorPickerDelegate: class {
    func baseView(in colorPicker: ChopeColorPickerViewController) -> ChopeColorButton
    func colors(in colorPicker: ChopeColorPickerViewController) -> [UIColor]
    func selectedColor(in colorPicker: ChopeColorPickerViewController) -> UIColor?
    func colorPicker(_ colorPicker: ChopeColorPickerViewController, pointAt index: Int) -> CGPoint
    func colorPicker(_ colorPicker: ChopeColorPickerViewController, selected color: UIColor)
}

open class ChopeColorPickerDefaultDelegate: ChopeColorPickerDelegate {
    private let numberOfColsInRow: Int = 3
    private let spacingBetweenCols: CGFloat = 10
    private let baseView: ChopeColorButton
    private let selectedColor: UIColor?
    private let onSelect: ((UIColor)->Void)?

    public init(baseView: ChopeColorButton, selectedColor: UIColor?, selected: ((UIColor)->Void)?) {
        self.baseView = baseView
        self.selectedColor = selectedColor
        self.onSelect = selected
    }

    public func baseView(in colorPicker: ChopeColorPickerViewController) -> ChopeColorButton {
        return baseView
    }

    public func colors(in colorPicker: ChopeColorPickerViewController) -> [UIColor] {
        return [
                UIColor.red, UIColor.blue, UIColor.yellow,
                UIColor.purple, UIColor.green, UIColor.gray,
                UIColor.brown, UIColor.white, UIColor.lightGray
        ]
    }

    public func selectedColor(in colorPicker: ChopeColorPickerViewController) -> UIColor? {
        return selectedColor
    }

    public func colorPicker(_ colorPicker: ChopeColorPickerViewController, pointAt index: Int) -> CGPoint {
        let row: Int = index / numberOfColsInRow
        let col: Int = index % numberOfColsInRow

        let originOfBaseView = colorPicker.originOfBaseView()
        let width = baseView.frame.width
        let xOfFirstView: CGFloat = originOfBaseView.x - ((width + spacingBetweenCols) * CGFloat(numberOfColsInRow - 1))
        let yOfFirstView: CGFloat = originOfBaseView.y
        let x: CGFloat = xOfFirstView + ((width + spacingBetweenCols) * CGFloat(col))
        let y: CGFloat = yOfFirstView + ((width + spacingBetweenCols) * CGFloat(row))
        return CGPoint(x: x, y: y)
    }

    public func colorPicker(_ colorPicker: ChopeColorPickerViewController, selected color: UIColor) {
        onSelect?(color)
    }
}


open class ChopeColorPickerViewController: UIViewController {
    public weak var delegate: ChopeColorPickerDelegate?

    fileprivate var colorButtons: [ChopeColorButton] = []

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public convenience init(delegate: ChopeColorPickerDelegate?) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        modalPresentationStyle = .custom
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .custom
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if colorButtons.count == 0 {
            resetColorViews()
            startPresenting()
        }
    }

    private func resetColorViews() {
        guard let delegate = delegate else { return }

        let point = originOfBaseView()
        let boundsOfBaseView = delegate.baseView(in: self).bounds
        let colors = delegate.colors(in: self)

        colors.forEach { [weak self] color in
            guard let ss = self else {
                return
            }
            let button = ChopeColorButton(frame: boundsOfBaseView)
            button.frame.origin = point
            button.color = color
            button.addTarget(self, action: #selector(ss.touchColor(button:)), for: .touchUpInside)
            ss.colorButtons.append(button)
            ss.view.addSubview(button)
        }

        if let selectedColor = delegate.selectedColor(in: self), let colorButton = colorButtons.filter({ $0.color == selectedColor }).first {
            view.bringSubview(toFront: colorButton)
        }
    }

    public func originOfBaseView() -> CGPoint {
        guard let baseView = delegate?.baseView(in: self), let superviewOfBaseView = baseView.superview else {
            return CGPoint()
        }
        let point = superviewOfBaseView.convert(baseView.frame.origin, to: self.view)
        return point
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        repositioningToBaseView()
    }

    @objc func touchColor(button: ChopeColorButton) {
        view.bringSubview(toFront: button)
        delegate?.colorPicker(self, selected: button.color)
        repositioningToBaseView()
    }
}

private extension ChopeColorPickerViewController {
    func startPresenting() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }, completion: { [weak self] _ in
            self?.startResizingToSquare()
        })
    }

    func startResizingToSquare() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.colorButtons.forEach { button in
                button.frame.size.height = button.frame.size.width
            }
        }, completion: { [weak self] b in
            self?.repositioningColorButtons()
        })
    }

    func repositioningColorButtons() {
        guard let delegate = delegate else {
            assertionFailure()
            return
        }

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let ss = self else {
                return
            }

            for i in 0..<ss.colorButtons.count {
                let button = ss.colorButtons[i]
                button.frame.origin = delegate.colorPicker(ss, pointAt: i)
            }
        }, completion: { b in

        })
    }

    func repositioningToBaseView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let ss = self else { return }
            ss.colorButtons.forEach { view in
                view.frame.origin = ss.originOfBaseView()
            }
        }, completion: { [weak self] b in
            self?.resizingToBaseView()
        })
    }

    func resizingToBaseView() {
        guard let baseView = delegate?.baseView(in: self) else {
            assertionFailure()
            return
        }

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let ss = self else { return }
            ss.colorButtons.forEach { view in
                view.frame.size.height = baseView.frame.height
            }
        }, completion: { [weak self] b in
            self?.startDismissing()
        })
    }

    func startDismissing() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.backgroundColor = UIColor.clear
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false)
        })
    }
}
