//
//  ViewController.swift
//  UIKitToSwintUISample01
//
//  Created by cmStudent on 2023/12/18.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textFieldA: UITextField!

    var dataValue01 = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldA.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dataValue01 = textFieldA.text!
        textFieldA.resignFirstResponder() //  キーボードを閉じる
        labelA.text = dataValue01 // 入力した文字を格納
        textFieldA.text = ""
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            let nextView = segue.destination as! SecondViewController
            nextView.dataValue02 = dataValue01
        }
    }

    // Viewが全部表示した後
    override func viewDidAppear(_ animated: Bool) {
        labelA.text = dataValue01
    }

    @IBAction func dataSetAction(_ sender: UIButton) {
    }
}

