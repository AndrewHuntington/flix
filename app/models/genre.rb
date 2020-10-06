class Genre < ApplicationRecord
  before_save :set_slug
  
  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations

  validates :name, presence: true, 
                   format: { with: /\A[A-Z0-9\-_ ]+\z/i }, uniqueness: true

  def to_param
    slug
  end

  private

    def set_slug
      self.slug = name.parameterize
    end

end
