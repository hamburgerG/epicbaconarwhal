class Subreddit
  include MongoMapper::Document
  key :rid, String
  key :title, String
  many :posts
end

Subreddit.ensure_index [[:rid, 1]], :unique => true