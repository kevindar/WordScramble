//
//  ContentView.swift
//  WordScramble
//
//  Created by Kevin Darmawan on 27/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = "Gaming"
    @State private var newWord = ""
    // error control var
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    func addNewWord() {
        // lowercase and trim whitespace newline
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        // check atleast 1 character
        guard answer.count > 0 else { return }
        // check originality
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Think of a new word")
            return
        }
        // check word validity
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        // check real word
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't use imaginary words")
            return
        }
        
        // insert at position 0
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        print(usedWords)
        // reset newWord
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .ascii) {
                // 3. Split the string up into an array of strings, split by line breaks
                let allWords = startWords.components(separatedBy: "\n")
                // 4. Pick one random word, or use "creator" as a default
                rootWord = allWords.randomElement() ?? "silkworm"
                // If we are here then everything has worked, can exit
                return
            }
        }
        // If were *here* then there was a problem - trigger a crash and report the error
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word) // is the word been used or not
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        // check if the random word can be made out of the letters from another random word
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    // need to use UITextChecker from UIKit. In order to bridge Swift strings to Objective-C strings safely, we need to create an instance of NSRange using the UTF-16 count of our Swift string
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Input word")
                        .font(.headline)
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .onSubmit(addNewWord)
                        .onAppear(perform: startGame)
                        .alert(errorTitle, isPresented: $showingError) {
                            Button("OK") { }
                        } message: {
                            Text(errorMessage)
                        }
                }
                Section {
                    if usedWords.count != 0 {
                        Text("New words")
                            .font(.headline)
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                        }
                    } else {
                        Text("There are no new words yet")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(rootWord)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Insert") {
                        addNewWord()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
