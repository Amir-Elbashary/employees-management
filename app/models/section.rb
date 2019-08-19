class Section < ApplicationRecord
  acts_as_tree order: 'name'

  validates :name, presence: true

  has_many :sub_sections, class_name: 'Section', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Section', optional: true

  accepts_nested_attributes_for :sub_sections, allow_destroy: true,
                                               reject_if: ->(a) { a[:name].blank? }
end
