//
//  SecondViewController.swift
//  UIKitToSwintUISample01
//
//  Created by cmStudent on 2023/12/18.
//

import UIKit
import SwiftUI
import Combine

class SecondViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var swiftUIButton: UIButton!
    @IBOutlet weak var textFieldB: UITextField!
    
    var dataValue02 = ""

    let swiftUIdelegate = BindingData()
    var combineData: AnyCancellable!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldB.delegate = self
        labelB.text = dataValue02
        
        navigationController?.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dataValue02 = textFieldB.text!
        textField.resignFirstResponder()
        labelB.text = dataValue02
        
        return true
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if let controller = viewController as? ViewController {
            controller.dataValue01 = dataValue02
        }
    }
    
    @IBAction func openCloseSwiftUI(_ sender: UIButton) {
        openCloseSwiftUI()
    }
    
    func openCloseSwiftUI() {
        let swiftUIViewController = UIHostingController(rootView: SwiftUIView(swiftUIData: swiftUIdelegate, dismissHandler: {
            self.dismiss(animated: true)
        }))

        swiftUIViewController.modalPresentationStyle = .overFullScreen
        present(swiftUIViewController, animated: true)

        self.combineData = swiftUIdelegate.$shareData.sink {
            value in self.dataValue02 = value
        }
    }
}

class BindingData: ObservableObject {
    @Published var shareData = ""
}

struct SwiftUIView: View {
    @ObservedObject var swiftUIData: BindingData
    @State var textData = ""
    @State var editting = false
    @State var data = ""

    let dismissHandler: () -> Void
    var body: some View {
        ZStack(alignment: .center) {
            Color.indigo
            HStack {
                VStack {
                    TextField("入力して下さい", text: $data,
                              onEditingChanged: { begin in

                        /// 入力開始処理

                        if begin {
                            self.editting = true    // 編集フラグをオン
                            self.textData = ""       // メッセージをクリア
                            /// 入力終了処理
                        } else {
                            self.editting = false   // 編集フラグをオフ
                        }
                    },
                              /// リターンキーが押された時の処理
                              onCommit: {
                        self.textData = self.data   // メッセージセット
                        self.data = ""  // 入力域をクリア
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .shadow(color: editting ? .blue : .clear, radius: 3)

                    Text(textData)
                        .foregroundColor(.white)

                    Button(action: {
                        self.swiftUIData.shareData = textData
                        dismissHandler()
                    }){
                        Text("UIKitにもどる")
                            .font(.largeTitle)
                            .frame(width: 250, height: 40, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8.0)
                    }
                    Text("ここはSwiftUIのViewです")
                        .foregroundColor(.white)
                }

            }
        }
    }
}
