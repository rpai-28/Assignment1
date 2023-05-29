//
//  CountryModel.swift
//  Assignment1
//
//  Created by Reshma Pai on 28/05/23.
//


import RxSwift
import RxCocoa
import UIKit

class CountryViewModel {
    
    var model: Observable<DataResponseModel>?
    var image: Observable<Data?>?
    private var pageTitle = BehaviorRelay<String>(value: String())
    private var countryDetails = BehaviorRelay<[RowItem]>(value: [])
    private var detailsImages = BehaviorRelay<[Int:Data?]>(value: [:])
    var countryDetailsObserver: Observable<[RowItem]> {
        return self.countryDetails.asObservable()
    }
    var pageTitleObserver: Observable<String> {
        return self.pageTitle.asObservable()
    }
    var detailsImagesObserver: Observable<[Int:Data?]> {
        return self.detailsImages.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    func getCountryInfo() {
        let apiRequest = APIRequest()
        let apiHelper = APIHelper()
        if let url = apiHelper.getApiURL(type: .country) {
            model = apiRequest.callAPI(url: url)
            model?.subscribe(onNext: { countryDetails in
                self.pageTitle.accept(countryDetails.title ?? "")
                self.countryDetails.accept(countryDetails.rows ?? [] )
            }, onError: { error in
                _ = self.countryDetails.catch { error in
                    Observable.empty()
                }
                _ = self.pageTitle.catch { error in
                    Observable.empty()
                }
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        }
    }
    
    func getImages() {
        let apiRequest = APIRequest()
        
        countryDetailsObserver.subscribe(onNext: { rowItems in
            var imageData = [Int: Data?]()
            for (index,rowItem) in rowItems.enumerated() {
                if let urlString = rowItem.imageHref, let url = URL(string: urlString) {
                    self.image = apiRequest.callImageAPI(url: url)
                    self.image?.subscribe(onNext: { data in
                        imageData[index] = data
                        self.detailsImages.accept(imageData)
                    }, onError: { error in
                        print(error.localizedDescription)
                    }).disposed(by: self.disposeBag)
                }
            }
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
