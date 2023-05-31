//
//  CoreDataServiceLite.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit
import CoreData

final class CoreDataServiceLite {

    let appDelegate: AppDelegate
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext

    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.mainContext = appDelegate.persistentContainer.viewContext
        self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.backgroundContext = appDelegate.persistentContainer.newBackgroundContext()
        self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }


    // MARK: - Core Data Saving support

/// Сохраняет пост в БД (в бэкграунд контексте)
    func savePost(_ post: Post, completion: @escaping (Bool) -> Void) {

//        guard let entity = NSEntityDescription.entity(forEntityName: "PostCoreDataModel", in: mainContext) else { return }

        self.backgroundContext.perform {

            let postCoreDataModel = PostCoreDataModel(context: self.backgroundContext)

            postCoreDataModel.id = post.id
            postCoreDataModel.author = post.author
            postCoreDataModel.article = post.article
            postCoreDataModel.image = post.imageName
            postCoreDataModel.likes = post.likes
            postCoreDataModel.views = post.views



            if self.backgroundContext.hasChanges {
                do {
                    try self.backgroundContext.save()
                    self.mainContext.perform {
                        completion(true)
                    }
                } catch {
                    let nserror = error as NSError
                    print("✈️ Error \(nserror.localizedDescription)")
                    self.mainContext.perform {
                        completion(false)
                    }
                }
            } else {
                self.mainContext.perform {
                    completion(false)
                }
            }

        }
    }

/// Получает посты из БД согласно предикату (predicate = nil - получить всё)
    func fetching(predicate: NSPredicate?) -> [PostCoreDataModel] {

        let fetchRequest = PostCoreDataModel.fetchRequest()
        fetchRequest.predicate = predicate

        do {
            let storedPosts = try mainContext.fetch(fetchRequest)
            
            return storedPosts
        } catch {
            return []
        }
    }

/// Удаляет посты из БД согласно предикату (predicate = nil - удалить всё)
    func deletePost(predicate: NSPredicate?) {

        let posts = self.fetching(predicate: predicate)

        posts.forEach {
            self.mainContext.delete($0)
        }

        guard mainContext.hasChanges else {
            return
        }

        do {
            try mainContext.save()
        } catch let error {
            print("AaAaaaaAAaAaAaa ", error)
        }

    }

}
