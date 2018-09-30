//
//  ViewController.swift
//  LoginSample
//
//  Created by Togami Yuki on 2018/09/30.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    

    @IBOutlet weak var emilTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action:#selector(self.closeKeybord(_:)))
        kbToolBar.items = [spacer, commitButton]
        emilTextField.inputAccessoryView = kbToolBar
        passTextField.inputAccessoryView = kbToolBar
    }
    
    @objc func closeKeybord(_ sender:Any){
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //新規登録
    @IBAction func newAdd(_ sender: UIButton) {
        print("memo:新規登録開始")
        Auth.auth().createUser(withEmail: emilTextField.text!, password: passTextField.text!) { (authResult, error) in
            if let error = error {
                print("memo:新規登録エラー\(error)")
                return
            }
            if let authResult = authResult{
                print("memo:新規登録成功",authResult.user.email!)
                print("memo:")
            }
        }
    }
    
    //ログイン
    @IBAction func loginBtn(_ sender: UIButton) {
        print("memo:ログイン開始")
        Auth.auth().signIn(withEmail: emilTextField.text!, password: passTextField.text!) { (user, error) in
            if let error = error {
                print("memo:ログインエラー\(error)")
                return
            }
            if let user = user {
                print("memo:ログイン成功",user.user.email!)
            }
        }
    }
    


}

