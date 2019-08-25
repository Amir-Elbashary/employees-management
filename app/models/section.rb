class Section < ApplicationRecord
  acts_as_tree order: 'name'

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, if: :root_section?

  has_many :employees, dependent: :destroy
  has_many :sub_sections, class_name: 'Section', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Section', optional: true

  accepts_nested_attributes_for :sub_sections, allow_destroy: true,
                                               reject_if: ->(a) { a[:name].blank? }

  def root_section?
    return true if root?
    false
  end
end
