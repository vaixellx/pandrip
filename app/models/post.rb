class Post < ApplicationRecord
  STATUSES = %w(draft active)

  belongs_to :user
  has_many :comments
  has_many :commentors, through: :comments, source: :user
  has_one :comment, -> { where(top_comment: true) }

  scope :drafts, -> { where(status: :draft) }
  scope :by_admin, -> (user_id=1) { where(user_id: user_id) }
  scope :by_recent, -> { order(:created_at) }
  scope :recent_by_admin, -> { by_recent.by_admin }

  validates_presence_of :title
  validates_presence_of :body, if: -> { status == 'active' }

  # -> () {} id eq lambda {}
  before_validation :set_default_title, if: -> { title.blank? }
  before_save :say_hello

  def self.by_admin(user)
    where(user_id: user)
  end

  private

    def say_hello
      if title == 'draft'
        title = 'active'
      end ; true
    end

    def set_default_title
      self.title = 'Default'
    end
end
