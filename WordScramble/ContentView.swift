//
//  ContentView.swift
//  WordScramble
//
//  Created by Kevin Darmawan on 27/12/24.
//

import SwiftUI

struct ContentView: View {

    let people = ["Finn", "Leia", "Luke", "Rey"]

    var body: some View {
        VStack {
            List {
                Section {
                    Text("Static row 1")
                    Text("Static row 2")
                }
                Section {
                    ForEach(0..<5) {
                        Text("Dynamic row \($0)")
                    }
                }
                Section {
                    Text("Static row 3")
                    Text("Static row 4")
                }
            }
            List(people, id: \.self) {
                Text($0)
            }
            List {
                Text("Static Row")
                ForEach(people, id: \.self) {
                    Text($0)
                }
                Text("Static Row")
            }
        }
        VStack {
            if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
                // we found the file in our bundle!
                if let fileContents = try? String(contentsOf: fileURL, encoding: .ascii) {
                    // we loaded the file into a string!
                }
            }
        }
    }
    func testString() -> [String]{
        let input = "a b c"
        let input2 = """
                     a
                     b
                     c
                     """
        let letters = input.components(separatedBy: " ")
        let _ = input2.components(separatedBy: "\n")
        let _ = letters.randomElement()
        let _ = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return letters
    }
    
    func testWord() {
        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = misspelledRange.location == NSNotFound
    }
}

#Preview {
    ContentView()
}
