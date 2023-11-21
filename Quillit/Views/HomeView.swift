//
//  HomeView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var quillViewModel: QuillViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(alignment: .center){
            VStack (alignment: .center) {
                Image("quillit-logo-black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .frame(maxWidth: .infinity, alignment: .top)
                
                Picker(selection: $selectedTab, label: Text("Tab")) {
                    Text("For You")
                        .tag(0)
                        .font(Font.custom("SpaceMono-Regular", size: 15))
                    Text("Following")
                        .tag(1)
                        .font(Font.custom("SpaceMono-Regular", size: 15))
                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                                .padding(.top, 5)
            }
            
            ScrollView {
                ForEach(quillViewModel.quills.sorted(by: { $0.postedDateTime > $1.postedDateTime })) { quill in
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
