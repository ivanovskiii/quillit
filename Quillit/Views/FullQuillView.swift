//
//  FullQuillView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 17.11.23.
//

import SwiftUI

struct FullQuillView: View {
    var quill: Quill

    @EnvironmentObject private var authViewModel: AuthViewModel
    @ObservedObject private var quillViewModel = QuillViewModel()
    @ObservedObject private var commentViewModel = CommentViewModel()
    @State private var showContextMenu = false
    @State private var commentText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(quill.user.username)")
                    .font(Font.custom("SpaceMono-Italic", size: 15))
                    .foregroundColor(Color.gray)

                Text(quill.title)
                    .font(Font.custom("Ahsing", size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Color("QBlack"))

                Text(quill.content)
                    .foregroundColor(Color("QBlack"))
                    .font(Font.custom("PTSans-Regular", size: 18))

                HStack {
                    Button(action: {
                        toggleLike()
                    }) {
                        Image(systemName: quill.isLiked(by: authViewModel.currentUser?.id ?? "") ? "heart.fill" : "heart")
                            .foregroundColor(quill.isLiked(by: authViewModel.currentUser?.id ?? "") ? .pink : .black)
                    }
                    Text("\(quill.likedBy.count)")
                        .font(Font.custom("SpaceMono-Regular", size: 15))

                    Image(systemName: "message")
                    Text("\(commentViewModel.comments.count)")
                        .font(Font.custom("SpaceMono-Regular", size: 15))

                    Spacer()

                    if authViewModel.currentUser?.id == quill.user.id {
                        Image(systemName: "ellipsis")
                            .font(Font.custom("SpaceMono-Regular", size: 25))
                            .onTapGesture {
                                showContextMenu = true
                            }
                            .confirmationDialog("Options", isPresented: $showContextMenu, titleVisibility: .visible){
                                Button("Delete \(quill.title)", role: .destructive){
                                    quillViewModel.delete(quill)
                                }
                            }
                    }
                }
                .font(.subheadline)
                .foregroundColor(Color("QBlack"))
                .padding(.top, 5)
                
                Spacer()
                
                TextField("Add a comment", text: $commentText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                // Button to add a comment
                Button("Add Comment") {
                    addComment()
                }
                
            }
            .padding()
            .frame(minHeight: 180, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .navigationBarTitle("\(quill.title)", displayMode: .inline)
            
            Text("Comments (\(commentViewModel.comments.count))")
                .font(Font.custom("SpaceMono-Regular", size: 16))
            
            ForEach(commentViewModel.comments) { comment in
                        CommentView(comment: comment)
            }
            
        }.onAppear{
            commentViewModel.fetchComments(for: quill.id ?? "")
        }
        
        
        

    }
    
    private func addComment() {
            guard !commentText.isEmpty else { return }

            let newComment = Comment(id: UUID().uuidString, content: commentText, user: authViewModel.currentUser!, likedBy: [], replies: [], postedDateTime: Date())

            commentViewModel.addComment(newComment, to: quill.id!) { success in
                if success {
                    // Fetch updated comments after adding a new one
                    commentViewModel.fetchComments(for: quill.id ?? "")
                } else {
                    // Handle error if needed
                    print("Error adding comment")
                }
            }

            commentText = "" // Clear the comment input field
        }

    
    private func toggleLike() {
            Task {
                await quillViewModel.toggleLike(quill, user: authViewModel.currentUser)
            }
        }
        
        
    }



struct FullQuillView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleQuill = Quill(id: "1", title: "Example Title", content: "Example Content", user: User(id: "1", username: "User123", email: "user@example.com", followers: [], following: []), likedBy: [], postedDateTime: Date())
        FullQuillView(quill: exampleQuill)
            .environmentObject(AuthViewModel())
    }
}
