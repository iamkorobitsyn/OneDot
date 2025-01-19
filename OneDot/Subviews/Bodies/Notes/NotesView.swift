//
//  NotesBarView.swift
//  OneDot
//
//  Created by Александр Коробицын on 04.12.2023.
//

import Foundation
import UIKit

class NotesView: UIVisualEffectView {
    
    enum Mode {
        case prepare,
             editing,
             deleting,
             hide
    }
    
    var buttonStateHandler: ((DashboardVC.Mode) -> Void)?
    
    private var notes: [Note] = []
    
    private let addNoteCellID = "addNoteCell"
    private let editNoteCellID = "editNoteCell"
    private var bottomIndentHeight: CGFloat = 120
    
    private let hideOrDoneButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setBackgroundImage(UIImage(named: "BodyHide"), for: .normal)
        button.setBackgroundImage(UIImage(named: "BodyHide"), for: .highlighted)
        return button
    }()
    
    private var textEditingMode: Bool = false
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setBackgroundImage(UIImage(named: "BodyAdd"), for: .normal)
        button.setBackgroundImage(UIImage(named: "BodyAdd"), for: .highlighted)
        return button
    }()

    private let tableView = {
        let tableView = UITableView()
        tableView.disableAutoresizingMask()
        tableView.layer.cornerRadius = 30
        tableView.layer.cornerCurve = .continuous
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    
    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotesCell.self,
                           forCellReuseIdentifier: editNoteCellID)

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
            hideOrDoneButton.setBackgroundImage(UIImage(named: "BodyHide"), for: .highlighted)
        case .editing:
            textEditingMode = true
            addButton.isHidden = true
            hideOrDoneButton.setBackgroundImage(UIImage(named: "BodyCheckmark"), for: .normal)
            hideOrDoneButton.setBackgroundImage(UIImage(named: "BodyCheckmark"), for: .highlighted)
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
        layer.instance(border: true, corner: .max)
        isHidden = true
        
        contentView.addSubview(tableView)
        contentView.clipsToBounds = true
        contentView.insertSubview(hideOrDoneButton, aboveSubview: tableView)
        contentView.insertSubview(addButton, aboveSubview: tableView)
        hideOrDoneButton.addTarget(self, action: #selector(tappedHideOrDoneButton),
                                 for: .touchUpInside)
        
        addButton.addTarget(self, action: #selector(addNote),
                                    for: .touchUpInside)
    }
    
    
    //MARK: - ButtonsTapped
    
    @objc private func addNote() {
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
        if textEditingMode { tableView.endEditing(true) } else { buttonStateHandler?(.notesHide) }
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        hideOrDoneButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
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

extension NotesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        section == 0 ? notes.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        if indexPath.section == 0 {
            
            let cell = NotesCell()
                cell.selectionStyle = .none
                cell.textView.text = notes[indexPath.row].text
                cell.textEditing = notes[indexPath.row].editing
                cell.placeholderState(cell.textEditing)

                cell.contentCompletion = { [weak self] in
                guard let self else {return}
                
                tableView.beginUpdates()
                activateMode(mode: .editing)
                CoreDataManager.shared.editNote(notes[indexPath.row],
                                                rowHeight: cell.contentHeight,
                                                text: cell.textView.text,
                                                editing: cell.textEditing)
                    
                bottomIndentHeight = 500
                tableView.endUpdates()  
                tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0),
                                      at: .top, animated: true)
            }
            
                cell.notesEndEditingHandler = { [weak self] in
                guard let self else {return}
                    notesEditDone(i: indexPath.row, rowHeight: cell.contentHeight,
                                  text: cell.textView.text, editing: cell.textEditing)
            }
            return cell
            
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }

    }
    
    
}

//MARK: - UITableViewDelegate

extension NotesView: UITableViewDelegate   {
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NotesCell {
            activateMode(mode: .deleting)
            cell.verticalSeparator.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        refreshNotesIndex()
        self.tableView.isUserInteractionEnabled = true
        tableView.reloadData()
        activateMode(mode: .prepare)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if editingStyle == .delete {
                CoreDataManager.shared.deleteNote(notes[indexPath.row])
                self.notes.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.isUserInteractionEnabled = false
            }
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return bottomIndentHeight
        } else {
            for i in 0..<notes.count {
                if i == indexPath.row {
                    return CGFloat(notes[i].rowHeight)
                    
                }
            }
        }
        return CGFloat()
    }

}

