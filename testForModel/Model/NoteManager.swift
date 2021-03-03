//
//  NoteManager.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import UIKit
import CoreData

class NoteManager {
    static let shared = NoteManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes = [Note]()
    var lastNote : Note? {
        if !notes.isEmpty {
            return notes.last!
        } else {
            return nil
        }
    }
    
    private func saveNote() {
        do {
            try context.save()
        }
        catch {
            print("-----> save error : \(error)")
        }
    }
    
    public func createNote(content: String, date: Date) {
        let newNote = Note(context: context)
        newNote.content = content
        newNote.date = date
        saveNote()
        notes = readNote(date: date)
    }
    
    public func readNote(date: Date) -> [Note] {
        let request = Note.fetchRequest() as NSFetchRequest<Note>
        let predicate = NSPredicate(format: "date == %@",date as NSDate)
        request.predicate = predicate
        do {
            let newNotes = try context.fetch(request)
            return newNotes
        }
        catch {
            print("-----> fetch error : \(error)")
            return []
        }
    }
    
    public func updateNote(note: Note, content: String? = nil, date: Date? = nil) {
        
        if let content = content {
            note.content = content
        }
        
        if let date = date {
            note.date = date
        }
        saveNote()
    }
    
    public func deleteNote(note: Note) {
        context.delete(note)
        saveNote()
    }
    
    
}
