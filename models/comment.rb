class Comment
  include MongoMapper::Document
  key :rid, String
  key :author, String
  key :body, String
  key :created_utc, Float
  key :downs, Fixnum
  key :ups, Fixnum

  key :post_id
  
  belongs_to :post
end

Comment.ensure_index [[:rid, 1]], :unique => true