//
//  ViewController.swift
//  inwiOCR
//
//  Created by taha_jadid on 9/4/2022.
//

import MLImage
import MLKit
import UIKit
import Vision

/// Main view controller class.
@objc(ViewController)
class ViewController: UIViewController, UINavigationControllerDelegate{
    
    @IBOutlet weak var openCameraTB: UIToolbar!
    @IBOutlet weak var detectButton: UIBarButtonItem!

    @IBOutlet weak var simBtn: UIButton!
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var versoBtn: UIButton!
    @IBOutlet weak var rectoBtn: UIButton!
    
    @IBOutlet weak var tblForm: UITableView!
    
    /// An image picker for accessing the photo library or camera.
    var imagePicker = UIImagePickerController()

    
    /// An overlay view that displays detection annotations.
    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      annotationOverlayView.clipsToBounds = true
      return annotationOverlayView
    }()
    
    /// A string holding current results from detection.
    var resultsText = ""

    // Image counter.
    var currentImage = 0
    
    var listResult = [String]()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Navigation controller
        navigationController?.isNavigationBarHidden = true

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(false)
        
        imageView.image = UIImage(named: Constants.images[currentImage])
        imageView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
          annotationOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
          annotationOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
          annotationOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
          annotationOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary


    }


    @IBAction func detectButton(_ sender: Any) {
        self.resultsText = ""
        detectTextOnDevice(image: imageView.image)

    }
    
    @IBAction func goScanBtn(_ sender: UIButton) {
        self.navigationController?.pushViewController(PreveiwViewController(), animated: true)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        
        guard
          UIImagePickerController.isCameraDeviceAvailable(.front)
            || UIImagePickerController
              .isCameraDeviceAvailable(.rear)
        else {
          return
        }
        
//        imagePicker.sourceType = .camera
        
        
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
        
        //let heightCapture = UIScreen.main.bounds.width *  0.6
        //let topSpace = UIScreen.main.bounds.height * 0.13
        
        present(imagePicker, animated: true)

        
    }
    
    @IBAction func openLibraryPhoto(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func rectoBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            versoBtn.isSelected = false
            passBtn.isSelected = false
            simBtn.isSelected = false
        } else {
            sender.isSelected = true
            versoBtn.isSelected = false
            passBtn.isSelected = false
            simBtn.isSelected = false
        }
    }
    
    
    @IBAction func versoBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            rectoBtn.isSelected = false
            passBtn.isSelected = false
            simBtn.isSelected = false
        } else {
            sender.isSelected = true
            rectoBtn.isSelected = false
            passBtn.isSelected = false
            simBtn.isSelected = false
        }
    }
    
    @IBAction func passBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            versoBtn.isSelected = false
            rectoBtn.isSelected = false
            simBtn.isSelected = false
        } else {
            sender.isSelected = true
            versoBtn.isSelected = false
            rectoBtn.isSelected = false
            simBtn.isSelected = false
        }
    }
    
    @IBAction func simBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            versoBtn.isSelected = false
            rectoBtn.isSelected = false
            passBtn.isSelected = false
        } else {
            sender.isSelected = true
            versoBtn.isSelected = false
            rectoBtn.isSelected = false
            passBtn.isSelected = false
        }
    }
    
    
    
    
    func myCrop(image : UIImage) -> UIImage {
        
        
        
        // change this value as you want!
        let rectToCrop = CGRect(x: 130, y: 300, width: 150, height: 300)
        let croppedImage: UIImage
        
        let factor = imageView.frame.width/image.size.width
        let rect = CGRect(x: rectToCrop.origin.x / factor, y: rectToCrop.origin.y / factor, width: rectToCrop.width / factor, height: rectToCrop.height / factor)
        croppedImage = cropImage1(image: image, rect: rect)
       
        
        //let originalFrame = imageView.frame
        //let croppedFrame = CGRect(x: originalFrame.origin.x + rectToCrop.origin.x, y: originalFrame.origin.y + rectToCrop.origin.y, width: rectToCrop.width, height: rectToCrop.height)
        
        return croppedImage
        
    }
    
    func cropImage1(image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!, scale: image.scale, orientation: image.imageOrientation)
    }
    
    
    
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
    
    /// Clears the results text view and removes any frames that are visible.
    private func clearResults() {
      self.resultsText = ""
    }
    
    private func showResults(message : String) {
      let resultsAlertController = UIAlertController(
        title: "Résultats du scan cin",
        message: nil,
        preferredStyle: .actionSheet
      )
      resultsAlertController.addAction(
        UIAlertAction(title: "Cancel", style: .destructive) { _ in
          resultsAlertController.dismiss(animated: true, completion: nil)
        }
      )
      resultsAlertController.message = message
      resultsAlertController.popoverPresentationController?.barButtonItem = detectButton
      resultsAlertController.popoverPresentationController?.sourceView = self.view
      present(resultsAlertController, animated: true, completion: nil)
      print(resultsText)
    }
    
    /// Updates the image view with a scaled version of the given image.
    private func updateImageView(with image: UIImage) {
      let orientation = UIApplication.shared.statusBarOrientation
      var scaledImageWidth: CGFloat = 0.0
      var scaledImageHeight: CGFloat = 0.0
      switch orientation {
      case .portrait, .portraitUpsideDown, .unknown:
        scaledImageWidth = imageView.bounds.size.width
        scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
      case .landscapeLeft, .landscapeRight:
        scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
        scaledImageHeight = imageView.bounds.size.height
      @unknown default:
        fatalError()
      }
      weak var weakSelf = self
      DispatchQueue.global(qos: .userInitiated).async {
        // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
        var scaledImage = image.scaledImage(
          with: CGSize(width: scaledImageWidth, height: scaledImageHeight)
        )
        scaledImage = scaledImage ?? image
        guard let finalImage = scaledImage else { return }
        DispatchQueue.main.async {
          weakSelf?.imageView.image = finalImage
        }
      }
    }
    
    func process(_ visionImage: VisionImage, with textRecognizer: TextRecognizer?) {
        weak var weakSelf = self
        listResult = [String]()

        textRecognizer?.process(visionImage) { text, error in
          guard let strongSelf = weakSelf else {
            print("Self is nil!")
            return
          }
          guard error == nil, let text = text else {
            let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
            strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
            strongSelf.showResults(message: "noth..")
            return
          }
          // Blocks.
          for block in text.blocks {

            // Lines.
            for line in block.lines {

              // Elements.
              for element in line.elements {

                strongSelf.resultsText += element.text + " "
                strongSelf.listResult.append(element.text)
              
              }
            }
              strongSelf.resultsText += "\n"
          }
            
            self.parseDataToShow(list : strongSelf.listResult)

        }
      }
    
    
      
      func parseDataToShow(list : [String]){
          
          if(self.versoBtn.isSelected){
              // if user select the recto face
              print(self.resultsText)
              self.resultsText = ScanInformationCin().filterResultCinVerso(result: self.listResult)
              self.showResults(message :self.resultsText)
              
          }else if (self.rectoBtn.isSelected){
              // if user select the verso face
              self.resultsText = ScanInformationCin().filterResultCinRecto(result: self.listResult)
              self.showResults(message :self.resultsText)
              
          }else if (self.passBtn.isSelected){
              // if user select the passport scan
              self.resultsText = ScanInformationPassport().filterResultPassport(result: self.listResult)
              self.showResults(message :self.resultsText)
              
          }else if (self.simBtn.isSelected){
              // if user select the passport scan
              self.resultsText = ScanInformationSim().filterResultSim(result: self.listResult)
              self.showResults(message :self.resultsText)
              
          }else {
              // if nothing selected
              self.showResults(message :self.resultsText)
          }
      }
      
  }


  // MARK: - UIImagePickerControllerDelegate

  extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      // Local variable inserted by Swift 4.2 migrator.
      let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

      clearResults()
      if let pickedImage =
        info[
          convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]
        as? UIImage
      {
//          let newpic = cropToBounds(image: pickedImage, width: 100.0, height: 100.0)
          let newpic = myCrop(image: pickedImage)
          self.imageView.image = newpic
          updateImageView(with: newpic)
      }
      dismiss(animated: true)
        
      // Auto detection after finishing picking the image
      self.resultsText = ""
      detectTextOnDevice(image: imageView.image)
        
    }
  }


  // MARK: - Detection
  /// Extension of ViewController for On-Device detection.
  extension ViewController {


    /// Detects text on the specified image and draws a frame around the recognized text using the text recognizer.
    ///
    /// - Parameter image: The image.
    private func detectTextOnDevice(image: UIImage?) {
      guard let image = image else { return }
      let textRecognizer = TextRecognizer.textRecognizer()

      // Initialize a `VisionImage` object with the given `UIImage`.
      let visionImage = VisionImage(image: image)
      visionImage.orientation = image.imageOrientation

      self.resultsText += "Running Text Recognition...\n"
        
      process(visionImage, with: textRecognizer)
      
  }
      
    
}

//MARK: - Constants
private enum Constants {
  // static let images = ["image_has_text.jpg"]
  
  static let images = ["sim_card.jpg"]
  static let detectionNoResultsMessage = "No results returned."
  static let failedToDetectObjectsMessage = "Failed to detect objects in image."
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
  _ input: [UIImagePickerController.InfoKey: Any]
) -> [String: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey)
  -> String
{
  return input.rawValue
}

extension ViewController: CameraFrontViewDelegate {
    func onClickCaptureButtonCamera() {
        self.imagePicker.takePicture()
    }
    
    func onClickBackButtonCamera() {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}

