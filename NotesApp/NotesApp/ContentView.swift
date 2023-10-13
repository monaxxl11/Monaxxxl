//
//  ContentView.swift
//  NotesApp
//
//  Created by Егор Монах on 13.10.23.
//

import SwiftUI

struct Note: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}


struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var notes = [Note]()
    @State private var isAddingNote = false
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteDetail(note: note)) {
                        Text(note.title)
                    }
                }
                .onDelete(perform: deleteNote)
            }
            .navigationBarTitle("Заметки")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                isAddingNote = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isAddingNote) {
                AddNoteView(notes: $notes, isAddingNote: $isAddingNote)
            }
        }
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct NoteDetail: View {
    var note: Note
    
    var body: some View {
        VStack {
            Text(note.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(note.content)
                .padding()
            Spacer()
        }
        .navigationTitle(note.title)
    }
}

struct AddNoteView: View {
    @Binding var notes: [Note]
    @Binding var isAddingNote: Bool
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Заголовок", text: $newNoteTitle)
                    TextEditor(text: $newNoteContent)
                }
                Section {
                    Button(action: {
                        let note = Note(title: newNoteTitle, content: newNoteContent)
                        notes.append(note)
                        isAddingNote = false
                    }) {
                        Text("Сохранить")
                    }
                    Button(action: {
                        isAddingNote = false
                    }) {
                        Text("Отмена")
                    }
                }
            }
            .navigationBarTitle("Добавить заметку")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
