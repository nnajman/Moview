//
//  MyReviewsViewController.swift
//  Moview
//
//  Created by admin on 18/07/2021.
//

import UIKit
import Kingfisher
import Firebase

class MyReviewsViewController: UIViewController {
    @IBOutlet weak var myReviewsTableView: UITableView!
    var data = [Review]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myReviewsTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action:#selector(refresh) , for: .valueChanged)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(longPressGesture)
        
        reloadData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.reloadData()
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.myReviewsTableView)
            if let indexPath = myReviewsTableView.indexPathForRow(at: touchPoint) {
                print(indexPath.row)
                let alert = UIAlertController(
                    title: nil,
                    message: nil,
                    preferredStyle: .actionSheet
                )

                alert.addAction(
                    .init(title: "Edit", style: .default) { _ in
                        // TODO: edit review
                        print("edit")
                    }
                )

                alert.addAction(
                    .init(title: "Delete", style: .destructive) { _ in
                        // TODO: delete review
                        print("delete")
                    }
                )
                
                alert.addAction(
                    .init(title: "Cancel", style: .cancel) { _ in
                })

                present(alert, animated: true)
            }
        }
    }
    
    func reloadData(){
        refreshControl.beginRefreshing()
        Model.instance.getReviews(byUserId: Auth.auth().currentUser!.uid) { reviews in
            self.data = reviews
            self.myReviewsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension MyReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myReviewsTableView.dequeueReusableCell(withIdentifier: "myReviewListRow", for: indexPath) as! MyReviewsTableViewCell
        
        let review = data[indexPath.row]
        cell.MovieNameText.text = review.movieName
        cell.releaseYearText.text = String(review.releaseYear)
        cell.genreText.text = review.genre
        cell.movieImage.kf.setImage(with: URL(string: (review.imageUrl)!), placeholder: UIImage(named: "Default Avatar"))
        
        return cell
    }
}

extension MyReviewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
