import SwiftUI

struct MainView: View {
    @State private var isPresenting = false
    @State private var selectedItem = 1
    @State private var oldSelectedItem = 1

    var body: some View {
        TabView(selection: $selectedItem) {
            NavigationView {
                HomeView(quillViewModel: QuillViewModel())
                    .tabItem {
                        VStack {
                            Image(systemName: "house")
                                .font(Font.system(size: 20))
                            Text("Home")
                                .font(Font.custom("SpaceMono-Regular", size: 12))
                            }
                    }
                .tag(1)
            }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                        .font(Font.custom("SpaceMono-Regular", size: 12))
                }
                .tag(2)


            Text("New Quill")
                .onTapGesture {
                    self.isPresenting = true
                }
                .tabItem {
                    Label("New Quill", systemImage: "pencil.circle")
                        .font(Font.custom("SpaceMono-Regular", size: 12))
                }
                .tag(3)

            NotificationView()
                .tabItem {
                    Label("Alerts", systemImage: "bubble.left.and.exclamationmark.bubble.right.fill")
                        .font(Font.custom("SpaceMono-Regular", size: 12))
                }
                .tag(4)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                        .font(Font.custom("SpaceMono-Regular", size: 12))
                }
                .tag(5)
        }
        .onChange(of: selectedItem) { newValue in
            if newValue == 3 {
                self.isPresenting = true
                self.selectedItem = self.oldSelectedItem
            } else if isPresenting == false {
                self.oldSelectedItem = newValue
            }
        }
        .sheet(isPresented: $isPresenting) {
            NewQuillView(isPresenting: $isPresenting, quillViewModel: QuillViewModel())
        }
        .accentColor(Color("QBlack"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthViewModel())
    }
}
