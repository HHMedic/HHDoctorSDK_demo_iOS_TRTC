//
//  LoginVC.swift
//  hhVDoctorSDK_Example
//
//  Created by Shi Jian on 2019/8/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import HHMedicSDK

class LoginVC: UIViewController {

    @IBOutlet weak var mTextView: UITextView!
    @IBOutlet weak var mDescLbl: UILabel!
    @IBOutlet weak var mCallBtn: UIButton!
    @IBOutlet weak var mLoginBtn: UIButton!
    @IBOutlet weak var mMemberBtn: UIButton!
    @IBOutlet weak var mPidText: UITextField!
    @IBOutlet weak var mSkipHomeBt : UIButton!
    
    
    fileprivate lazy var mTestBt : UIButton = {
        let view = UIButton()
        view.setTitle("自定义View", for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HHMSDK.default.add(delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: Notification.Name(rawValue: "onEnvChange"), object: nil)
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func doLogin(_ sender: UIButton) {
        
        HHSDKOptions.default.productId = mPidText.text ?? ""
        
        self.mDescLbl.text = "登录中。。。。。"
        if let userToken = mTextView.text {
            HHMSDK.default.login(userToken: userToken) { [weak self] in
                self?.loginComplete($0)
            }
            return
        }

        HHMSDK.default.login(userToken: mTextView.text) { [weak self] in
            self?.loginComplete($0)
        }
    }
    
    private func loginComplete(_ error: String?) {
        self.view.endEditing(true)
        if let aError = error {
            self.mDescLbl.text = aError
        } else {
            self.mDescLbl.text = "登录成功啦"
            mLoginBtn.isHidden = true
            mCallBtn.isHidden = false
            mMemberBtn.isHidden = false
            mSkipHomeBt.isHidden = false
        }
    }
    
    @IBAction func doCallDoctor(_ sender: UIButton) {
        showEditAlter(title: "输入呼叫token",info: "") { info in
            HHMSDK.default.call(userToken: info)
        }
    }
    
    func doFetchLog(_ sender: UIBarButtonItem) {
        present(FileBrowser(), animated: true, completion: nil)
    }
    

    @IBAction func doSelectMem(_ sender: UIButton) {
        HHMSDK.default.startMemberCall()
    }
    
    
    @IBAction func doLogout(_ sender: UIBarButtonItem) {
        logout()
    }
    
    
    @IBAction func skipToSetting(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(SettingVC(), animated: true)
    }
    
    
    @IBAction func skipToHome(_ sender : UIButton) {
        
        HHMSDK.default.skipChatHome(skipType: .present, vc: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func logout() {
        HHMSDK.default.logout { [weak self] in
            self?.mLoginBtn.isHidden = false
            self?.mCallBtn.isHidden = true
            self?.mMemberBtn.isHidden = true
            self?.mSkipHomeBt.isHidden = true

            if let aError = $0 {
                self?.mDescLbl.text = "退出登录失败:\(aError)"
            } else {
                self?.mDescLbl.text = "退出登录成功"
            }
        }
    }
    
    func showEditAlter(title : String , info : String , callback : @escaping ((String)->Void)) {
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = info
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                
                alert.dismiss(animated: true, completion: nil)
            }
            
            cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
            
            alert.addAction(cancelAction)

            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: {(_) in
                
                let info = alert.textFields?.first?.text
                
                guard info?.count ?? 0 > 0 else { return }
                
                callback(info ?? "")
                
            }))

            present(alert, animated: true, completion: nil)
            
        }
    
}




extension LoginVC: HHMVideoDelegate {
    func callStateChange(_ state: HHMCallingState) {
        
    }
    
    func callDidEstablish() {
        
    }
    
    func onFail(error: Error) {
        
    }
    
    func getChatParentView(_ view: UIView) {

    }
    
    func onCancel() {
        
    }
    
    func receivedOrder(_ orderId: String) {
    }
    
    func callDidFinish() {
        
    }
    
    func onExtensionDoctor() {
        
    }
    
    func onReceive(_ callID: String) {
        
    }
    
    func onResponse(_ accept: Bool) {
        
    }
    
    func onLeakPermission(_ type: PermissionType) {
        
    }
    
    
}
