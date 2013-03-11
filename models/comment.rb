class Comment
  include MongoMapper::Document
  belongs_to :post
  key :id, String
  key :author, String
  key :body, String
  key :created_utc, Float
  key :downs, Fixnum
  key :ups, Fixnum
end

Comment.ensure_index [[:id, 1]], :unique => true