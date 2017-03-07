//
//  ViewController.swift
//  Example
//
//  Created by Chope on 2017. 3. 7..
//  Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit
import ChopeColorPicker


class ViewController: UIViewController {
    var colorPickerDelegate: ChopeColorPickerDelegate!

    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    @IBAction func touch(button: ChopeColorButton) {
        colorPickerDelegate = ChopeColorPickerDefaultDelegate(baseView: button, selectedColor: button.color) { color in
            button.color = color
        }
        let colorPicker = ChopeColorPickerViewController(delegate: colorPickerDelegate)
        present(colorPicker, animated: false, completion: nil)
    }

}
