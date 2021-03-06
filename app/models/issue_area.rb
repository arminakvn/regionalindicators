class IssueArea < ActiveRecord::Base
  attr_accessible :datacommon_url,
                  :icon,
                  :title,
                  :sort_order

  has_and_belongs_to_many :indicators
  
  DATACOMMON_REGEX = /metrobostondatacommon.org/

  validates :title, presence: true, length: { maximum: 35, minimum: 6 }
  validates :icon, presence: true
  validates :datacommon_url, presence: true, format: { with: DATACOMMON_REGEX }

  scope :ordered, where('sort_order IS NOT NULL').order('sort_order')

  include SlugExtension
  alias_method :css_class, :slug

  def indicators
    Array(self.taggable).keep_if { |e| e.class.name == "Indicator" }
  end

  rails_admin do
    list do
      field :id
      field :title
      field :icon
      field :sort_order
    end
  end

end