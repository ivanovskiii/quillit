//
//  QuillViewModel.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 17.11.23.
//

import Combine

final class QuillViewModel: ObservableObject{
    @Published var quillRepository = QuillRepository()
    @Published var quills: [Quill] = []

    private var cancellables: Set<AnyCancellable> = []

    init(){
        quillRepository.$quills
            .assign(to: \.quills, on: self)
            .store(in: &cancellables)
    }

    func add(_ quill: Quill){
        quillRepository.add(quill)
    }
    
    func delete(_ quill: Quill) {
        quillRepository.delete(quill)
    }
    
    func update(_ quill: Quill) {
        do{
           try  quillRepository.update(quill)
        } catch{
            print("Could not update Quill!")
        }
    }
}
