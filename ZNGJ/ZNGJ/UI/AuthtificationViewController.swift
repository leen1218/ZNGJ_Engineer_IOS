//
//  AuthtificationViewController.swift
//  ZNGJ
//
//  Created by en li on 17/3/15.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation

class AuthtificationViewController: ViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, RequestHandler {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupUI()
	}
	
	func setupUI()
	{
		self.name_T.delegate = self
		self.name_T.returnKeyType = UIReturnKeyType.done;
		
		// PickerView
		self.pickerView.delegate = self
		// Hide picker to the bottom of the current frame
		self.view.addConstraint(NSLayoutConstraint.init(item: self.pickerActionContainer, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0))
		
		// Init UI
		if UserModel.SharedUserModel().engineer.active == "waiting" {
			self.view.isUserInteractionEnabled = false
			self.waiting_L.isHidden = false
			self.submitBTN.isHidden = true
			// 显示已经提交的资料
			if let profile_image = UserModel.SharedUserModel().engineer.profileImage {
				self.profile_img.alpha = 1.0
				let profileImage_url = "http://oi2mkhmod.bkt.clouddn.com/" + profile_image
				ZNGJImageUploadManager.shared().downloadImage(self.profile_img, fromURL: profileImage_url)
			}
			if let shenfen_image = UserModel.SharedUserModel().engineer.shenfenImage {
				self.shenfenzheng_img.alpha = 1.0
				let shenfenImage_url = "http://oi2mkhmod.bkt.clouddn.com/" + shenfen_image
				ZNGJImageUploadManager.shared().downloadImage(self.shenfenzheng_img, fromURL: shenfenImage_url)
			}
			if let zhengshu_image = UserModel.SharedUserModel().engineer.zhengshuImage {
				self.zhengshu_img.alpha = 1.0
				let zhengshuImage_url = "http://oi2mkhmod.bkt.clouddn.com/" + zhengshu_image
				ZNGJImageUploadManager.shared().downloadImage(self.zhengshu_img, fromURL: zhengshuImage_url)
			}
			self.name_T.text = UserModel.SharedUserModel().engineer.name
			self.congye_L.text = UserModel.SharedUserModel().engineer.serviceType
			self.city_L.text = UserModel.SharedUserModel().engineer.liveCity
			self.area_L.text = UserModel.SharedUserModel().engineer.serviceArea
			
		} else if UserModel.SharedUserModel().engineer.active == "inactive" {
			self.waiting_L.isHidden = true
			self.submitBTN.isHidden = false
			self.view.isUserInteractionEnabled = true
		} else {
			self.waiting_L.isHidden = true
			self.submitBTN.isHidden = true
			self.view.isUserInteractionEnabled = false
		}
	}
	
/*
	头像，证件照，资质证书选取，按钮+imagepickerviewcontroller
*/
	@IBOutlet weak var profile_img: UIImageView!
	@IBOutlet weak var shenfenzheng_img: UIImageView!
	@IBOutlet weak var zhengshu_img: UIImageView!
	var currentImg: UIImageView!
	var imagePicker: UIImagePickerController!
	
	@IBAction func touxiangPressed(_ sender: UIButton) {
		self.currentImg = self.profile_img
		self.showImagePickActionSheet()
	}
	@IBAction func shenfenPressed(_ sender: UIButton) {
		self.currentImg = self.shenfenzheng_img
		self.showImagePickActionSheet()
	}
	
	@IBAction func zizhiPressed(_ sender: UIButton) {
		self.currentImg = self.zhengshu_img
		self.showImagePickActionSheet()
	}
	
	func showImagePickActionSheet()
	{
		let actionSheetController: UIAlertController = UIAlertController.init(title: "请选择图片", message: nil, preferredStyle: .actionSheet)
		// 取消按钮
		let cancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: {
			action -> Void in
		})
		actionSheetController.addAction(cancelAction)
		
		// 相册
		let choosePictureAction: UIAlertAction = UIAlertAction.init(title: "从相册选择", style: .default, handler: {
			action -> Void in
			self.pickImageFrom(source: "相册")
		})
		actionSheetController.addAction(choosePictureAction)
		
		// 相机
		let takePictureAction: UIAlertAction = UIAlertAction.init(title: "拍照", style: .default, handler: {
			action -> Void in
			self.pickImageFrom(source: "拍照")
		})
		actionSheetController.addAction(takePictureAction)
		
		self.present(actionSheetController, animated: true, completion: nil)
	}
	
	func pickImageFrom(source: String)
	{
		self.imagePicker = UIImagePickerController.init()
		self.imagePicker.delegate = self
		self.imagePicker.allowsEditing = true
		
		switch source {
		case "拍照":
			self.imagePicker.sourceType = .camera
		case "相册":
			self.imagePicker.sourceType = .photoLibrary
		default:
			self.imagePicker.sourceType = .camera
		}
		
		self.present(self.imagePicker, animated: true, completion: nil)
	}
	
