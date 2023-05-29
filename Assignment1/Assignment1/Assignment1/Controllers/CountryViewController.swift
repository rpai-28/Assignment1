//
//  CountryViewController.swift
//  Assignment1
//
//  Created by Reshma Pai on 27/05/23.
//

import UIKit
import RxSwift
import RxCocoa

class CountryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let countryViewModel = CountryViewModel()
    let countryDetails = BehaviorRelay<[RowItem?]>(value: [])
    let pageTitle = BehaviorRelay<String?>(value: String())
    let images = BehaviorRelay<[Int:Data?]>(value: [:])
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        countryViewModel.getCountryInfo()
        
        countryViewModel.countryDetailsObserver.subscribe(onNext: { countryDetails in
            self.countryDetails.accept(countryDetails)
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
        
        _ = countryViewModel.countryDetailsObserver.subscribe(onNext: { rowItems in
            self.countryViewModel.getImages()
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)

        countryViewModel.pageTitleObserver.subscribe(onNext: { pageTitle in
            self.pageTitle.accept(pageTitle)
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
        
        countryViewModel.detailsImagesObserver.subscribe(onNext: { imagesData in
            self.images.accept(imagesData)
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)

        _ = pageTitle.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        
        countryDetails.bind(to: tableView.rx.items(cellIdentifier: Constants.cellIdentifier, cellType: CountryDetailsTableViewCell.self)) { row,
            model, cell in
            
            cell.setupCellUI()
            cell.setupTitle(text: model?.title)
            cell.setupDescription(text: model?.description)

            self.countryViewModel.detailsImagesObserver.subscribe(onNext: { images in
                DispatchQueue.main.async {
                    if let image = images[row] {
                        cell.setImageView(data: image)
                    }
                }
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
}

fileprivate extension CountryViewController {
    func registerCell() {
        tableView.register(CountryDetailsTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    func setupUI() {
        registerCell()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}
 
extension CountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}
