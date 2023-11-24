//
//  CommentViewModel.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 24.11.23.
//



import Foundation
import SwiftUI
import Combine

final class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    private var cancellables: Set<AnyCancellable> = []
    private var commentRepository = CommentRepository()

    init() {
        $comments
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func fetchComments(for quillID: String) {
        commentRepository.get(for: quillID) { result in
            switch result {
            case .success(let comments):
                DispatchQueue.main.async {
                    self.comments = comments
                }
            case .failure(let error):
                print("Error fetching comments for quill \(quillID): \(error)")
            }
        }
    }


    func addComment(_ comment: Comment, to quillID: String, completion: @escaping (Bool) -> Void) {
            var commentWithQuillID = comment
            commentWithQuillID.quillID = quillID

            commentRepository.addComment(commentWithQuillID, to: quillID) { [weak self] result in
                switch result {
                case .success:
                    self?.fetchComments(for: quillID)
                    completion(true)
                case .failure(let error):
                    print("Error adding comment: \(error)")
                    completion(false)
                }
            }
        }
    
    func deleteComment(_ comment: Comment, from quillID: String) {
            commentRepository.deleteComment(comment, from: quillID) { [weak self] result in
                switch result {
                case .success:
                    self?.fetchComments(for: quillID)
                    print("Comment deleted successfully")
                case .failure(let error):
                    print("Error deleting comment: \(error)")
                }
            }
        }
    
    
}