// ImagePicker Delegate
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
			// 选择的不是照片
			return
		}
		self.currentImg.image = selectedImage
		self.currentImg.alpha = 1.0
		self.imagePicker.dismiss(animated: true, completion: nil)
	}
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.imagePicker.dismiss(animated: true, completion: nil)
	}
	
// 头像等图片选取 END
	
/*
	姓名
*/
	@IBOutlet weak var name_T: UITextField!
	
	//TextField - Delegate
	func textFieldDidEndEditing(_ textField: UITextField) {
	}
	func textFieldDidBeginEditing(_ textField: UITextField) {
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func handleSingleTap(_ sender: UITapGestureRecognizer) {
		if sender.state == .ended {
			self.name_T.resignFirstResponder()
		}
		sender.cancelsTouchesInView = false
	}
// 姓名 END
	
	
/*
	从业类型，所在城市，服务区域，按钮+pickerview
*/
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var pickerActionContainer: UIView!
	
	@IBOutlet weak var congye_L: UILabel!
	@IBOutlet weak var city_L: UILabel!
	@IBOutlet weak var area_L: UILabel!
	
	let congyeType = [["第一志愿", "空调", "冰箱", "地暖", "洗衣机", "其他"],
	                  ["第二志愿", "空调", "冰箱", "地暖", "洗衣机", "其他"],
	                  ["第三志愿", "空调", "冰箱", "地暖", "洗衣机", "其他"]]
	let cityType = [["杭州"]]
	let areaType = [["西湖区", "滨江区", "拱墅区", "上城区", "下城区", "江干区", "萧山区", "余杭区"]]
	
	enum pickerTypeEnum {
		case UNDEFINED
		case CONGYE_TYPE
		case CITY_TYPE
		case AREA_TYPE
	}
	
	var pickerType:pickerTypeEnum = pickerTypeEnum.UNDEFINED
	var pickerData: [[String]] = [[]]
	var selectedData:[String] = ["undefined", "undefined", "undefined"]
	
	@IBAction func congyePressed(_ sender: UIButton) {
		self.pickerType = pickerTypeEnum.CONGYE_TYPE
		self.pickerData = congyeType
		self.pickerView.reloadAllComponents()
		showPicker()
	}
	
	@IBAction func cityPressed(_ sender: UIButton) {
		self.pickerType = pickerTypeEnum.CITY_TYPE
		self.pickerData = cityType
		self.pickerView.reloadAllComponents()
		showPicker()
	}
	
	@IBAction func areaPressed(_ sender: UIButton) {
		self.pickerType = pickerTypeEnum.AREA_TYPE
		self.pickerData = areaType
		self.pickerView.reloadAllComponents()
		showPicker()
	}
	
	func animateMoveUp()
	{
		// Hide picker to the bottom of the current frame
		var pickerActionContainerFrame:CGRect = self.pickerActionContainer.frame
		pickerActionContainerFrame.origin.y = self.view.frame.origin.y + self.view.frame.size.height - self.pickerView.frame.size.height - self.pickerActionContainer.frame.size.height
		self.pickerActionContainer.frame = pickerActionContainerFrame
		
		var pickerViewFrame:CGRect = self.pickerView.frame
		pickerViewFrame.origin.y = self.view.frame.origin.y + self.view.frame.size.height - self.pickerView.frame.size.height
		self.pickerView.frame = pickerViewFrame
	}
	func animateMoveDown()
	{
		// Hide picker to the bottom of the current frame
		var pickerActionContainerFrame:CGRect = self.pickerActionContainer.frame
		pickerActionContainerFrame.origin.y = self.view.frame.origin.y + self.view.frame.size.height
		self.pickerActionContainer.frame = pickerActionContainerFrame
		
		var pickerViewFrame:CGRect = self.pickerView.frame
		pickerViewFrame.origin.y = self.view.frame.origin.y + self.view.frame.size.height + self.pickerActionContainer.frame.size.height
		self.pickerView.frame = pickerViewFrame
	}
	func animateComplete(comp: Bool)
	{
	}
	
	func showPicker()
	{
		let animateTime = 0.3
		UIView.animate(withDuration: animateTime, animations: animateMoveUp, completion: animateComplete)
		for component in 0..<self.pickerData.count {
			let row = self.pickerView.selectedRow(inComponent: component)
			self.selectedData[component] = self.pickerData[component][row]
		}
	}
	func hidePicker()
	{
		let animateTime = 0.3
		UIView.animate(withDuration: animateTime, animations: animateMoveDown, completion: animateComplete)
	}
	
	func checkSelectedData() -> Bool
	{
		for index in 0..<3 {
			if self.selectedData[index] != "undefined" {
				for index_c in index+1..<3 {
					if self.selectedData[index] == self.selectedData[index_c] {
						return false
					}
				}
			}
		}
		return true
	}
	
	@IBAction func pickComplete(_ sender: UIButton) {
		
		if !self.checkSelectedData() {
			showAlert(title: "选项重复", message: "不能选择相同的项目", parentVC: self, okAction: nil)
			return
		}
		
		var selectedStringComb: String = ""
		for selectedString in self.selectedData {
			if selectedString != "undefined" && !selectedString.contains("志愿") {
				if selectedStringComb != "" {
					selectedStringComb += ","
				}
				selectedStringComb += selectedString
			}
		}
		if selectedStringComb != "" {
			switch self.pickerType {
			case pickerTypeEnum.CONGYE_TYPE:
				self.congye_L.text = selectedStringComb
			case pickerTypeEnum.CITY_TYPE:
				self.city_L.text = selectedStringComb
			case pickerTypeEnum.AREA_TYPE:
				self.area_L.text = selectedStringComb
			default:
				self.congye_L.text = "请选择"
				self.city_L.text = "请选择"
				self.area_L.text = "请选择"
			}
		}
		self.selectedData = ["undefined", "undefined", "undefined"]
		self.hidePicker()
	}

	@IBAction func pickCancel(_ sender: UIButton) {
		self.selectedData = ["undefined", "undefined", "undefined"]
		self.hidePicker()
	}
	
// Datasource - PickerView
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return self.pickerData.count
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.pickerData[component].count
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.pickerData[component][row]
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.selectedData[component] = self.pickerData[component][row]
	}

