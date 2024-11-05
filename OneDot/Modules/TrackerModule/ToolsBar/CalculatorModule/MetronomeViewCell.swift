//
//  MetronomeViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2024.
//

import UIKit
import AVFoundation
import AudioToolbox

class MetronomeViewCell: UITableViewCell {
    
    private let metronomeBeatsSet = MetronomeBeatsSet()
    
    private var metronomePlayer: AVAudioPlayer?
    private var metronomeTimer: Timer?
    private var metronomeState: Bool = false
    private var silentState: Bool = false
    
    var calculatorVCBPMCmpletion: ((Bool) -> Void)?
    var mainVCBPMCompletion: ((Bool) -> Void)?

    private let feedbackGen = UIImpactFeedbackGenerator(style: .heavy)
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.currentColorSet.mainSelectorColor
        view.layer.cornerRadius = CGFloat.toolCorner
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let sliderContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.currentColorSet.mainSelectorColor
        return view
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 240
        slider.minimumValue = 120
        slider.value = Float(UserDefaultsManager.shared.bpmState)
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .white
        return slider
    }()
    
    private let bpmMinusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "soundBpmAwayIcon"), for: .normal)
        button.setImage(UIImage(named: "soundBpmAwayIcon"), for: .highlighted)
        button.backgroundColor = UIColor.currentColorSet.mainSelectorColor
        return button
    }()
    
    private let bpmPlusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "soundBpmAddIcon"), for: .normal)
        button.setImage(UIImage(named: "soundBpmAddIcon"), for: .highlighted)
        button.backgroundColor = UIColor.currentColorSet.mainSelectorColor
        return button
    }()
    
    private let bottomButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.backgroundColor = UIColor.currentColorSet.mainSelectorColor
        stack.layer.cornerRadius = CGFloat.toolCorner
        stack.layer.cornerCurve = .continuous
        stack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return stack
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let pickerVisualView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        view.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        view.clipsToBounds = true
        view.layer.cornerRadius = CGFloat.barCorner
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    private let beatChangePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        return picker
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "toolBarCheckMarkIcon"), for: .normal)
        return button
    }()
    
    private let beatChangeButton: UIButton = UIButton()
    private let playStateButton: UIButton = UIButton()
    private let soundStateButton: UIButton = UIButton()
    
    private let bpmTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy, width: .compressed)
        label.textColor = .white
        label.text = String(UserDefaultsManager.shared.bpmState)
        return label
    }()
    
    private let leftSeparator: CAShapeLayer = CAShapeLayer()
    private let rightSeparator: CAShapeLayer = CAShapeLayer()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        beatChangePicker.delegate = self
        beatChangePicker.dataSource = self
        
        setViews()
        setConstraints()
        metronomeInit(beatName: metronomeBeatsSet.names[UserDefaultsManager.shared.beatState])
        
        slider.addTarget(self, action: #selector(setSliderValue), for: .valueChanged)
        bpmPlusButton.addTarget(self, action: #selector(bpmPlusValue), for: .touchUpInside)
        bpmMinusButton.addTarget(self, action: #selector(bpmMinusValue), for: .touchUpInside)
        
        playStateButton.addTarget(self, action: #selector(timerStart), for: .touchUpInside)
        soundStateButton.addTarget(self, action: #selector(setSilentState), for: .touchUpInside)
        beatChangeButton.addTarget(self, action: #selector(changeBeatSound), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
    }
   
    
    //MARK: - MetronomeInstance
    
    @objc private func setSilentState() {
        if silentState == false {
            silentState.toggle()
            soundStateButton.setImage(UIImage(named: "soundActiveIcon"), for: .normal)
        } else {
            silentState.toggle()
            soundStateButton.setImage(UIImage(named: "soundInactiveIcon"), for: .normal)
        }
    }
    
    private func metronomeInit(beatName: String) {
        guard let path = Bundle.main.path(forResource: beatName, ofType: "wav") else { return }
        let url = URL(fileURLWithPath: path)
        beatChangePicker.selectRow(UserDefaultsManager.shared.beatState, inComponent: 0, animated: true)
        
        do {
            self.metronomePlayer = try AVAudioPlayer(contentsOf: url)
            self.metronomePlayer?.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    @objc private func setSliderValue() {
        if metronomeState == true {
            bpmTitle.text = "\(Int(slider.value))"
            UserDefaultsManager.shared.bpmState = Int(slider.value)
            valueChanged(value: Int(60 / slider.value))
        } else {
            bpmTitle.text = "\(Int(slider.value))"
            UserDefaultsManager.shared.bpmState = Int(slider.value)
        }
        
    }
    
    @objc private func bpmPlusValue() {
        if metronomeState == true {
            let currentValue = slider.value
            slider.value = currentValue + 1
            bpmTitle.text = "\(Int(slider.value))"
            UserDefaultsManager.shared.bpmState = Int(slider.value)
            valueChanged(value: Int(60 / slider.value))
        } else {
            let currentValue = slider.value
            slider.value = currentValue + 1
            bpmTitle.text = "\(Int(slider.value))"
            UserDefaultsManager.shared.bpmState = Int(slider.value)
        }
    }
    
    @objc private func bpmMinusValue() {
        if metronomeState == true {
            let currentValue = slider.value
            slider.value = currentValue - 1
            bpmTitle.text = "\(Int(slider.value))"
            UserDefaultsManager.shared.bpmState = Int(slider.value)
            valueChanged(value: Int(60 / slider.value))
        } else {
            let currentValue = slider.value
            slider.value = currentValue - 1
            bpmTitle.text = "\(Int(slider.value))"
            UserDefaultsManager.shared.bpmState = Int(slider.value)
        }
        
    }
    
    @objc private func timerStart() {
        if metronomeState == false {
            metronomeState = true
            metronomeTimer = Timer.scheduledTimer(timeInterval:
                                  TimeInterval(Double(60) /  Double(UserDefaultsManager.shared.bpmState)),
                                  target: self,
                                  selector: #selector(metronomePlay),
                                  userInfo: nil,
                                  repeats: true)
            playStateButton.setImage(UIImage(named: "soundPauseIcon"), for: .normal)
        } else {
            metronomeState = false
            metronomeTimer?.invalidate()
            playStateButton.setImage(UIImage(named: "soundPlayIcon"), for: .normal)
            calculatorVCBPMCmpletion?(false)
            mainVCBPMCompletion?(false)
        }
    }
    
    private func valueChanged(value: Int) {
        metronomeTimer?.invalidate()
        calculatorVCBPMCmpletion?(false)
        mainVCBPMCompletion?(false)
        metronomeTimer = Timer.scheduledTimer(timeInterval:
                              TimeInterval(Double(60) /  Double(UserDefaultsManager.shared.bpmState)),
                              target: self,
                              selector: #selector(metronomePlay),
                              userInfo: nil,
                              repeats: true)
    }
    
    @objc private func metronomePlay() {
           calculatorVCBPMCmpletion?(true)
           mainVCBPMCompletion?(true)
        if silentState == false {
            metronomePlayer?.currentTime = 0.0
            metronomePlayer?.play()
        } else {
            feedbackGen.impactOccurred()
        }
    }
    
    
    //MARK: - BeatChanges
    
    @objc private func changeBeatSound() {
        textField.becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        endEditing(true)
    }

    
    //MARK: UpdateColors
    
    func updateColors(set: ColorSetProtocol) {
        topView.backgroundColor = set.mainSelectorColor
        sliderContainerView.backgroundColor = set.mainSelectorColor
        bpmMinusButton.backgroundColor = set.mainSelectorColor
        bpmPlusButton.backgroundColor = set.mainSelectorColor
        bottomButtonsStack.backgroundColor = set.mainSelectorColor
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        contentView.addSubview(sliderContainerView)
        contentView.addSubview(topView)
        contentView.addSubview(bpmTitle)
        sliderContainerView.addSubview(slider)
        contentView.addSubview(bpmMinusButton)
        contentView.addSubview(bpmPlusButton)
        
        bottomButtonsStack.addArrangedSubview(beatChangeButton)
        bottomButtonsStack.addArrangedSubview(playStateButton)
        bottomButtonsStack.addArrangedSubview(soundStateButton)
        
        beatChangeButton.setImage(UIImage(named: "soundBeatChangeIcon"), 
                                  for: .normal)
        beatChangeButton.setImage(UIImage(named: "soundBeatChangeIcon"), 
                                  for: .highlighted)
        playStateButton.setImage(UIImage(named: "soundPlayIcon"),
                                  for: .normal)
        playStateButton.setImage(UIImage(named: "soundPlayIcon"),
                                  for: .highlighted)
        soundStateButton.setImage(UIImage(named: "soundInactiveIcon"),
                                  for: .normal)
        soundStateButton.setImage(UIImage(named: "soundInactiveIcon"),
                                  for: .highlighted)
        
        contentView.addSubview(bottomButtonsStack)
        bottomButtonsStack.addSubview(textField)
        
        textField.inputView = UIView()
        textField.inputAccessoryView = pickerVisualView
        pickerVisualView.contentView.addSubview(beatChangePicker)
        pickerVisualView.contentView.addSubview(doneButton)

        
        Shaper.shared.drawYSeparator(shape: leftSeparator,
                                     view: bottomButtonsStack,
                                     x: CGFloat.toolwidth / 3,
                                     y: 15,
                                     length: 30,
                                     color: .white)
        
        Shaper.shared.drawYSeparator(shape: rightSeparator,
                                     view: bottomButtonsStack,
                                     x: CGFloat.toolwidth / 3 * 2,
                                     y: 15,
                                     length: 30,
                                     color: .white)
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            topView.widthAnchor.constraint(equalToConstant:
                                            CGFloat.toolwidth),
            topView.heightAnchor.constraint(equalToConstant: 60),
            topView.centerXAnchor.constraint(equalTo:
                                            sliderContainerView.centerXAnchor),
            
            
            sliderContainerView.widthAnchor.constraint(equalToConstant:
                                            CGFloat.toolwidth - 120),
            sliderContainerView.heightAnchor.constraint(equalToConstant: 60),
            sliderContainerView.centerXAnchor.constraint(equalTo:
                                            contentView.centerXAnchor),
            sliderContainerView.topAnchor.constraint(equalTo:
                                            topView.bottomAnchor),
            
            bpmTitle.centerXAnchor.constraint(equalTo: 
                                            topView.centerXAnchor),
            bpmTitle.centerYAnchor.constraint(equalTo:
                                                topView.centerYAnchor),
            
            slider.widthAnchor.constraint(equalToConstant: CGFloat.toolwidth - 130),
            slider.centerXAnchor.constraint(equalTo:
                                            sliderContainerView.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo:
                                            sliderContainerView.centerYAnchor),
            
            bpmMinusButton.widthAnchor.constraint(equalToConstant: 60),
            bpmMinusButton.heightAnchor.constraint(equalToConstant: 60),
            bpmMinusButton.centerYAnchor.constraint(equalTo: slider.centerYAnchor),
            bpmMinusButton.trailingAnchor.constraint(equalTo:
                                            sliderContainerView.leadingAnchor),
            
            bpmPlusButton.widthAnchor.constraint(equalToConstant: 60),
            bpmPlusButton.heightAnchor.constraint(equalToConstant: 60),
            bpmPlusButton.centerYAnchor.constraint(equalTo: slider.centerYAnchor),
            bpmPlusButton.leadingAnchor.constraint(equalTo:
                                            sliderContainerView.trailingAnchor),
            
            bottomButtonsStack.widthAnchor.constraint(equalToConstant: 
                                            CGFloat.toolwidth),
            bottomButtonsStack.heightAnchor.constraint(equalToConstant: 60),
            bottomButtonsStack.centerXAnchor.constraint(equalTo:
                                            sliderContainerView.centerXAnchor),
            bottomButtonsStack.topAnchor.constraint(equalTo:
                                            sliderContainerView.bottomAnchor),
            
            textField.widthAnchor.constraint(equalToConstant: 0),
            textField.heightAnchor.constraint(equalToConstant: 0),
            textField.centerXAnchor.constraint(equalTo: bottomButtonsStack.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: bottomButtonsStack.centerYAnchor),
            
            doneButton.widthAnchor.constraint(equalToConstant: 50),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.topAnchor.constraint(equalTo: 
                                            pickerVisualView.topAnchor,
                                            constant: 15),
            doneButton.trailingAnchor.constraint(equalTo: 
                                            pickerVisualView.trailingAnchor,
                                            constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MetronomeViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        metronomeBeatsSet.names.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium, width: .compressed)
        

        label.text = "\(metronomeBeatsSet.names[row])"

       
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaultsManager.shared.beatState = row
        metronomeInit(beatName: metronomeBeatsSet.names[row])
    }
    
}
