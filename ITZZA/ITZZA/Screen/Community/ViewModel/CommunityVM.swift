////
////  CommunityVM.swift
////  ITZZA
////
////  Created by 황윤경 on 2022/01/31.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//import Alamofire
//
//protocol CommunityVMOutput {
//    var _articles: BehaviorRelay<[PostModel]> { get }
//    var dataSource: Observable<[PostDataSource]> { get }
//}
//
//extension CommunityVMOutput {
//    var dataSource: Observable<[PostDataSource]> {
//        _articles
//            .map {
//                [PostDataSource(section: 0, items: $0)]
//            }
//    }
//}
//
//class CommunityVM {
//    var bag = DisposeBag()
//    
//    var input = Input()
//    var output = Output()
//
//    struct Input {}
//
//    struct Output: CommunityVMOutput {
//        var _articles = BehaviorRelay<[PostModel]>(value: [])
//    }
//    
//    init() {
//        bindInput()
//        bindOutput()
//    }
//    
//    deinit {
//        bag = DisposeBag()
//    }
//}
//
//extension CommunityVM {
//    func fetchAll() {
//        
//    }
//    
//    func retrieveArticles() {
////        self.output._articles.accept([ModelArticle])
//    }
//}
//
//extension CommunityVM {
//    func bindInput() { }
//    func bindOutput() { }
//}
//
//
//protocol Output {
//  associatedtype Output // *프로토콜의 제네릭 타입
//
//  var output: Output { get }
//
//  func bindOutput()
//}
//
//protocol Input {
//  associatedtype Input // *프로토콜의 제네릭 타입, Swift 언어에 관련된 것.
//
//  var input: Input { get }
//
//  func bindInput()
//}