// PickerView End
	
	@IBOutlet weak var submitBTN: UIButton!
	@IBOutlet weak var waiting_L: UILabel!
	
	
	// 提交审核
	@IBAction func submit(_ sender: UIButton) {
		if !self.agreement {
			showAlert(title: "协议阅读", message: "请阅读并同意易修哥用户协议", parentVC: self, okAction: nil)
			return
		}
		// 1. 检查资料完整性
		if !self.ziliaoComplete() {
			showAlert(title: "资料不完整", message: "请完整填写所有的必填资料", parentVC: self, okAction: nil)
			return
		}
		
		// 2. 从服务器获取上传图片token
		let phone = UserModel.SharedUserModel().engineer.cellphone!
		let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_IMAGE_UPLOAD_TOKEN)
		let params:Dictionary<String, String> = ["phone": phone]
		request.params = params
		request.handler = self
		request.start()
		
		self.view.isUserInteractionEnabled = false
	}
	
	func onSuccess(_ response: Any!) {
		let result_json = response as! Dictionary<String, Any>
		if (result_json["status"] != nil) {
			if (result_json["status"] as! String == "200") {
				if (result_json["msg"] as! String == "token") {
					guard let tokens = result_json["tokens"] as? Dictionary<String, String>  else {
						showAlert(title: "图片上传失败", message: "资料图片上传失败，请重试", parentVC: self, okAction: nil)
						return
					}
					// 提交申请参数设置
					let engineerId = 1 //UserModel.SharedUserModel().engineerId!
					let name = self.name_T.text!
					let congyeType = self.congye_L.text!
					let city = self.city_L.text!
					let area = self.area_L.text!
					let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_AUTH_SUBMIT)
					var params:Dictionary<String, String> = ["engineerID": String(engineerId), "name":name, "ServiceType":congyeType, "LiveCity":city, "ServiceArea":area]
					
					// 3. 提交图片到图片服务器
					// 3.1 头像
					let phone: String = UserModel.SharedUserModel().engineer.cellphone!
					if self.profile_img != nil {
						let save_path: String = phone + "_profile.jpg"
						ZNGJImageUploadManager.shared().uploadImage(self.profile_img.image, withToken: tokens["profile"], savedAs: save_path)
						params["ProfileImage"] = save_path
					}
					// 3.2 身份证
					if self.shenfenzheng_img != nil {
						let save_path: String = phone + "_shenfen.jpg"
						ZNGJImageUploadManager.shared().uploadImage(self.profile_img.image, withToken: tokens["shenfen"], savedAs: save_path)
						params["ShenfenImage"] = save_path
					}
					// 3.3 资质证书
					if self.profile_img != nil {
						let save_path: String = phone + "_zizhi.jpg"
						ZNGJImageUploadManager.shared().uploadImage(self.profile_img.image, withToken: tokens["zizhi"], savedAs: save_path)
						params["ZhengshuImage"] = save_path
					}
					
					// 4. 提交申请到工程师服务器
					request.params = params
					request.handler = self
					request.start()
				} else {
					// 更新数据
					let user_info = result_json["user_info"] as? Dictionary<String, Any>
					if user_info != nil {
						UserModel.SharedUserModel().engineer.refresh(data: user_info!)
					}
					
					// 跳转到住界面
					let okaction = UIAlertAction(title: "确定", style: .default, handler: {
						// 跳转到维修主界面
						action in
						let mainTBVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTBViewController")
						self.view.window?.rootViewController = mainTBVC
					})
					showAlert(title: "提交成功", message: "审核资料提交成功，等待审核！", parentVC: self, okAction: okaction)
					return
				}
			}
		}
	}
	
	func onFailure(_ error: Error!) {
		self.view.isUserInteractionEnabled = true
		showAlert(title: "提交失败", message: "审核资料提交失败，请重新提交！", parentVC: self, okAction: nil)
		return
	}
	
	func ziliaoComplete() -> Bool
	{
		if self.name_T.text! == "" {
			return false
		}
		if self.congye_L.text! == "请选择" {
			return false
		}
		if self.city_L.text! == "请选择" {
			return false
		}
		if self.area_L.text! == "请选择" {
			return false
		}
		if self.profile_img == nil {
			return false
		}
		if self.shenfenzheng_img == nil {
			return false
		}
		return true;
	}
	
	
	@IBOutlet weak var agreementBTN: UIButton!
	var agreement: Bool = false
	// 阅读协议
	@IBAction func readAgreementCheck(_ sender: UIButton) {
		self.agreement = !self.agreement
		if self.agreement {
			self.agreementBTN.setImage(UIImage.init(named: "box-checked"), for: UIControlState.normal)
		} else {
			self.agreementBTN.setImage(UIImage.init(named: "box-empty"), for: UIControlState.normal)
		}
	}
	
}
