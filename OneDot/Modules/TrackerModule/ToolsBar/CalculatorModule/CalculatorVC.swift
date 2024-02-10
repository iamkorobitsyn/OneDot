//
//  CalculatorViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.11.2023.
//

import UIKit

class CalculatorVC: UIViewController {
    
    private let calculateShowButton: UIButton = UIButton()
    private let heartZoneShowButton: UIButton = UIButton()
    private let metronomeShowButton: UIButton = UIButton()
    
    private let bpmLight: CAShapeLayer = CAShapeLayer()
    private let bpmViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var buttonList: [UIButton] = []
    
    let calculationsCell = CalculationsViewCell()
    let heartZonesCell = HeartZonesViewCell()
    let metronomeCell = MetronomeViewCell()
    
    private var currentRows: [UITableViewCell] = []
    
    var titleCompletion: ((String) -> ())?
    
    private var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.layer.borderWidth = 0.3
        tableView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return tableView
    }()
    
    enum CurrentSection: Int {
        case calculations = 0,
             heartZones = 1,
             metronome = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setBPMLight()
    }
    
    //MARK: - SetBPMLight
    
    private func setBPMLight() {
        Shaper.shared.drawBpmLight(shape: bpmLight,
                                   view: bpmViewContainer,
                                   x: 7,
                                   y: 5)
        bpmLight.isHidden = true
        metronomeCell.calculatorVCBPMCmpletion = { [weak self] isActive in
            guard let self else {return}
            if isActive == true {
                bpmLight.isHidden = false
                Animator.shared.pillingBPM(self.bpmLight)
            } else {
                bpmLight.isHidden = true
            }
        }
    }
   
    
    //MARK: - SetViews
    
    private func setViews() {
        buttonList.append(contentsOf: [calculateShowButton, 
                                       heartZoneShowButton,
                                       metronomeShowButton])
        
        buttonList.forEach { button in
            buttonsStack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTapped),
                             for: .touchUpInside)
        }
        
        view.addSubview(buttonsStack)
        view.addSubview(bpmViewContainer)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    //MARK: - SetButtons
    
    @objc private func buttonTapped() {
        for i in 0..<buttonList.count {
            if buttonList[i].isTouchInside {
                setActiveSection(section: i)
            }
        }
    }
    
    func setActiveSection(section: CurrentSection.RawValue) {
        switch section {
            
        case 0:
            setImage(calculateShowButton,
                     named: "calculationsDistancePaceIconFill")
            setImage(heartZoneShowButton,
                     named: "CalculationsPulseZonesIconStroke")
            setImage(metronomeShowButton,
                     named: "soundMetronomeIconStroke")

            currentRows.removeAll()
            currentRows.append(calculationsCell)
            tableView.isScrollEnabled = false
            tableView.reloadData()
            
            titleCompletion?("CALCULATIONS")
            UserDefaultsManager.shared.calculationsStatus = section
            
        case 1:
            setImage(calculateShowButton,
                     named: "calculationsDistancePaceIconStroke")
            setImage(heartZoneShowButton,
                     named: "CalculationsPulseZonesIconFill")
            setImage(metronomeShowButton,
                     named: "soundMetronomeIconStroke")

            
            
            currentRows.removeAll()
            currentRows.append(heartZonesCell)
            tableView.isScrollEnabled = true
            tableView.reloadData()
            
            titleCompletion?("PULSE ZONES")
            UserDefaultsManager.shared.calculationsStatus = section
            
        case 2:
            setImage(calculateShowButton,
                     named: "calculationsDistancePaceIconStroke")
            setImage(heartZoneShowButton,
                     named: "CalculationsPulseZonesIconStroke")
            setImage(metronomeShowButton,
                     named: "soundMetronomeIconFill")

            currentRows.removeAll()
            currentRows.append(metronomeCell)
            tableView.isScrollEnabled = false
            tableView.reloadData()
            
            titleCompletion?("METRONOME")
            UserDefaultsManager.shared.calculationsStatus = section
            
        default:
            break
        }
    }
    
    private func setImage(_ button: UIButton, named: String) {
        button.setImage(UIImage(named: named), for: .normal)
        button.setImage(UIImage(named: named), for: .highlighted)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            buttonsStack.widthAnchor.constraint(equalToConstant:
                                           (CGFloat(buttonsStack.subviews.count) *
                                            CGFloat.iconSide) +
                                           (CGFloat(buttonsStack.subviews.count) *
                                            0) -
                                            0),
            buttonsStack.heightAnchor.constraint(equalToConstant:
                                            CGFloat.iconSide),
            buttonsStack.centerXAnchor.constraint(equalTo:
                                            view.centerXAnchor),
            buttonsStack.topAnchor.constraint(equalTo:
                                            view.topAnchor,
                                            constant: 10),
            
            bpmViewContainer.leadingAnchor.constraint(equalTo:
                                            buttonsStack.trailingAnchor),
            bpmViewContainer.centerYAnchor.constraint(equalTo:
                                            buttonsStack.centerYAnchor),
            bpmViewContainer.widthAnchor.constraint(equalToConstant: 10),
            bpmViewContainer.heightAnchor.constraint(equalToConstant: 10),
            
            tableView.leadingAnchor.constraint(equalTo:
                                            view.leadingAnchor,
                                            constant: -0.5),
            tableView.topAnchor.constraint(equalTo:
                                            buttonsStack.bottomAnchor,
                                            constant: 10),
            tableView.trailingAnchor.constraint(equalTo:
                                            view.trailingAnchor,
                                            constant: 0.5),
            tableView.bottomAnchor.constraint(equalTo:
                                            view.bottomAnchor,
                                            constant: 0.5)
        ])
    }
}

extension CalculatorVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        currentRows.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return currentRows[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
