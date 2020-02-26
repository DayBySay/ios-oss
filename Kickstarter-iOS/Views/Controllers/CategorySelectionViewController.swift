import Foundation
import KsApi
import Library
import Prelude
import SpriteKit
import UIKit

public final class CategorySelectionViewController: UIViewController {
  private let viewModel: CategorySelectionViewModelType = CategorySelectionViewModel()
  private let dataSource = CategorySelectionDataSource()

  private lazy var tableView: UITableView = {
    UITableView(frame: .zero)
      |> \.backgroundColor .~ .clear
      |> \.allowsSelection .~ false
      |> \.dataSource .~ self.dataSource
      |> \.estimatedRowHeight .~ 100
      |> \.separatorStyle .~ .none
      |> \.rowHeight .~ UITableView.automaticDimension
  }()

  private lazy var backgroundHeaderView: UIView = {
    UIView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  private lazy var backgroundHeaderHeightConstraint: NSLayoutConstraint = {
    self.backgroundHeaderView.heightAnchor.constraint(equalToConstant: 200)
  }()

  public override func viewDidLoad() {
    super.viewDidLoad()

    _ = self
      |> baseControllerStyle()

    self.tableView.registerCellClass(CategorySelectionCell.self)

    self.configureSubviews()
    self.setupConstraints()
    self.configureHeaderView()

    self.viewModel.inputs.viewDidLoad()
  }

  override public func bindStyles() {
    super.bindStyles()

    _ = self.backgroundHeaderView
      |> \.backgroundColor .~ UIColor.ksr_trust_700
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    self.tableView.ksr_sizeHeaderFooterViewsToFit()

    self.backgroundHeaderHeightConstraint.constant = self.tableView.tableHeaderView?.frame.size.height ?? 0
  }

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  public override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.loadCategorySections
      .observeForUI()
      .observeValues { [weak self] categories in
        self?.dataSource.load(categories: categories)
        self?.tableView.reloadData()
      }
  }

  private func configureSubviews() {
    _ = (self.backgroundHeaderView, self.view)
      |> ksr_addSubviewToParent()

    _ = (self.tableView, self.view)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      self.backgroundHeaderView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.backgroundHeaderView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.backgroundHeaderView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.backgroundHeaderHeightConstraint
    ])
  }

  private func configureHeaderView() {
    let headerContainer = UIView(frame: .zero)
      |> \.backgroundColor .~ UIColor.ksr_trust_700
      |> \.accessibilityTraits .~ .header
      |> \.isAccessibilityElement .~ true

    let categorySelectionHeader = CategorySelectionHeaderView(frame: .zero)

    _ = (categorySelectionHeader, headerContainer)
      |> ksr_addSubviewToParent()

    self.tableView.tableHeaderView = headerContainer

    _ = (categorySelectionHeader, headerContainer)
      |> ksr_constrainViewToEdgesInParent()

    let widthConstraint = categorySelectionHeader.widthAnchor
      .constraint(equalTo: self.tableView.widthAnchor)
      |> \.priority .~ .defaultHigh

    NSLayoutConstraint.activate([widthConstraint])
  }
}
