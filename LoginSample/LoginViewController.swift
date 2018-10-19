//
//  ViewController.swift
//  LoginSample
//
//  Created by Togami Yuki on 2018/09/30.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    

    @IBOutlet weak var emilTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*----------------------------------------------*/
        //Googleログインに関するデリゲートとボタンを追加
        /*----------------------------------------------*/
        //Googleログインに関するデリゲートを設定
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //ボタン
        let googleBtn = GIDSignInButton()
        googleBtn.frame = CGRect(x:20,y:280,width:self.view.frame.size.width - 40,height:60)
        view.addSubview(googleBtn)
        
        
        
        
        
        /*----------------------------------------------*/
        //キーボードの上に「Done」ボタンを設置
        /*----------------------------------------------*/
        //ツールバー生成
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
    
    /*----------------------------------------------*/
    //emailとpasswordで新規登録＆ログイン
    /*----------------------------------------------*/
    //新規登録(email&password)
    @IBAction func newAdd(_ sender: UIButton) {
        print("memo:新規登録開始")
        Auth.auth().createUser(withEmail: emilTextField.text!, password: passTextField.text!) { (authResult, error) in
            if let error = error {
                print("memo:新規登録エラー\(error)")
                self.alert(memo:"新規登録エラー\(error)")
                return
            }
            if let authResult = authResult{
                print("memo:新規登録成功",authResult.user.email!)
                self.alert(memo:"新規登録成功")
            }
        }
    }
    
    //ログイン(email&password)
    @IBAction func loginBtn(_ sender: UIButton) {
        print("memo:ログイン開始")
        Auth.auth().signIn(withEmail: emilTextField.text!, password: passTextField.text!) { (user, error) in
            if let error = error {
                print("memo:ログインエラー\(error)")
                self.alert(memo:"ログインエラー\(error)")
                return
            }
            if let user = user {
                print("memo:ログイン成功",user.user.email!)
                self.alert(memo:"ログイン成功")
            }
        }
    }
    
    /*----------------------------------------------*/
    //Googleログイン&ログアウト
    /*----------------------------------------------*/
    //Googleログイン時の処理
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        //Googleログイン時エラーが発生したら、エラーを返し、この関数から抜ける
        if let error = error {
            print("memo:Googleログイン後エラー",error)
            alert(memo:"memo:Googleログイン後エラー")
            return
        }
        //authenticationに情報が入っていなかったら、この関数から抜ける
        guard let authentication = user.authentication else { return }
        
        //ログインに成功したら、各種トークンを受け取る
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        //トークンを受け取った後の処理を記述.Googleから得たトークンをFirebaseへ保存
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("memo:FirebaseへGoogleから得たトークン保存時にエラー",error)
                self.alert(memo:"FirebaseへGoogleから得たトークン保存時にエラー")
                return
            }
            print("memo:Googleログイン成功",authResult?.user.email)
            self.alert(memo:"Googleログイン成功\(authResult?.user.email)")
        }
    }
    //Googleログイン失敗時の処理
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //Googleログイン時エラーが発生したら、エラーを返し、この関数から抜ける
        if let error = error {
            print("memo:Googleログイン失敗エラー",error)
            alert(memo:"memo:Googleログイン失敗エラー")
            return
        }
    }
    
    
    
    
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("memo:サインアウト成功")
            alert(memo:"サインアウト成功")
        } catch let signOutError as NSError {
            print ("memo:サインアウトエラー", signOutError)
            alert(memo:"サインアウトエラー\(signOutError)")
        }
    }
    
    
    
    
    /*----------------------------------------------*/
    //アラート関数
    /*----------------------------------------------*/
    func alert(memo:String){
        let alert = UIAlertController(title: "アラート", message: memo, preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
            //OKを押した後の処理。
        }))
        //その他アラートオプション
        alert.view.layer.cornerRadius = 25 //角丸にする。
        present(alert,animated: true,completion: {()->Void in print("アラート表示")})//completionは動作完了時に発動。
    }
    
    
    
}

