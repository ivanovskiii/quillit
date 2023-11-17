//
//  NewQuillView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct NewQuillView: View {
    @State private var title = ""
    @State private var content = ""
    @Binding var isPresenting: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var quillViewModel: QuillViewModel

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $title, prompt: Text("Title"))
                            .autocorrectionDisabled(true)
                            .font(Font.custom("Ahsing", size: 23))
                            .foregroundColor(Color("QBlack"))
                            .textInputAutocapitalization(.never)
                            .padding(5)
                            .frame(minHeight: 21, maxHeight: .infinity)
                    }

                    Section {
                        TextEditor(text: $content)
                            .frame(minHeight: 250, maxHeight: .infinity)
                            .font(Font.custom("PTSans-Regular", size: 18))
                            .foregroundColor(Color("QBlack"))
                    }
                    .foregroundColor(Color.gray)
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresenting = false
                }
                    .font(Font.custom("SpaceMono-Regular", size: 17))
                ,
                trailing: Button("Post") {
                    // Handle post action
                    
                    let quill = Quill(title: title, content: content, user: authViewModel.currentUser!, likedBy: [], comments: [], postedDateTime: Date())
                    
                    quillViewModel.add(quill)
                    let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                    impactMed.impactOccurred()
                    print("DEBUG: ", quill)
                    isPresenting = false
                }
                    .font(Font.custom("SpaceMono-Regular", size: 17))
            )
        }
    }
}

struct NewQuillView_Previews: PreviewProvider {
    static var previews: some View {
        NewQuillView(isPresenting: .constant(false), quillViewModel: QuillViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(QuillViewModel())
    }
}

