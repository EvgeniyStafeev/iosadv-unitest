//
//  CDserviceVer3.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.11.2022.
//

import UIKit
import CoreData

final class CDserviceVer3 {

    private let appDelegate: AppDelegate
    private var context: NSManagedObjectContext?
    var fecthedResultsController: NSFetchedResultsController<PostCoreDataModel>?

    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.context?.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        guard let context = self.context else { fatalError() }

        let fetchRequest = PostCoreDataModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [
            sortDescriptor
        ]
        self.fecthedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
//        self.fecthedResultsController?.delegate = self
    }

    func fetchPosts(predicate: NSPredicate?, completion: () -> Void = {}) {
        fecthedResultsController?.fetchRequest.predicate = predicate
        do {
            try self.fecthedResultsController?.performFetch()
            if fecthedResultsController?.fetchedObjects?.count == 0 {
                completion()
            }
        } catch {
            fatalError("Can't fetch data from db")
        }
    }

    func deletePost(indexPath: IndexPath) {
        let deletePost = self.fecthedResultsController?.object(at: indexPath)
        self.context?.delete(deletePost!)
        do {
            try self.context?.save()
        } catch let error{
            print("😡 ", error)
        }
    }

    func addToDb(post: Post) {
        guard let context = self.context else { return }
        let postCoreDataModel = PostCoreDataModel(context: context)

        postCoreDataModel.id = post.id
        postCoreDataModel.author = post.author
        postCoreDataModel.article = post.article
        postCoreDataModel.image = post.imageName
        postCoreDataModel.likes = post.likes
        postCoreDataModel.views = post.views

        do {
            try context.save()
        } catch let error{
            print("😡 ", error)
        }
    }

}
