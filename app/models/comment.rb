class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId

  field :content
  field :score

  belongs_to :author, class_name: "User", inverse_of: "comments"
  belongs_to :item, class_name: "User", inverse_of: "comments"

  validates_presence_of :author_id
  validates_presence_of :item_id

  after_save :destroy_if_emptied

  protected

  def destroy_if_emptied
    self.destroy if content.nil? and score.nil?
  end
end
