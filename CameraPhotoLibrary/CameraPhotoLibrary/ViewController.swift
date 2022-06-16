//
//  ViewController.swift
//  CameraPhotoLibrary
//
//  Created by 203a on 2022/05/27.
//

import UIKit
import MobileCoreServices   // 다양한 타입을 정리한 헤더 추가


class ViewController: UIViewController, UINavigationControllerDelegate,  UIImagePickerControllerDelegate{ // 델리게이트 프로토콜 추가
    
    @IBOutlet var imgView: UIImageView!
    // UIImagePickerController 인스턴스 변수 추가
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage! // 사진을 저장
    var videoURL: URL!  // 녹화 비디오의 URL 저장
    var flagImageSave = false // 사진 저장 여부를 나타냄

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // 사진 촬영하기
    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) { 
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) { //카메라를 사용할 수 있을 때
            flagImageSave = true // 사진 저장 플레그를 true로 설정
            
            imagePicker.delegate = self // 이미지 피커의 델리게이트를 self로 설정
            imagePicker.sourceType = .camera // 소스타입을 camera로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String]
            // 미디어 타입을 KUTTypeImage로 설정
            imagePicker.allowsEditing = false // 편집을 허용하지 않음
            
            present(imagePicker, animated: true, completion: nil)
            //뷰컨트롤럴르 imagepicker로 변경
        }
        else { // 카메라를 켤 수 없을 때, 경고창 출력
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    // 사진 불러오기
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary // 이미지 피커의 소스 타입을 PhotoLibrary로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true // 편집 허용
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }
    }
    @IBAction func btnRecordVideoFromCamera(_ sender: UIButton) { // 비디오 촬영
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    @IBAction func btnLoadVideoFromLibrary(_ sender: UIButton) { // 비디오 불러오기
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
        flagImageSave = false
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    else {
        myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }
    }
    // 사진, 비디오 촬영이나 선택이 끝났을 떄 호출되는 델리게이트 메서드
    func imagePickerController(_ Picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        // 미디어 종류 확인
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            captureImage = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage
            //미디어가 사진일 때
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            
            imgView.image = captureImage
            
        }
            //미디어가 비디오 일 때
            else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
                if flagImageSave {
                    videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
                    //디비오를 포토 라이브러리에 저장
                    UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
                }
            }
            self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 경고창 출력 함수
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

