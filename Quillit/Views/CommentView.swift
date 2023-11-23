//
//  CommentView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 23.11.23.
//

import SwiftUI

struct CommentView: View {
    var comment: Comment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(comment.user.username)")
                .font(Font.custom("SpaceMono-Italic", size: 15))
                .foregroundColor(Color.gray)

            Text(comment.content)
                .foregroundColor(Color("QBlack"))
                .font(Font.custom("PTSans-Regular", size: 18))

            HStack {
                // Add buttons for liking and replying to comments if needed

                Spacer()
            }
            .font(.subheadline)
            .foregroundColor(Color("QBlack"))
            .padding(.top, 5)
        }
        .padding()
        .frame(minHeight: 120, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}


struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleComment = Comment(id: "1", content: "Example Comment", user: User(id: "1", username: "User123", email: "user@example.com", followers: [], following: []), likedBy: [], replies: [], postedDateTime: Date())
        CommentView(comment: exampleComment)
    }
}
