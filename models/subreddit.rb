class Subreddit
  include MongoMapper::Document
  key :id, String
  key :title, String
  many :posts
end

Subreddit.ensure_index [[:id, 1]], :unique => true