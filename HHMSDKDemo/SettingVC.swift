//
//  SettingVC.swift
//  hhVDoctorSDK
//
//  Created by 程言方 on 2020/11/13.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import hhVDoctorSDK

class SettingVC : UIViewController {
    
    @IBOutlet weak var mTableView : UITableView!
    
    private var sections = [(String,[(String,Bool,Bool)])]()
        
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpUI()
        
        setUpData()
    }

    override func viewWillAppear(_ animated: Bool) {
                
    }
    
    
    func setUpUI(){
        title = "设置"
        
        mTableView.separatorStyle = .none
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.separatorStyle = .none
    }
    
    
    func setUpData() {
        
        
        let baseSetting = ("基础设置",[
            ("测试环境",HHSDKOptions.default.isDevelopment,true),
            ("扩展参数",false,false),
        ])
        sections.append(baseSetting)
        
        
        
        let videoSetting = ("音视频设置", [
            ("呼叫是否过滤生日性别",HHSDKOptions.default.mVideoOptions.filterCallerInfo,true),
            ("是否开启美颜",HHSDKOptions.default.mVideoOptions.allowBeauty,true),
            ("是否可以选择多人视频",HHSDKOptions.default.mVideoOptions.allowMulti,true),
            ("是否可以增加成员",HHSDKOptions.default.mVideoOptions.allowAddMember,true),
            ("视频完成后是否有评价",HHSDKOptions.default.mVideoOptions.allowEvaluate,true),
        ])
        sections.append(videoSetting)
        
        
        
        let infoListSetting = ("信息流设置",[
            ("是否过滤总结卡片",HHSDKOptions.default.mMessageOptions.isFilterSummary,true),
            ("是否过滤药卡",HHSDKOptions.default.mMessageOptions.isFilterMedicinal,true),
//            ("小助手默认头像",false,false),
//            ("小助手默认昵称",false,false),
//            ("信息流默认标题",false,false),
            ("开启定位",false,true),
            ("是否通过Present弹出信息流",HHSDKOptions.default.mMessageOptions.isByPresent,true),
        ])
        sections.append(infoListSetting)
        
        
        
        let userCenterSetting = ("个人中心设置",[
            ("隐藏个人中心入口",HHSDKOptions.default.mUserCenterOptions.hideUserCenter,true),
            ("展示激活码入口",HHSDKOptions.default.mUserCenterOptions.enableActivate,true),
            ("展示档案库入口",HHSDKOptions.default.mUserCenterOptions.enableMedical,true),
            ("档案库可以增加成员",HHSDKOptions.default.mUserCenterOptions.enableAddMemberInDoc,true),
            ("展示会员信息",HHSDKOptions.default.mUserCenterOptions.enableVipInfo,true),
            ("展示购买VIP",HHSDKOptions.default.mUserCenterOptions.enableBuyService,true),
            
        ])
        sections.append(userCenterSetting)
        
        
        mTableView.reloadData()
    }
}



extension SettingVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell
        let cellInfo = sections[indexPath.section].1[indexPath.row]
        cell?.configCell(title: cellInfo.0, isOpen: cellInfo.1,isSwitch: cellInfo.2)
        
        let view = UIView()
        view.backgroundColor = .white
        cell?.selectedBackgroundView = view
        
        
        cell?.switchCallback = { [weak self] isOn in
            self?.onConfigChange(indexPath: indexPath, isOpen: isOn)
        }
        
        
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section,indexPath.row) {
        
        case (0,1):
            
            showEditAlter(title: "扩展参数",info: HHSDKOptions.default.mExtension) { info in
                HHSDKOptions.default.mExtension = info
            }
            
            break
            
        case (2,2):
            
            showEditAlter(title: "小助手默认头像",info: HHSDKOptions.default.mExtension) { info in
                HHSDKOptions.default.mMessageOptions.defaultDocHeader = info
            }
            
            break
            
        case (2,3):
            
            showEditAlter(title: "小助手默认昵称",info: HHSDKOptions.default.mExtension) { info in
                HHSDKOptions.default.mMessageOptions.defaultDocName = info
            }
            
            break
        
        case (2,4):
            
            showEditAlter(title: "信息流默认标题",info: HHSDKOptions.default.mExtension) { info in
                HHSDKOptions.default.mMessageOptions.messageTitle = info
            }
            
            break
        default:
            break
            
        }
    }

}


extension SettingVC {
    
    
    func onConfigChange(indexPath : IndexPath , isOpen : Bool) {
        
        switch (indexPath.section,indexPath.row) {
        
        case (0,0):
            HHMSDK.default.switchEnv(isOpen)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "onEnvChange"), object: nil)
            break
     
        case (1,0):
            HHSDKOptions.default.mVideoOptions.filterCallerInfo = isOpen
    
        case (1,1):
            HHSDKOptions.default.mVideoOptions.allowBeauty = isOpen
            
        case (1,2):
            HHSDKOptions.default.mVideoOptions.allowMulti = isOpen
            
        case (1,3):
            HHSDKOptions.default.mVideoOptions.allowAddMember = isOpen
            
        case (1,4):
            HHSDKOptions.default.mVideoOptions.allowEvaluate = isOpen
            
        case (2,0):
            HHSDKOptions.default.mMessageOptions.isFilterSummary = isOpen
            
        case (2,1):
            HHSDKOptions.default.mMessageOptions.isFilterMedicinal = isOpen
            
        case (2,2):
                        
            if isOpen {
                HHLocation.default.startLocation(lng: "116.431941", lat: "39.940199")
                    
            }else{
                
                HHLocation.default.closeLocation()
            }
        
        case (2,3):
            HHSDKOptions.default.mMessageOptions.isByPresent = isOpen
            
        case (3,0):
            HHSDKOptions.default.mUserCenterOptions.hideUserCenter = isOpen
        
        case (3,1):
            HHSDKOptions.default.mUserCenterOptions.enableActivate = isOpen
            
        case (3,2):
            HHSDKOptions.default.mUserCenterOptions.enableMedical = isOpen
            
        case (3,3):
            HHSDKOptions.default.mUserCenterOptions.enableAddMemberInDoc = isOpen
            
        case (3,4):
            HHSDKOptions.default.mUserCenterOptions.enableVipInfo = isOpen
            
        case (3,5):
            HHSDKOptions.default.mUserCenterOptions.enableBuyService = isOpen
            
        default:
            break
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





class SettingCell: UITableViewCell {
    
    @IBOutlet weak var mTitleLabel: UILabel!
    
    @IBOutlet weak var mSwitch : UISwitch!
    
    @IBOutlet weak var mArrow : UIImageView!
    
    var switchCallback : ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configCell(title: String, isOpen : Bool, isSwitch: Bool) {
        mTitleLabel.text = title
        mSwitch.isOn = isOpen
        
        if isSwitch {
            mSwitch.isHidden = false
            mArrow.isHidden = true
        }else{
            mSwitch.isHidden = true
            mArrow.isHidden = false
        }
    }
    
    @IBAction func onSwitch(_ sender : UISwitch) {
        switchCallback?(sender.isOn)
    }
}
