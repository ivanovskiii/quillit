//
//  NotificationView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject private var quillViewModel: QuillViewModel

    var body: some View {
        VStack {
            Text("Alerts")
                .font(Font.custom("Ahsing", size: 25))

            ForEach(quillViewModel.notifications, id: \.self) { notification in
                Text(notification)
                    .font(Font.custom("SpaceMono-Regular", size: 15))
            }

            Spacer()
        }
    }
}



struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
