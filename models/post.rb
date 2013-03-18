class Post
  include MongoMapper::Document
  key :rid, String
  key :title, String
  key :subreddit_id
  belongs_to :subreddit
  many :comments
end

Post.ensure_index [[:rid, 1]], :unique => true