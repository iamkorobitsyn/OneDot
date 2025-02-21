//
//  NotesViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 04.12.2023.
//

import Foundation
import UIKit

class NotesBodyCell: UITableViewCell {
    
    var contentCompletion: (() -> Void)?
    var notesEndEditingHandler: (() -> Void)?
    
    var rCounter: Int = 0
    var contentHeight: CGFloat = 120
    var textEditing: Bool = false

    private let containerView = {
        let view = UIVisualEffectView()
        view.disableAutoresizingMask()
        view.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        view.clipsToBounds = true
        view.layer.instance(border: true, corner: .min)
        return view
    }()
    
    let textView = {
        let view = UITextView()
        view.disableAutoresizingMask()
        view.backgroundColor = .clear
        view.contentMode = .center
        view.clipsToBounds = true
        view.tintColor = .myPaletteGold
        view.textColor = .darkGray
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return view
    }()
    
    let placeholderImage: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        view.image = UIImage(named: "BodyDetailsGray")
        return view
    }()
    
    let verticalSeparator: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        view.image = UIImage(named: "verticalSeparatorRed")
        view.alpha = 0.3
        return view
    }()

    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.delegate = self
        
        setViews()
        setConstraints()
    }
    
    func placeholderState(_ textEditing: Bool) {
        placeholderImage.isHidden = textEditing
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.contentView.addSubview(textView)
        containerView.contentView.addSubview(placeholderImage)
        contentView.addSubview(verticalSeparator)
    }

    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            textView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.9),
            textView.topAnchor.constraint(equalTo: containerView.topAnchor),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            placeholderImage.widthAnchor.constraint(equalToConstant: 42),
            placeholderImage.heightAnchor.constraint(equalToConstant: 42),
            placeholderImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0),
            placeholderImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            verticalSeparator.widthAnchor.constraint(equalToConstant: 42),
            verticalSeparator.heightAnchor.constraint(equalToConstant: 42),
            verticalSeparator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 24),
            verticalSeparator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - TextViewDidChange

extension NotesBodyCell: UITextViewDelegate, UITextInteractionDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        contentHeight = textView.contentSize.height > 80 ? textView.contentSize.height + 30 : 120
        notesEndEditingHandler?()
        verticalSeparator.isHidden = false
        placeholderState(textEditing)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        contentHeight = 150
        verticalSeparator.isHidden = true
        placeholderImage.isHidden = true
        contentCompletion?()
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
        
        contentCompletion?()
    }
}
