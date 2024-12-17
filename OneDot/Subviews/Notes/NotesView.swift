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
        case outdoor,
             indoor,
             editRows,
             inactive,
             hide
    }
    
    
    var buttonStateHandler: ((MainVC.Mode) -> Void)?
    
    private var notes: [Note] = []
    
    private let addNoteCellID = "addNoteCell"
    private let editNoteCellID = "editNoteCell"
    private var bottomIndentHeight: CGFloat = 100
    
    private let hideButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "DSHideGray"),
                                  for: .normal)
        return button
    }()
    
    private let addNoteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "SSAdd"),
                                  for: .normal)
        button.setBackgroundImage(UIImage(named: "SSAdd"),
                                  for: .highlighted)
        return button
    }()
    
    private let sortNoteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "SSNotesSettings"),
                                  for: .normal)
        button.setBackgroundImage(UIImage(named: "SSNotesSettings"),
                                  for: .highlighted)
        return button
    }()
    
    private let checkMarkButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: "SSCheckMark"),
                                  for: .normal)
        button.setImage(UIImage(named: "SSCheckMark"),
                                  for: .highlighted)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        button.clipsToBounds = true
        return button
    }()

    private let tableView = {
        let tableView = UITableView()
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
        tableView.register(NotesTableViewEditCell.self,
                           forCellReuseIdentifier: editNoteCellID)
        
        
        
        
        fetchNotes()
        setViews()
        setConstraints()
        
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .outdoor:
            isHidden = false
            sortNoteButton.isHidden = false
            checkMarkButton.isHidden = true
            hideButton.isHidden = false
            addNoteButton.isHidden = false
        case .indoor:
            isHidden = false
            sortNoteButton.isHidden = false
            checkMarkButton.isHidden = true
            hideButton.isHidden = true
            addNoteButton.isHidden = false
        case .editRows:
            sortNoteButton.isHidden = true
            checkMarkButton.isHidden = false
            hideButton.isHidden = true
            addNoteButton.isHidden = true
        case .inactive:
            sortNoteButton.isHidden = true
            checkMarkButton.isHidden = true
            hideButton.isHidden = true
            addNoteButton.isHidden = true
        case .hide:
            isHidden = true
        }
    }
    
    
    //MARK: - CoreDataManager
    
    private func fetchNotes() {
        
        CoreDataManager.shared.fetchNotes { result in
            
            switch result {
            case .success(let notes):
                var x = notes
                x.sort(by: { $0.i < $1.i })
                
                self.notes = x
      
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
        layer.customBorder(bord: true, corner: .max)
        
        contentView.addSubview(tableView)
        contentView.clipsToBounds = true
        contentView.insertSubview(hideButton, aboveSubview: tableView)
        contentView.insertSubview(addNoteButton, aboveSubview: tableView)
        contentView.insertSubview(sortNoteButton, aboveSubview: tableView)
        contentView.insertSubview(checkMarkButton, aboveSubview: tableView)
        
        hideButton.addTarget(self, action: #selector(hideNotes),
                                 for: .touchUpInside)
        
        addNoteButton.addTarget(self, action: #selector(addNote),
                                    for: .touchUpInside)
        
        sortNoteButton.addTarget(self, action: #selector(notesEditBegin),
                                for: .touchUpInside)
        
        checkMarkButton.addTarget(self, action: #selector(notesEditDone),
                                for: .touchUpInside)
    }
    
    //MARK: - TargetsOfButtons
    
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
    
    @objc private func notesEditBegin() {
        tableView.isEditing = true
        
        tableView.transform.ty = 60
        
        activateMode(mode: .editRows)
        checkMarkButton.isHidden = false
    }
    
    @objc private func notesEditDone() {
        
        tableView.isEditing = false
        tableView.transform.ty = 0
        
        if UserDefaultsManager.shared.outdoorStatusValue {
            activateMode(mode: .outdoor)
        } else {
            activateMode(mode: .indoor)
        }
        
        checkMarkButton.isHidden = true
    }
    
    @objc func hideNotes() {
        buttonStateHandler?(.notesHide)
    }

    //MARK: - SetConstraints
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        sortNoteButton.translatesAutoresizingMaskIntoConstraints = false
        checkMarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            hideButton.widthAnchor.constraint(equalToConstant: 42),
            hideButton.heightAnchor.constraint(equalToConstant: 42),
            hideButton.topAnchor.constraint(equalTo: tableView.topAnchor,
                                             constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor,
                                                  constant: -10),
            
            addNoteButton.widthAnchor.constraint(equalToConstant: 42),
            addNoteButton.heightAnchor.constraint(equalToConstant: 42),
            addNoteButton.centerYAnchor.constraint(equalTo:
                                                  tableView.centerYAnchor,
                        constant: -(UIScreen.main.bounds.height - 300) / 8),
            addNoteButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor,
                                                  constant: -10),
            
            sortNoteButton.widthAnchor.constraint(equalToConstant: 42),
            sortNoteButton.heightAnchor.constraint(equalToConstant: 42),
            sortNoteButton.topAnchor.constraint(equalTo: tableView.topAnchor,
                                             constant: 10),
            sortNoteButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor,
                                                  constant: 10),
            
            checkMarkButton.topAnchor.constraint(equalTo: 
                                            tableView.topAnchor,
                                            constant: -0.5),
            checkMarkButton.heightAnchor.constraint(equalToConstant: 60),
            checkMarkButton.leadingAnchor.constraint(equalTo:
                                            tableView.leadingAnchor,
                                            constant: -0.5),
            checkMarkButton.trailingAnchor.constraint(equalTo:
                                            tableView.trailingAnchor,
                                            constant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITableViewDataSource

extension NotesView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return notes.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        if indexPath.section == 0 {
            
            let cell = NotesTableViewEditCell()
                cell.selectionStyle = .none
                cell.textView.text = notes[indexPath.row].text
                cell.textEditing = notes[indexPath.row].editing
                cell.placeholderState(cell.textEditing)

                cell.contentCompletion = { [weak self] in
                guard let self else {return}
                
                tableView.beginUpdates()
                activateMode(mode: .inactive)
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
                tableView.endEditing(true)
                tableView.beginUpdates()
                CoreDataManager.shared.editNote(notes[indexPath.row],
                                                rowHeight: cell.contentHeight,
                                                text: cell.textView.text,
                                                editing: cell.textEditing)
                
                cell.doneButton.isHidden = true
                
                cell.placeholderState(notes[indexPath.row].editing)
                
                UserDefaultsManager.shared.outdoorStatusValue ? activateMode(mode: .outdoor) : activateMode(mode: .indoor)
                
                tableView.endUpdates()
            }
            return cell
            
        } else if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

//MARK: - UITableViewDelegate

extension NotesView: UITableViewDelegate   {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        activateMode(mode: .inactive)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        refreshNotesIndex()
        
        if UserDefaultsManager.shared.outdoorStatusValue == false {
            activateMode(mode: .indoor)
        } else {
            
            activateMode(mode: .outdoor)
        }
        
        self.tableView.isUserInteractionEnabled = true
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let noteToMove = notes[sourceIndexPath.row]
        notes.remove(at: sourceIndexPath.row)
        notes.insert(noteToMove, at: destinationIndexPath.row)
        refreshNotesIndex()
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

