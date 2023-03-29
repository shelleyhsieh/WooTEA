//
//  FBEnterViewController.swift
//  WooTEA
//
//  Created by shelley on 2023/3/7.
//
// notification 傳送通知到訂單姓名，userInfo傳資料，蛋notitfication不適合傳到下一頁
import UIKit
import FacebookLogin

class FBEnterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //在畫面上加入 Facebook iOS SDK 內建的 FBLoginButton
//        let loginButton = FBLoginButton()
//        loginButton.center = view.center
//        //loginButton.permissions = ["public_profile", "email"]
//        view.addSubview(loginButton)
        
        // 當 AccessToken.current 有值時即代表使用者已登入，從 AccessToken 物件的 userID 可取得使用者的 ID
        if let accesstoken = AccessToken.current,
           !accesstoken.isExpired {
            print("✅\(accesstoken.userID) login")
        }else {
            print("🚫not login")
        }
        
        // 從 Profile 呼叫 function loadCurrentProfile 下載使用者的 profile 資訊，比方使用者的名字跟大頭照網址。
        if let _ = AccessToken.current {
            Profile.loadCurrentProfile { profile, error in
                if let profile = profile {
                    print("👤",profile.name ?? "?")
                    print("👤👤",profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300)) ?? "?")
                   
//                    if let controller = self.storyboard?.instantiateViewController(identifier: "\(OrderTableViewController.self)", creator: { coder in
//                        OrderTableViewController(coder: coder, ordreName: profile.name ?? "")
//                    }){
//                        controller.modalPresentationStyle = .fullScreen
//                        self.show(controller, sender: nil)
//                    }
                    
                }
            }
        }

    }
    
    //生成 LoginManager 物件，透過它的 function logIn 登入，當 closure 參數 result 等於 success 時表示登入成功。
    @IBAction func login(_ sender: Any) {
        let manager = LoginManager()
        manager.logOut()
        manager.logIn(permissions: [.publicProfile, .email]) { result in  //permissions: 傳入 App 想要的權限，比方 publicProfile 表示想取得使用者 FB 的公開資訊。
            switch result {  //completion: FB 登入完成後將執行 completion 的 closure 程式，由型別 LoginResult 的參數判斷結果，當它等於 success 時表示登入成功。
            case .success(granted: let granted, declined: let declined, token: let token):
                let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])  //登入成功後透過 GraphRequest 取得個人的相關資訊
                request.start { response, result, error in
                    if let result = result as? [String:String] {
                        print("👤👤👤", result)
                    }
                    
                    //將畫面傳輸到飲料菜單的第一頁
                    if let controller = self.storyboard?.instantiateViewController(identifier: "TabBarController") as? UITabBarController {
//                        self.show(controller, sender: nil)
                        self.present(controller, animated: true, completion: nil)
                    
                    }
                }
                print("✅ success")
            case .cancelled:
                print("cancelled")
            case .failed(_):
                print("❌ failed")
            }
        }
        
    }
    
//    func jumpInToOrderTableViewController() {
//        if let controller = storyboard?.instantiateViewController(identifier: "\(OrderTableViewController.self)", creator: { coder in
//            OrderTableViewController(coder: coder, ordreName: Profile.)
//        })
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
