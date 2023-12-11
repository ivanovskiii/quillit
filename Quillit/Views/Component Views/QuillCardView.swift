//
//  QuillCardView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 17.11.23.
//

import SwiftUI

struct QuillCardView: View {
    var quill: Quill

    @EnvironmentObject private var authViewModel: AuthViewModel
    @ObservedObject private var quillViewModel = QuillViewModel()
    @ObservedObject private var commentViewModel = CommentViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NavigationLink(destination: ProfileView(quillViewModel: QuillViewModel(), userViewModel: UserViewModel(), user: quill.user)){
                Text("\(quill.user.username)")
                    .font(Font.custom("SpaceMono-Italic", size: 15))
                    .foregroundColor(Color.gray)
            }

            NavigationLink(destination: FullQuillView(quill: quill)) {
                Text("\(quill.title) >")
                    .font(Font.custom("Ahsing", size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Color("QBlack"))
            }

            Text(quill.content)
                .foregroundColor(Color("QBlack"))
                .font(Font.custom("PTSans-Regular", size: 18))

            HStack {
                Button(action: {
                    toggleLike()
                }) {
                    Image(systemName: quill.isLiked(by: authViewModel.currentUser?.id ?? "") ? "heart.fill" : "heart")
                        .foregroundColor(quill.isLiked(by: authViewModel.currentUser?.id ?? "") ? Color("QRed") : .black)
                }
                Text("\(quill.likedBy.count)")
                    .font(Font.custom("SpaceMono-Regular", size: 15))

                Image(systemName: "message")
                Text("\(commentViewModel.comments.count)")
                    .font(Font.custom("SpaceMono-Regular", size: 15))

                Spacer()
            }
            .font(.subheadline)
            .foregroundColor(Color("QBlack"))
            .padding(.top, 5)
            .onAppear{
                commentViewModel.fetchComments(for: quill.id ?? "")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxHeight: 400)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .contextMenu {
            if authViewModel.currentUser?.id == quill.user.id {
                Button(action: {
                    quillViewModel.delete(quill)
                }) {
                    Label("Delete \(quill.title)", systemImage: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }

    private func toggleLike() {
            Task {
                await quillViewModel.toggleLike(quill, user: authViewModel.currentUser)
            }
        }
}

struct QuillCardView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleQuill = Quill(id: "1", title: "Example Title", content: "Example Content", user: User(id: "1", username: "User123", email: "user@example.com", followers: [], following: []), likedBy: [], postedDateTime: Date())
        QuillCardView(quill: exampleQuill)
            .environmentObject(AuthViewModel())
    }
}
