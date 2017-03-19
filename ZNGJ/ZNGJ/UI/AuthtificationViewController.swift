//
//  AuthtificationViewController.swift
//  ZNGJ
//
//  Created by en li on 17/3/15.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation

class AuthtificationViewController: ViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {
	
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
	
	// 提交审核
	@IBAction func submit(_ sender: UIButton) {
		if !self.agreement {
			showAlert(title: "协议阅读", message: "请阅读并同意易修哥用户协议", parentVC: self, okAction: nil)
			return
		}
		
		//
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
