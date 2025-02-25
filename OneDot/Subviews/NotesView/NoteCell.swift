//
//  NotesViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 04.12.2023.
//

import Foundation
import UIKit

class NoteCell: UITableViewCell {

    var editingHandler: ((CGFloat, String, Bool) -> Void)?
    
    lazy var deleteMode: Bool = false
    private lazy var rCounter: Int = 0
    private lazy var contentHeight: CGFloat = 120

    private let containerView = UIVisualEffectView()
    private let textView = UITextView()
    
    private let placeholderImage: UIImageView = UIImageView()
    private let redLineShape: CAShapeLayer = CAShapeLayer()
    
    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.delegate = self
        
        setViews()
        setConstraints()
    }
    
    override func layoutSubviews() {
        GraphicsService.shared.drawShape(shape: redLineShape, shapeType: .noteCellRedLine, view: self)
        redLineShape.strokeColor = deleteMode ? UIColor.red.cgColor : UIColor.red.withAlphaComponent(0.5).cgColor
    }
    
    func update(text: String) {
        textView.text = text
        placeholderImage.isHidden = text.isEmpty ? false : true
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.disableAutoresizingMask()
        containerView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        containerView.clipsToBounds = true
        containerView.layer.instance(border: true, corner: .min)
        
        containerView.contentView.addSubview(textView)
        textView.disableAutoresizingMask()
        textView.backgroundColor = .clear
        textView.contentMode = .center
        textView.clipsToBounds = true
        textView.tintColor = .myPaletteGold
        textView.textColor = .darkGray
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        containerView.contentView.addSubview(placeholderImage)
        placeholderImage.disableAutoresizingMask()
        placeholderImage.image = UIImage(named: "BodyDetailsGray")
    }

    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            textView.topAnchor.constraint(equalTo: containerView.topAnchor),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            placeholderImage.widthAnchor.constraint(equalToConstant: 42),
            placeholderImage.heightAnchor.constraint(equalToConstant: 42),
            placeholderImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0),
            placeholderImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - TextViewDidChange

extension NoteCell: UITextViewDelegate, UITextInteractionDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        placeholderImage.isHidden = true
        editingHandler?(contentHeight, textView.text, true)
        return true
    }
  
    func textViewDidChange(_ textView: UITextView) {
        if textView.selectedRange.location == rCounter - 1 {
            if textView.attributedText.string.last == "\n" {
                textView.text.removeLast()
                textView.text.append("\n")
            }
        }
        rCounter = textView.selectedRange.location
        
        editingHandler?(contentHeight, textView.text, true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        contentHeight = textView.contentSize.height > 100 ? textView.contentSize.height + 20 : 120
        editingHandler?(contentHeight, textView.text, false)
        update(text: textView.text)
    }
}
