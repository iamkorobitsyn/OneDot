//
//  NotesBarView.swift
//  OneDot
//
//  Created by Александр Коробицын on 04.12.2023.
//

import Foundation
import UIKit

class NotesBodyView: UIVisualEffectView {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    var buttonStateHandler: ((DashboardVC.Mode) -> Void)?
    
    enum Mode {
        case prepare,
             editing,
             deleting,
             hide
    }
    
    private var notes: [Note] = []
    private var textEditingMode: Bool = false
    
    private let tableView = UITableView()
    private let cellID = "noteCell"
    
    private let hideOrDoneButton: UIButton = UIButton()
    private let addButton: UIButton = UIButton()


    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        tableView.delegate = self
        tableView.dataSource = self
        fetchNotes()
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
        case .prepare:
            textEditingMode = false
            isHidden = false
            hideOrDoneButton.isHidden = false
            addButton.isHidden = false
            hideOrDoneButton.setBackgroundImage(UIImage(named: "BodyHide"), for: .normal)
        case .editing:
            textEditingMode = true
            addButton.isHidden = true
            hideOrDoneButton.setBackgroundImage(UIImage(named: "BodyCheckmark"), for: .normal)
        case .deleting:
            hideOrDoneButton.isHidden = true
            addButton.isHidden = true
        case .hide:
            isHidden = true
        }
    }
    
    
    //MARK: - CoreDataManager
    
    private func fetchNotes() {
        
        CoreDataManager.shared.fetchNotes { result in
            
            switch result {
            case .success(let result):
                var notes = result
                notes.sort(by: { $0.i < $1.i })
                self.notes = notes
      
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func refreshNotesIndex() {
        var iCounter = 0
        for i in 0..<notes.count {
            CoreDataManager.shared.noteIndexChange(notes[i], i: iCounter)
            notes[i].i = Int64(iCounter)
            iCounter = iCounter + 1
        }
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        isHidden = true
        clipsToBounds = true
        effect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        layer.instance(border: true, corner: .max)
        
        [tableView, hideOrDoneButton, addButton].forEach { view in
            view.disableAutoresizingMask()
            contentView.addSubview(view)
        }

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(NotesBodyCell.self, forCellReuseIdentifier: cellID)

        hideOrDoneButton.setBackgroundImage(UIImage(named: "BodyHide"), for: .normal)
        hideOrDoneButton.addTarget(self, action: #selector(tappedHideOrDoneButton), for: .touchUpInside)

        addButton.setBackgroundImage(UIImage(named: "BodyAdd"), for: .normal)
        addButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
    }
    
    
    //MARK: - ButtonsTapped
    
    @objc private func addNote() {
        hapticGenerator.selectionChanged()
        
        CoreDataManager.shared.addNote { note in
            
            notes.insert(note, at: 0)
            refreshNotesIndex()
            
            let indexPath: IndexPath = IndexPath(row:(0), section: 0)
            tableView.insertRows(at: [indexPath], with: .left)
            tableView.isUserInteractionEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.isUserInteractionEnabled = true
            self.tableView.reloadData()
        }
        if notes.count > 1 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                  at: .top, animated: true)
        }
    }
    
    @objc private func tappedHideOrDoneButton() {
        if textEditingMode {
            tableView.endEditing(true)
            hapticGenerator.selectionChanged()
        } else {
            buttonStateHandler?(.notesHide)
        }
    }
    
    //MARK: - EditDone
    
    private func notesEditDone(i: Int, rowHeight: CGFloat, text: String, editing: Bool) {
        tableView.endEditing(true)
        tableView.beginUpdates()
        CoreDataManager.shared.editNote(notes[i], rowHeight: rowHeight, text: text, editing: editing)
        tableView.endUpdates()
        activateMode(mode: .prepare)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            hideOrDoneButton.widthAnchor.constraint(equalToConstant: 42),
            hideOrDoneButton.heightAnchor.constraint(equalToConstant: 42),
            hideOrDoneButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            hideOrDoneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            addButton.centerXAnchor.constraint(equalTo: hideOrDoneButton.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITableViewDataSource

extension NotesBodyView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = NotesBodyCell()
        cell.beginUpdates(textEditing: notes[indexPath.row].editing, text: notes[indexPath.row].text ?? "")
        
        cell.contentCompletion = { [weak self] contentHeight, text, editing in
            guard let self else {return}
            
            tableView.beginUpdates()
            activateMode(mode: .editing)
            CoreDataManager.shared.editNote(notes[indexPath.row], rowHeight: contentHeight, text: text, editing: editing)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .top, animated: true)
        }
        
        cell.notesEndEditingHandler = { [weak self] contentHeight, text, editing in
            guard let self else {return}
            notesEditDone(i: indexPath.row, rowHeight: contentHeight, text: text, editing: editing)
        }

        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotesBodyView: UITableViewDelegate   {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        600
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        activateMode(mode: .deleting)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        refreshNotesIndex()
        self.tableView.isUserInteractionEnabled = true
        tableView.reloadData()
        activateMode(mode: .prepare)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.shared.deleteNote(notes[indexPath.row])
            self.notes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.isUserInteractionEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        for i in 0..<notes.count {
            if i == indexPath.row {
                return CGFloat(notes[i].rowHeight)
            }
        }
        return CGFloat()
    }
}
