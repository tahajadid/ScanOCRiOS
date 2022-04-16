//
//  CameraFrontView.swift
//  MyInwi
//
//  Created by Khalil Maaref on 9/12/2021.
//


import UIKit

protocol CameraFrontViewDelegate: AnyObject {
    func onClickBackButtonCamera()
    func onClickCaptureButtonCamera()
}

class TestCamera: UIView {
    
    weak var delegate: CameraFrontViewDelegate?
    var framee: CGRect = .zero
    var backImg: UIImageView = {
        let mView = UIImageView()
        mView.image = UIImage(named: "BAckPInk")?.withRenderingMode(.alwaysTemplate)
        mView.tintColor = .white
        mView.contentMode = .left
        mView.transform = CGAffineTransform.identity
        mView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return mView
    }()
    
    var lbTitle: UILabel = {
        let mView = UILabel()
        mView.textColor = .white
        mView.font = .systemFont(ofSize: 18)
        mView.textAlignment = .center
        mView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        mView.clipsToBounds = false
        return mView
    }()
    
    let mainPageStack: UIStackView = {
        let mStackView = UIStackView()
        mStackView.distribution = .fill
        mStackView.alignment = .fill
        mStackView.axis = .vertical
        mStackView.spacing = 0

        return mStackView
    }()
    
    let captureZoneStack: UIStackView = {
        let mStackView = UIStackView()
        mStackView.distribution = .equalSpacing
        mStackView.alignment = .fill
        mStackView.axis = .horizontal
        mStackView.spacing = 0

        return mStackView
    }()
    
    let captureZoneView: UIView = {
        let mView = UIView()
        mView.backgroundColor = .clear
        return mView
    }()
    
    var isRecto: Bool = false
    

    let mView = UIView()

    override func draw(_ rect: CGRect) {
        self.removeSubViews()
        
        let topView = drawTopView()
        
        let botView = drawBotView()
        
        let rightLineView = drawBgView()
        let leftLineView = drawBgView()
        
        rightLineView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        leftLineView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        mView.backgroundColor = .clear
        
        let imgBg = UIImageView()
        imgBg.image = "border-scan".makeNamedImage()
        imgBg.contentMode = .scaleAspectFit
        
        imgBg.fixConstraintsToView(mView, positionType: .margin, top: 0, right: 0, bottom: 0, left: 0)
        
        captureZoneStack.addArrangedSubview(leftLineView)
        captureZoneStack.addArrangedSubview(mView)
        captureZoneStack.addArrangedSubview(rightLineView)
        
        let heightCapture = UIScreen.main.bounds.width *  0.6
        mView.heightAnchor.constraint(equalToConstant: heightCapture).isActive = true
        
        mainPageStack.addArrangedSubview(topView)
        mainPageStack.addArrangedSubview(captureZoneStack)
        mainPageStack.addArrangedSubview(botView)
        
        mainPageStack.fixConstraintsToView(self, positionType: .margin, top: 0, right: 0, bottom: 0, left: 0)
    }
    
    func resetTextLabels() {
        
    }
    
    func drawTopView() -> UIView {
        let topView = drawBgView()
        let heightTop = UIScreen.main.bounds.height * 0.13
        let constHeight = topView.heightAnchor.constraint(equalToConstant: heightTop)
        constHeight.priority = .defaultLow
        constHeight.isActive = true
        
        let heightCapture = UIScreen.main.bounds.width * 0.6
        let const = topView.heightAnchor.constraint(lessThanOrEqualToConstant: heightCapture)
        const.priority = .defaultHigh
        const.isActive = true
        
        self.backImg.fixConstraintsToView(topView, positionType: .margin, top: 26, right: nil, bottom: nil, left: 16)
        self.lbTitle.fixConstraintsToView(topView, positionType: .margin, top: nil, right: nil, bottom: 20, left: nil)
        self.lbTitle.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0).isActive = true
        self.lbTitle.text = "Recto Test"
        
        self.backImg.setOnClickListener(target: self, action: #selector(onClickBackButton))
        
        return topView
    }
    
    func drawBotView() -> UIView {
        let botView = drawBgView()
        
        let imgCapture = UIImageView()
        imgCapture.image = "img_button_capture".makeNamedImage()
        imgCapture.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imgCapture.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imgCapture.setOnClickListener(target: self, action: #selector(onClickConfirmButton))
        
        imgCapture.fixConstraintsToView(botView, positionType: .margin, top: nil, right: nil, bottom: 26, left: nil)
        imgCapture.centerXAnchor.constraint(equalTo: botView.centerXAnchor, constant: 0).isActive = true
        
        let mStackView = UIStackView()
        mStackView.distribution = .fillEqually
        mStackView.alignment = .fill
        mStackView.axis = .vertical
        mStackView.spacing = 3
        
        mStackView.fixConstraintsToView(botView, positionType: .margin, top: 10, right: 20, bottom: nil, left: 26)
        mStackView.bottomAnchor.constraint(equalTo: imgCapture.topAnchor, constant: -40).isActive = true
        
        let pairList = [
            "(Constants.imgNamedGalleryCapture, LocalizedConst.lbl029)",
            "(Constants.imgNamedTableCapture, LocalizedConst.lbl030)",
            "(Constants.imgNamedCameraCapture, LocalizedConst.lbl031)"
        ]
        pairList.forEach { pair in
            mStackView.addArrangedSubview(generateSingleLine(imgNamed: pair, name: pair))
        }
        
        return botView
    }
    
    func generateSingleLine(imgNamed: String, name: String) -> UIView {
        let mView = UIView()
        
        let imgView = UIImageView()
        imgView.image = imgNamed.makeNamedImage()?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .white
        imgView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        imgView.fixConstraintsToView(mView, positionType: .margin, top: 5, right: nil, bottom: 5, left: 5)
        
        let lbName = UILabel()
        lbName.font = .systemFont(ofSize: 14)
        lbName.textColor = .white
        lbName.numberOfLines = 3
        //lbName.setLabelValue(key: name, fontType: .semiBold)
        lbName.text = "Test Content"
        lbName.fixConstraintsToView(mView, positionType: .margin, top: 3, right: 5, bottom: 3, left: nil)
        lbName.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        
        mView.heightAnchor.constraint(lessThanOrEqualToConstant: 70).isActive = true
        mView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        return mView
    }
    
    func drawBgView() -> UIView {
        let mView = UIView()
        mView.backgroundColor =  UIColor.init(hexString: "#D0888888")
        return mView
    }
    
    @objc func onClickBackButton(_ tap: UITapGestureRecognizer) {
        self.delegate?.onClickBackButtonCamera()
    }
    
    @objc func onClickConfirmButton(_ tap: UITapGestureRecognizer) {
        self.framee = (mView.superview?.convert(mView.frame, to: nil))!
        self.delegate?.onClickCaptureButtonCamera()
    }
}
