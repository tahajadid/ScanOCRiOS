//
//  PreveiwViewController.swift
//  inwiOCR
//
//  Created by taha_jadid on 14/4/2022.
//

import UIKit

class PreveiwViewController: UIViewController, UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let mView = TestCamera()
        mView.delegate = self
        if let rect = self.imagePicker.cameraOverlayView?.frame {
            mView.frame = rect
        }
        imagePicker.cameraOverlayView = mView
        
        
    }

}

// MARK: - image picker
extension PreveiwViewController: UIImagePickerControllerDelegate {
    
    
    /*
     This function will resize and upload the image
     */
//    func resizeAndUplaodImage(img: UIImage, isRecto: Bool, completion: @escaping((UIImage?) -> Void)) {
//        // let diff = 450 / img.size.height
//        // let img = img.imageWith(newSize: .init(width: img.size.width - 500, height: img.size.height  - 500))
//        // let img = img.sd_croppedImage(with: CGRect(x: 10.0, y: 0, width: 394, height: 248.5))
//        let img = self.cropToBounds(image: img, width: 100, height: 100)
//
//        self.getOcrDataByImg(img: img, isRecto: isRecto, completion: { model in
//            guard model != nil else {
//                completion(nil)
//                return
//            }
//            if isRecto {
//                self.tokenRectro = model?.ocrToken ?? ""
//                self.tokenRectro = self.tokenRectro.isEmpty ? Constants.staticOcrToken : self.tokenRectro
//                self.userModelData = model?.toInformationModel()
//                let offerModel = DataBaseHelper.sharedInstance.getSelectedOffer()
//                self.userModelData?.offerProfileId = offerModel?.profile ?? ""
//                self.userModelData?.currentOfferName = offerModel?.offerName ?? ""
//                self.userModelData?.currentOfferType = offerModel?.offerType ?? ""
//                self.userModelData?.number = DataBaseHelper.sharedInstance.getSelectedUsername()
//            } else {
//                self.userModelData = model?.toInformationModel()
//                let offerModel = DataBaseHelper.sharedInstance.getSelectedOffer()
//                self.userModelData?.offerProfileId = offerModel?.profile ?? ""
//                self.userModelData?.currentOfferName = offerModel?.offerName ?? ""
//                self.userModelData?.currentOfferType = offerModel?.offerType ?? ""
//                self.userModelData?.number = DataBaseHelper.sharedInstance.getSelectedUsername()
//                self.userModelData?.type = self.typeScanCapture
//            }
//            self.postDataIdentification = self.userModelData
//            completion(img)
//        })
//    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    /*
     Func to open camera
     */
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.buildImagePickerInstance()
            self.present(imagePicker, animated: true)
        }
    }
    
    /*
     This function to initialize capture image rect
     */
    func buildImagePickerInstance() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.allowsEditing = true
        imagePicker.showsCameraControls = false
        
        let mView = TestCamera()
        mView.delegate = self
        if let rect = self.imagePicker.cameraOverlayView?.frame {
            mView.frame = rect
        }
        imagePicker.cameraOverlayView = mView
        
        let screenSize = UIScreen.main.bounds.size
        let ratio: CGFloat = 4.0 / 3.0
        let cameraHeight: CGFloat = screenSize.width * ratio
        let scale: CGFloat = screenSize.height / cameraHeight
        
        self.imagePicker.cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenSize.height - cameraHeight) / 2.0)
        self.imagePicker.cameraViewTransform = self.imagePicker.cameraViewTransform.scaledBy(x: scale, y: scale)
        
        let heightCapture = UIScreen.main.bounds.width *  0.6
        let topSpace = UIScreen.main.bounds.height * 0.13
        
    }

}

extension PreveiwViewController: CameraFrontViewDelegate {
    func onClickCaptureButtonCamera() {
        self.imagePicker.takePicture()
    }
    
    func onClickBackButtonCamera() {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}
