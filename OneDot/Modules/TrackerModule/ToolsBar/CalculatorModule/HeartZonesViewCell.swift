//
//  HeartZonesViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2024.
//

import UIKit

class HeartZonesViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let maxHRView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 82, b: 98, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMaxXMinYCorner]
        return view
    }()
    private let hardHRView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 143, b: 69, alpha: 1)
        return view
    }()
    
    private let moderateHRView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 107, g: 210, b: 111, alpha: 1)
        return view
    }()
    
    private let lightHRView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 171, g: 193, b: 211, alpha: 1)
        return view
    }()
    
    private let veryLightHRView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 188, g: 188, b: 188, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        return view
    }()
    
    private let hRStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 1
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let leftTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 255, g: 82, b: 98, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private let leftCenterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 107, g: 210, b: 111, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private let leftBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 171, g: 193, b: 211, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private let leftTopIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "calculationsHeartIcon")
        return view
    }()
    
    private let leftCenterIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "calculationsHeartIcon")
        return view
    }()
    
    private let leftBottomIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "calculationsHeartIcon")
        return view
    }()
    
    private let maxHRTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .black, width: .compressed)
        label.textColor = .white
        label.text = "136 - 154 \n MAX"
        return label
    }()
    
    private let hardHRTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .black, width: .compressed)
        label.textColor = .white
        label.text = "136 - 154 \n HARD"
        return label
    }()
    
    private let moderateHRTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .black, width: .compressed)
        label.textColor = .white
        label.text = "136 - 154 \n MODERATE"
        return label
    }()
    
    private let lightHRTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .black, width: .compressed)
        label.textColor = .white
        label.text = "136 - 154 \n LIGHT"
        return label
    }()
    
    private let veryLightHRTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .black, width: .compressed)
        label.textColor = .white
        label.text = "136 - 154 \n VERY LIGHT"
        return label
    }()
    
    private let maxHRIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "calculationsHeartPulseIcon")
        return view
    }()
    
    private let hardHRIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "calculationsHeartPulseIcon")
        return view
    }()
    
    private let moderateHRIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "calculationsHeartPulseIcon")
        return view
    }()
    
    private let lightHRIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "calculationsHeartPulseIcon")
        return view
    }()
    
    private let veryLightHRIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "calculationsHeartPulseIcon")
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        setViews()
        setConstraints()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        contentView.addSubview(containerView)
        
        hRStackView.addArrangedSubview(maxHRView)
        hRStackView.addArrangedSubview(hardHRView)
        hRStackView.addArrangedSubview(moderateHRView)
        hRStackView.addArrangedSubview(lightHRView)
        hRStackView.addArrangedSubview(veryLightHRView)

        containerView.addSubview(hRStackView)
        
        containerView.addSubview(leftCenterView)
        containerView.addSubview(leftTopView)
        containerView.addSubview(leftBottomView)
        
        leftTopView.addSubview(leftTopIcon)
        leftCenterView.addSubview(leftCenterIcon)
        leftBottomView.addSubview(leftBottomIcon)
        
        
        maxHRView.addSubview(maxHRTitle)
        hardHRView.addSubview(hardHRTitle)
        moderateHRView.addSubview(moderateHRTitle)
        lightHRView.addSubview(lightHRTitle)
        veryLightHRView.addSubview(veryLightHRTitle)
        
        maxHRView.addSubview(maxHRIcon)
        hardHRView.addSubview(hardHRIcon)
        moderateHRView.addSubview(moderateHRIcon)
        lightHRView.addSubview(lightHRIcon)
        veryLightHRView.addSubview(veryLightHRIcon)
        
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            containerView.widthAnchor.constraint(equalToConstant: CGFloat.toolwidth),
            containerView.heightAnchor.constraint(equalToConstant: 354),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            hRStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            hRStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hRStackView.heightAnchor.constraint(equalToConstant: 354),
            hRStackView.widthAnchor.constraint(equalToConstant: CGFloat.toolwidth / 3 * 2),
            
            leftCenterView.centerYAnchor.constraint(equalTo: hRStackView.centerYAnchor),
            leftCenterView.trailingAnchor.constraint(equalTo: hRStackView.leadingAnchor, constant: -1),
            leftCenterView.heightAnchor.constraint(equalToConstant: 212),
            leftCenterView.widthAnchor.constraint(equalToConstant: CGFloat.toolwidth / 3),
            
            leftTopView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leftTopView.trailingAnchor.constraint(equalTo: hRStackView.leadingAnchor, constant: -1),
            leftTopView.heightAnchor.constraint(equalToConstant: 141),
            leftTopView.widthAnchor.constraint(equalToConstant: CGFloat.toolwidth / 3 - 20),
            
            leftBottomView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            leftBottomView.trailingAnchor.constraint(equalTo: hRStackView.leadingAnchor, constant: -1),
            leftBottomView.heightAnchor.constraint(equalToConstant: 141),
            leftBottomView.widthAnchor.constraint(equalToConstant: CGFloat.toolwidth / 3 - 20),
            
            leftTopIcon.widthAnchor.constraint(equalToConstant: 50),
            leftTopIcon.heightAnchor.constraint(equalToConstant: 50),
            leftTopIcon.centerXAnchor.constraint(equalTo: leftTopView.centerXAnchor),
            leftTopIcon.centerYAnchor.constraint(equalTo: leftTopView.centerYAnchor),
            
            leftCenterIcon.widthAnchor.constraint(equalToConstant: 50),
            leftCenterIcon.heightAnchor.constraint(equalToConstant: 50),
            leftCenterIcon.centerXAnchor.constraint(equalTo: leftCenterView.centerXAnchor),
            leftCenterIcon.centerYAnchor.constraint(equalTo: leftCenterView.centerYAnchor),
            
            leftBottomIcon.widthAnchor.constraint(equalToConstant: 50),
            leftBottomIcon.heightAnchor.constraint(equalToConstant: 50),
            leftBottomIcon.centerXAnchor.constraint(equalTo: leftBottomView.centerXAnchor),
            leftBottomIcon.centerYAnchor.constraint(equalTo: leftBottomView.centerYAnchor),
            
            maxHRTitle.centerXAnchor.constraint(equalTo: maxHRView.centerXAnchor),
            maxHRTitle.centerYAnchor.constraint(equalTo: maxHRView.centerYAnchor),
            hardHRTitle.centerXAnchor.constraint(equalTo: hardHRView.centerXAnchor),
            hardHRTitle.centerYAnchor.constraint(equalTo: hardHRView.centerYAnchor),
            moderateHRTitle.centerXAnchor.constraint(equalTo: moderateHRView.centerXAnchor),
            moderateHRTitle.centerYAnchor.constraint(equalTo: moderateHRView.centerYAnchor),
            lightHRTitle.centerXAnchor.constraint(equalTo: lightHRView.centerXAnchor),
            lightHRTitle.centerYAnchor.constraint(equalTo: lightHRView.centerYAnchor),
            veryLightHRTitle.centerXAnchor.constraint(equalTo: veryLightHRView.centerXAnchor),
            veryLightHRTitle.centerYAnchor.constraint(equalTo: veryLightHRView.centerYAnchor),
            
            maxHRIcon.widthAnchor.constraint(equalToConstant: 50),
            maxHRIcon.heightAnchor.constraint(equalToConstant: 50),
            maxHRIcon.centerYAnchor.constraint(equalTo: maxHRView.centerYAnchor),
            maxHRIcon.trailingAnchor.constraint(equalTo: maxHRView.trailingAnchor),
            
            hardHRIcon.widthAnchor.constraint(equalToConstant: 50),
            hardHRIcon.heightAnchor.constraint(equalToConstant: 50),
            hardHRIcon.centerYAnchor.constraint(equalTo: hardHRView.centerYAnchor),
            hardHRIcon.trailingAnchor.constraint(equalTo: hardHRView.trailingAnchor),
            
            moderateHRIcon.widthAnchor.constraint(equalToConstant: 50),
            moderateHRIcon.heightAnchor.constraint(equalToConstant: 50),
            moderateHRIcon.centerYAnchor.constraint(equalTo: moderateHRView.centerYAnchor),
            moderateHRIcon.trailingAnchor.constraint(equalTo: moderateHRView.trailingAnchor),
            
            lightHRIcon.widthAnchor.constraint(equalToConstant: 50),
            lightHRIcon.heightAnchor.constraint(equalToConstant: 50),
            lightHRIcon.centerYAnchor.constraint(equalTo: lightHRView.centerYAnchor),
            lightHRIcon.trailingAnchor.constraint(equalTo: lightHRView.trailingAnchor),
            
            veryLightHRIcon.widthAnchor.constraint(equalToConstant: 50),
            veryLightHRIcon.heightAnchor.constraint(equalToConstant: 50),
            veryLightHRIcon.centerYAnchor.constraint(equalTo: veryLightHRView.centerYAnchor),
            veryLightHRIcon.trailingAnchor.constraint(equalTo: veryLightHRView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
