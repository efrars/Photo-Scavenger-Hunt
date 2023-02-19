//
//  TaskCell.swift
//  Photo Scavenger Hunt
//
//  Created by Efrain Rodriguez on 2/16/23.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var checkMarkedView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with task: Task) {
        titleLabel.text = task.title
        titleLabel.textColor = task.isComplete ? .secondaryLabel: .label
        checkMarkedView.image = UIImage(systemName: task.isComplete ? "circle.inset.filled": "circle")?.withRenderingMode(.alwaysTemplate)
        checkMarkedView.tintColor = task.isComplete ? .systemBlue :
            .tertiaryLabel
    }

}
