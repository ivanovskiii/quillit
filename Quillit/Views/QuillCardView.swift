//
//  QuillCardView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 17.11.23.
//

import SwiftUI

struct QuillCardView: View {
    var quill: Quill

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("\(quill.user.username)")
                .font(Font.custom("SpaceMono-Italic", size: 15))
                .foregroundColor(Color.gray)
            
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

                Image(systemName: "heart")
                Text("\(quill.likedBy.count)")
                    .font(Font.custom("SpaceMono-Regular", size: 15))

                Image(systemName: "message")
                Text("\(quill.comments.count)")
                    .font(Font.custom("SpaceMono-Regular", size: 15))
                
                Spacer()
            }
            .font(.subheadline)
            .foregroundColor(Color("QBlack"))
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxHeight: 400)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct QuillCardView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleQuill = Quill(id: "1", title: "Example Title", content: "Example Content", user: User(id: "1", username: "User123", email: "user@example.com", followers: [], following: []), likedBy: [], comments: [], postedDateTime: Date())
        QuillCardView(quill: exampleQuill)
    }
}
