//
//  NotesBarView.swift
//  OneDot
//
//  Created by Александр Коробицын on 04.12.2023.
//

import Foundation
import UIKit

class NotesView: UIVisualEffectView {
    
    enum State {
        case outdoor,
             indoor,
             editRows,
             inactive
    }
    
    var notesScreenHideHandler: (() -> Void)?
    
    private var notes: [Note] = []
    
    private let addNoteCellID = "addNoteCell"
    private let editNoteCellID = "editNoteCell"
    private var bottomIndentHeight: CGFloat = 100
    
    private let topRightButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "SSHideGray"),
                                  for: .normal)
        return button
    }()
    
    private let bottomRightButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "SSAdd"),
                                  for: .normal)
        button.setBackgroundImage(UIImage(named: "SSAdd"),
                                  for: .highlighted)
        return button
    }()
    
    private let topLeftButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "SSNotesSettings"),
                                  for: .normal)
        button.setBackgroundImage(UIImage(named: "SSNotesSettings"),
                                  for: .highlighted)
        return button
    }()
    
    private let topCenterButton: UIButton = {
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
    
    //MARK: - SetState
    
    func setState(state: State) {
        switch state {
            
        case .outdoor:
            topLeftButton.isHidden = false
            topCenterButton.isHidden = true
            topRightButton.isHidden = false
            bottomRightButton.isHidden = false
        case .indoor:
            topLeftButton.isHidden = false
            topCenterButton.isHidden = true
            topRightButton.isHidden = true
            bottomRightButton.isHidden = false
        case .editRows:
            topLeftButton.isHidden = true
            topCenterButton.isHidden = false
            topRightButton.isHidden = true
            bottomRightButton.isHidden = true
        case .inactive:
            topLeftButton.isHidden = true
            topCenterButton.isHidden = true
            topRightButton.isHidden = true
            bottomRightButton.isHidden = true
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
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        contentView.addSubview(tableView)
        contentView.clipsToBounds = true
        contentView.insertSubview(topRightButton, aboveSubview: tableView)
        contentView.insertSubview(bottomRightButton, aboveSubview: tableView)
        contentView.insertSubview(topLeftButton, aboveSubview: tableView)
        contentView.insertSubview(topCenterButton, aboveSubview: tableView)
        
        topRightButton.addTarget(self, action: #selector(hideNotes),
                                 for: .touchUpInside)
        
        bottomRightButton.addTarget(self, action: #selector(addNote),
                                    for: .touchUpInside)
        
        topLeftButton.addTarget(self, action: #selector(notesEditBegin),
                                for: .touchUpInside)
        
        topCenterButton.addTarget(self, action: #selector(notesEditDone),
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
        
        setState(state: .editRows)
        topCenterButton.isHidden = false
    }
    
    @objc private func notesEditDone() {
        tableView.isEditing = false
        tableView.transform.ty = 0
        
        if UserDefaultsManager.shared.userIndoorStatus == false {
            setState(state: .indoor)
        } else {
            setState(state: .outdoor)
        }
        
        topCenterButton.isHidden = true
    }
    
    @objc private func hideNotes() {
        self.isHidden = true
        notesScreenHideHandler?()
    }

    //MARK: - SetConstraints
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        topRightButton.translatesAutoresizingMaskIntoConstraints = false
        bottomRightButton.translatesAutoresizingMaskIntoConstraints = false
        topLeftButton.translatesAutoresizingMaskIntoConstraints = false
        topCenterButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            topRightButton.widthAnchor.constraint(equalToConstant: 42),
            topRightButton.heightAnchor.constraint(equalToConstant: 42),
            topRightButton.topAnchor.constraint(equalTo: tableView.topAnchor,
                                             constant: 10),
            topRightButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor,
                                                  constant: -10),
            
            bottomRightButton.widthAnchor.constraint(equalToConstant: 42),
            bottomRightButton.heightAnchor.constraint(equalToConstant: 42),
            bottomRightButton.centerYAnchor.constraint(equalTo:
                                                  tableView.centerYAnchor,
                        constant: -(UIScreen.main.bounds.height - 300) / 8),
            bottomRightButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor,
                                                  constant: -10),
            
            topLeftButton.widthAnchor.constraint(equalToConstant: 42),
            topLeftButton.heightAnchor.constraint(equalToConstant: 42),
            topLeftButton.topAnchor.constraint(equalTo: tableView.topAnchor,
                                             constant: 10),
            topLeftButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor,
                                                  constant: 10),
            
            topCenterButton.topAnchor.constraint(equalTo: 
                                            tableView.topAnchor,
                                            constant: -0.5),
            topCenterButton.heightAnchor.constraint(equalToConstant: 60),
            topCenterButton.leadingAnchor.constraint(equalTo:
                                            tableView.leadingAnchor,
                                            constant: -0.5),
            topCenterButton.trailingAnchor.constraint(equalTo:
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
                setState(state: .inactive)
                CoreDataManager.shared.editNote(notes[indexPath.row],
                                                rowHeight: cell.contentHeight,
                                                text: cell.textView.text,
                                                editing: cell.textEditing)
                bottomIndentHeight = 500
                tableView.endUpdates()  
                tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0),
                                      at: .top, animated: true)
            }
            
            cell.didEndEditingCompletion = { [weak self] in
                guard let self else {return}
                tableView.endEditing(true)
                tableView.beginUpdates()
                CoreDataManager.shared.editNote(notes[indexPath.row],
                                                rowHeight: cell.contentHeight,
                                                text: cell.textView.text,
                                                editing: cell.textEditing)
                
                cell.doneButton.isHidden = true
                
                cell.placeholderState(notes[indexPath.row].editing)
                
                if UserDefaultsManager.shared.userIndoorStatus == false {
                    setState(state: .outdoor)
                } else {
                    setState(state: .indoor)
                }
                
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
        setState(state: .inactive)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        refreshNotesIndex()
        
        if UserDefaultsManager.shared.userIndoorStatus == false {
            setState(state: .outdoor)
        } else {
            setState(state: .indoor)
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

