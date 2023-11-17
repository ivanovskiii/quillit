//
//  FullQuillView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 17.11.23.
//

import SwiftUI

struct FullQuillView: View {
    var quill: Quill

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
            .frame(minHeight: 180, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.vertical, 8)
        .navigationBarTitle("\(quill.title)", displayMode: .inline)
        }
    }
}

struct FullQuillView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleQuill = Quill(id: "1", title: "Example Title", content: "Example Content", user: User(id: "1", username: "User123", email: "user@example.com", followers: [], following: []), likedBy: [], comments: [], postedDateTime: Date())
        FullQuillView(quill: exampleQuill)
    }
}
