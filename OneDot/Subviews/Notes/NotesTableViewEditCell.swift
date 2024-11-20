//
//  NotesViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 04.12.2023.
//

import Foundation
import UIKit

class NotesTableViewEditCell: UITableViewCell {
    
    var contentCompletion: (() -> Void)?
    var notesEndEditingHandler: (() -> Void)?
    
    var rCounter: Int = 0
    var contentLimitHeight: CGFloat = 100
    var contentHeight: CGFloat = 100
    var textEditing: Bool = false

    private let containerView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        view.layer.cornerRadius = 21
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let textView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.contentMode = .center
        view.clipsToBounds = true
        view.textColor = .gray
        view.tintColor = .init(r: 255, g: 143, b: 69, alpha: 1)
        view.font = UIFont.systemFont(ofSize: 20,
                                            weight: .medium,
                                            width: .compressed)
        return view
    }()
    
    let placeholderImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "SSComment")
        return image
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SSCheckMark"), for: .normal)
        button.setImage(UIImage(named: "SSCheckMark"), for: .highlighted)
        return button
    }()

    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.delegate = self
        
        setViews()
        setConstraints()
    }
    
    func placeholderState(_ textEditing: Bool) {
        if textEditing == true {
            placeholderImage.isHidden = true
        } else {
            placeholderImage.isHidden = false
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.contentView.addSubview(textView)
        containerView.contentView.addSubview(placeholderImage)
        contentView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.isHidden = true

    }
    
    @objc private func doneTapped() {
        notesEndEditingHandler?()
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: 
                                            topAnchor,
                                            constant: 10),
            containerView.trailingAnchor.constraint(equalTo:
                                            trailingAnchor,
                                            constant: -60),
            containerView.bottomAnchor.constraint(equalTo:
                                            bottomAnchor,
                                            constant: -10),
            containerView.leadingAnchor.constraint(equalTo:
                                            leadingAnchor,
                                            constant: 60),
            textView.widthAnchor.constraint(equalToConstant:
                                            UIScreen.main.bounds.width / 1.9),
            textView.heightAnchor.constraint(equalToConstant: 125),
            textView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            placeholderImage.widthAnchor.constraint(equalToConstant: 42),
            placeholderImage.heightAnchor.constraint(equalToConstant: 42),
            placeholderImage.centerYAnchor.constraint(equalTo: 
                                            containerView.centerYAnchor,
                                            constant: 0),
            placeholderImage.centerXAnchor.constraint(equalTo:
                                            containerView.centerXAnchor),
            
            doneButton.widthAnchor.constraint(equalToConstant: 42),
            doneButton.heightAnchor.constraint(equalToConstant: 42),
            doneButton.centerYAnchor.constraint(equalTo: 
                                            containerView.centerYAnchor),
            doneButton.leadingAnchor.constraint(equalTo:
                                            containerView.trailingAnchor,
                                            constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - TextViewDidChange

extension NotesTableViewEditCell: UITextViewDelegate, UITextInteractionDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentHeight > 100 {
            contentHeight = textView.contentSize.height + 20
        } else {
            contentHeight = 100
        }
        
        notesEndEditingHandler?()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        placeholderImage.isHidden = true
        
        if textView.contentSize.height > 80,
           textView.contentSize.height < 100 {

            contentHeight = textView.contentSize.height + 40
            
        } else if textView.contentSize.height > 100 {
            contentHeight = 145
            print(contentHeight)
        } else {
            contentHeight = 100
        }
        
        doneButton.isHidden = false
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
        
        
        if textView.contentSize.height > 80,
           textView.contentSize.height < 100 {

            contentHeight = textView.contentSize.height + 40
            
        } else if textView.contentSize.height > 100 {
            contentHeight = 145
            print(contentHeight)
        } else {
            contentHeight = 100
        }
        
        contentCompletion?()
    }
}
