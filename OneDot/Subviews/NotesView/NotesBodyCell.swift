//
//  NotesViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 04.12.2023.
//

import Foundation
import UIKit

class NotesBodyCell: UITableViewCell {
    
    var contentCompletion: ((CGFloat, String, Bool) -> Void)?
    var notesEndEditingHandler: ((CGFloat, String, Bool) -> Void)?
    
    var rCounter: Int = 0
    var contentHeight: CGFloat = 120
    var textEditing: Bool = false

    private let containerView = UIVisualEffectView()
    let textView = UITextView()
    let placeholderImage: UIImageView = UIImageView()
    
    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.delegate = self
        
        setViews()
        setConstraints()
    }
    
    func beginUpdates(textEditing: Bool, text: String) {
        placeholderImage.isHidden = textEditing
        textView.text = text
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

extension NotesBodyCell: UITextViewDelegate, UITextInteractionDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        contentHeight = textView.contentSize.height > 80 ? textView.contentSize.height + 40 : 120
        notesEndEditingHandler?(contentHeight, textView.text, textEditing)
        beginUpdates(textEditing: textEditing, text: textView.text)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        contentHeight = 150
        placeholderImage.isHidden = true
        contentCompletion?(contentHeight, textView.text, textEditing)
        return true
    }
  
    func textViewDidChange(_ textView: UITextView) {
        textEditing = textView.text.count > 0 ? true : false
        
        if textView.selectedRange.location == rCounter - 1 {
            if textView.attributedText.string.last == "\n" {
                textView.text.removeLast()
                textView.text.append("\n")
            }
        }
        rCounter = textView.selectedRange.location
        
        contentCompletion?(contentHeight, textView.text, textEditing)
    }
}
