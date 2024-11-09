//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class TabBar: UIView {
    
    let feedbackGen = UISelectionFeedbackGenerator()
    var trackingStatus: Bool = false
    
    //MARK: - LeftButtons
    
    let prepareButton: UIButton = UIButton()
    let startButton: UIButton = UIButton()
    let startImageView: UIImageView = UIImageView()
    let pauseImageView: UIImageView = UIImageView()
    let pauseButton: UIButton = UIButton()
    
    //MARK: - RightButtons
    
    let profileButton: UIButton = UIButton()
    let cancelButton: UIButton = UIButton()
    let finishButton: UIButton = UIButton()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        setButtons()
        
        Shaper.shared.drawYSeparator(shape: separator,
                                             view: self,
                                             x: CGFloat.trackerBarWidth / 2,
                                             y: 15,
                                             length: 65,
                                             color: .white)
    }
    
    
       //MARK: - SetButtons
       
       private func setButtons() {
           
           
           
           startButton.isHidden = true
           pauseButton.isHidden = true
           cancelButton.isHidden = true
           finishButton.isHidden = true
           
           startButton.addTarget(self,
                                        action: #selector(startButtonTapped),
                                        for: .touchUpInside)
           
           pauseButton.addTarget(self,
                                        action: #selector(pauseButtonTapped),
                                        for: .touchUpInside)
           
           prepareButton.addTarget(self,
                                       action: #selector(prepareButtonTapped),
                                       for: .touchUpInside)
           
           profileButton.addTarget(self, action:
                                        #selector(profileButtonTapped),
                                        for: .touchUpInside)
           
           cancelButton.addTarget(self,
                                         action: #selector(cancelButtonTapped),
                                         for: .touchUpInside)
           
           finishButton.addTarget(self,
                                         action: #selector(finishButtonTapped),
                                         for: .touchUpInside)
       }
       
       
       //MARK: - ButtonsFunctions
       
       @objc private func prepareButtonTapped() {
           print("prepare")
           feedbackGen.selectionChanged()
           
           prepareButton.isHidden = true
           startButton.isHidden = false
           profileButton.isHidden = true
           cancelButton.isHidden = false
           Animator.shared.AnimateStartButton(startImageView)
       }
       
       @objc private func startButtonTapped() {
           print("start")
           feedbackGen.selectionChanged()
           
           startButton.isHidden = true
           cancelButton.isHidden = true
           pauseButton.isHidden = false
           finishButton.isHidden = false
           startImageView.layer.removeAllAnimations()
       }
       
       @objc private func pauseButtonTapped() {
           print("pause")
           feedbackGen.selectionChanged()
           
           if !trackingStatus {
               pauseButton.setImage(UIImage(named: "tabBarStartIcon"), for: .normal)
               pauseButton.setImage(UIImage(named: "tabBarStartIcon"), for: .highlighted)
               Animator.shared.AnimateStartButton(pauseImageView)
               trackingStatus.toggle()
           } else {
               pauseButton.setImage(UIImage(named: "tabBarPauseIcon"), for: .normal)
               pauseButton.setImage(UIImage(named: "tabBarPauseIcon"), for: .highlighted)
               pauseImageView.layer.removeAllAnimations()
               trackingStatus.toggle()
           }
           
       }
       
       @objc private func profileButtonTapped() {
           print("profile")
           
           isUserInteractionEnabled = false
           
          
       }
       
       @objc func cancelButtonTapped() {
           print("cancel")
           feedbackGen.selectionChanged()
           
           startButton.isHidden = true
           cancelButton.isHidden = true
           prepareButton.isHidden = false
           profileButton.isHidden = false
       }
       
       @objc func finishButtonTapped() {
           print("finish")
           feedbackGen.selectionChanged()
           
           pauseButton.isHidden = true
           finishButton.isHidden = true
           prepareButton.isHidden = false
           profileButton.isHidden = false
       }
    
    //MARK: - SetViews
    
    private func setViews() {
        layer.cornerRadius = .tabBarCorner
        layer.cornerCurve = .continuous
        addSubview(prepareButton)
        addSubview(startButton)
        startButton.addSubview(startImageView)
        pauseButton.addSubview(pauseImageView)
        pauseImageView.alpha = 0
        addSubview(pauseButton)
        
        addSubview(profileButton)
        addSubview(cancelButton)
        addSubview(finishButton)
        
        startImageView.image = UIImage(named: "tabBarStartIconRed")
        pauseImageView.image = UIImage(named: "tabBarStartIconRed")
        
        prepareButton.setImage(UIImage(named: "tabBarStartIcon"), for: .normal)
        prepareButton.setImage(UIImage(named: "tabBarStartIcon"), for: .highlighted)
        startButton.setImage(UIImage(named: "tabBarStartIcon"), for: .normal)
        startButton.setImage(UIImage(named: "tabBarStartIcon"), for: .highlighted)
        pauseButton.setImage(UIImage(named: "tabBarPauseIcon"), for: .normal)
        pauseButton.setImage(UIImage(named: "tabBarPauseIcon"), for: .highlighted)
        
        profileButton.setImage(UIImage(named: "tabBarProfileIcon"), for: .normal)
        profileButton.setImage(UIImage(named: "tabBarProfileIcon"), for: .highlighted)
        cancelButton.setImage(UIImage(named: "tabBarCancelIcon"), for: .normal)
        cancelButton.setImage(UIImage(named: "tabBarCancelIcon"), for: .highlighted)
        finishButton.setImage(UIImage(named: "tabBarStopIcon"), for: .normal)
        finishButton.setImage(UIImage(named: "tabBarStopIcon"), for: .highlighted)
        
        
    }
    
    
    //MARK: - SetConstrains
    
    private func setConstraints() {
        prepareButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        startImageView.translatesAutoresizingMaskIntoConstraints = false
        pauseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraintsForLeftButton(prepareButton)
        setConstraintsForLeftButton(startButton)
        setConstraintsForLeftButton(pauseButton)
        
        setConstraintsForRightButton(profileButton)
        setConstraintsForRightButton(cancelButton)
        setConstraintsForRightButton(finishButton)
        
        setConstraintsForImageView(startImageView)
        setConstraintsForImageView(pauseImageView)
        
       
    }
    
    private func setConstraintsForLeftButton(_ button: UIButton) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: CGFloat.trackerBarWidth / 2),
            button.heightAnchor.constraint(equalToConstant: 95),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
    
    private func setConstraintsForRightButton(_ button: UIButton) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: CGFloat.trackerBarWidth / 2),
            button.heightAnchor.constraint(equalToConstant: 95),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func  setConstraintsForImageView(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                               constant: -CGFloat.trackerBarWidth / 4),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
