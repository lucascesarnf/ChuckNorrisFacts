import UIKit

let categories = ["CAT4", "CAT2", "CAT4",
                  "CAT3", "CAT%", "HUSHUH,",
                  "jdfn"]
let columns = 3

private func categoriesByColumn() {
    categories
    let numberOfLines = categories.count / columns
    
    for line in 0...numberOfLines {
        for column in line...(columns * line)
    }
}
