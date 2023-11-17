//
//  HomeView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var quillViewModel: QuillViewModel
    
    var body: some View {
        VStack(alignment: .center){
            VStack (alignment: .center) {
                Image("quillit-logo-black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .frame(maxWidth: .infinity, alignment: .top)
            }
            
            ScrollView {
                ForEach(quillViewModel.quills) { quill in
                    QuillCardView(quill: quill)
                        .padding(.bottom, 5)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(quillViewModel: QuillViewModel())
    }
}
