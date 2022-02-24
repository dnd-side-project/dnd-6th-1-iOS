//
//  WriteDiaryVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import BSImagePicker

class WriteDiaryVC: UIViewController {
    
    @IBOutlet weak var dateTitleView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var disposeBag = DisposeBag()
    var selectedDate: String!
    let emotionView = EmotionView()
    var postWriteView = PostWriteView()
    var scrollView = UIScrollView()
    var emotionTextField = UITextField()
    var lineView = UIView()
    var stackView = UIStackView()
    var contentView = UIView()
    var imageAddBar = ImageAddBar()
    let textViewPlaceHolder = "오늘은 어떤 하루였나요?"
    let writeDirayVM = WriteDiaryVM()
    var imageListView = ImageCollectionView()
    let maxImageSelectionCount = 3
    let minimumLineSpacing: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUIValue()
        addViewsToVC()
        configureEmotionView()
        configureEmotionTextField()
        configureLineView()
        configureScrollView()
        configureContentView()
        configurePostWriteView()
        configureImageScrollView()
        configureImageAddBar()
        bindUI()
        bindVM()
    }
}

// MARK: - Change UI
extension WriteDiaryVC {
    private func setInitialUIValue() {
        cancelButton.contentHorizontalAlignment = .leading
        saveButton.contentHorizontalAlignment = .trailing
        dateLabel.text = selectedDate
    }
    
    private func addViewsToVC() {
        view.addSubview(emotionView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(emotionTextField)
        contentView.addSubview(lineView)
        contentView.addSubview(postWriteView)
        contentView.addSubview(imageListView)
        view.addSubview(imageAddBar)
    }
    
    private func configureEmotionView() {
        emotionView.snp.makeConstraints {
            $0.top.equalTo(dateTitleView.snp.bottom).offset(27)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(view.frame.width / 2.88 - 27)
        }
    }
    
    private func configureScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    
        scrollView.snp.makeConstraints {
            $0.top.equalTo(emotionView.snp.bottom)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-54)
            $0.width.equalTo(view.frame.width - 60)
        }
    }
    
    private func configureContentView() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
    }
      
    private func configureEmotionTextField() {
        emotionTextField.placeholder = "감정 한마디"
        emotionTextField.font = UIFont.SpoqaHanSansNeoBold(size: 15)
        emotionTextField.setPlaceholderColor(.lightGray5)
        
        emotionTextField.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
    
    private func configureLineView() {
        lineView.backgroundColor = .lightGray5
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(emotionTextField.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func configurePostWriteView() {
        postWriteView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(25)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(imageListView.snp.top).offset(-25)
        }
        
        postWriteView.contents.delegate = self
        postWriteView.setTitlePlaceholder("제목")
        postWriteView.setContentsPlaceholder(textViewPlaceHolder)
    }
    
    private func configureImageScrollView() {
        imageListView.snp.makeConstraints {
            $0.top.equalTo(postWriteView.snp.bottom).offset(25)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureImageAddBar() {
        imageAddBar.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
    }
}

// MARK: - Bindings
extension WriteDiaryVC {
    private func bindUI() {
        cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        imageAddBar.addImageButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pressedAddImageButton()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        imageListView.numberOfImages
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] imageCount in
                guard let self = self else { return }
                self.setImageCVHeight(imageCount)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods related to images
extension WriteDiaryVC {
    func pressedAddImageButton() {
        let imagePicker = ImagePickerController(selectedAssets: imageListView.selectedAssets)
        
        imagePicker.cancelButton.tintColor = .primary
        imagePicker.doneButton.tintColor = .primary
        imagePicker.settings.theme.selectionFillColor = .primary
        
        imagePicker.settings.selection.max = maxImageSelectionCount
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.theme.selectionStyle = .numbered
        
        self.presentImagePicker(imagePicker, select: { (asset) in
        }, deselect: { (asset) in
        }, cancel: { (assets) in
        }, finish: { (assets) in
            self.writeDirayVM.convertAssetToImages(assets, self.imageListView)
            self.writeDirayVM.addImageToCollectionView(self.imageListView.selectedImages, self.imageListView)
            self.setImageCVHeight(self.imageListView.selectedImages.count)
            self.imageListView.selectedAssets = assets
        }, completion: {
        })
    }
    
    func setImageCVHeight(_ imageCount: Int) {
        if imageCount == 0 {
            imageListView.snp.makeConstraints {
                $0.height.equalTo(0)
            }
        } else {
            imageListView.snp.makeConstraints {
                $0.height.equalTo(CGFloat(imageCount) * (imageListView.imageCV.frame.width + minimumLineSpacing) - minimumLineSpacing)
            }
        }
    }
}

// MARK: - TextView Delegate
extension WriteDiaryVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.setTextViewPlaceholder(textViewPlaceHolder)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder(textViewPlaceHolder)
        }
    }
}
