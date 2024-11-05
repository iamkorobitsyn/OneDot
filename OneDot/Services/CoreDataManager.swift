//
//  CoreDataManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 07.12.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    
    static let shared = CoreDataManager()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    
    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {
  
        let container = NSPersistentContainer(name: "OneDot")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    

    // MARK: - Core Data Saving support

    func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    //MARK: - Note Entityes
    
    func fetchNotes(completion: (Result <[Note], Error>) -> Void) {
        let fetchRequest = Note.fetchRequest()
        do {
            let notes = try context.fetch(fetchRequest)
            completion(.success(notes))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func addNote(completion: (Note) -> Void) {
        
        guard let entityDescription =
                NSEntityDescription.entity(forEntityName: "Note",
                                           in: context) else {return}
        guard let note =
                NSManagedObject(entity: entityDescription,
                                insertInto: context) as? Note else {return}
        note.i = 0
        note.rowHeight = 100
        note.text = ""
        note.editing = false
        completion(note)
        saveContext()
    }
    
    func noteIndexChange(_ note: Note, i: Int) {
        note.i = Int64(i)
        saveContext()
    }
    
    func editNote(_ note: Note,
                  rowHeight: CGFloat,
                  text: String,
                  editing: Bool) {
        note.rowHeight = Int64(rowHeight)
        note.text = text
        note.editing = editing
        saveContext()
    }

    
    func deleteNote(_ note: Note) {
        context.delete(note)
        saveContext()
    }
    
    func insertNote(_ note: Note) {
        context.insert(note)
        saveContext()
    }
    
    
    
}
