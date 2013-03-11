class Post
  include MongoMapper::Document
  belongs_to :subreddit
  key :id, String
  key :title, String
  many :comments
end

Post.ensure_index [[:id, 1]], :unique => true