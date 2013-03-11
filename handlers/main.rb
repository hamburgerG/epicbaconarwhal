get '/' do
  erb :index
end

get '/populate' do
  reddit = Snooby::Client.new('adam\'s comment grabber')
  reddit.authorize!('adamtest', '123qwe')
  comments = reddit.subreddit('all').comments(500)
  comments.each do |comment|
    s = Subreddit.new
    s.id = comment.subreddit_id
    s.title = comment.subreddit
    s.save

    p = Post.new
    p.subreddit = Subreddit.first(:id => comment.subreddit_id)
    p.id = comment.link_id
    p.title = comment.link_title
    p.save

    c = Comment.new
    c.post = Post.first(:id => comment.link_id)
    c.id = comment.id
    c.author = comment.author
    c.body = comment.body
    c.created_utc = comment.created_utc
    c.downs = comment.downs
    c.ups = comment.ups
    c.save
  end
  redirect '/view'
end

get '/view' do
  @s_count = Subreddit.count
  @p_count = Post.count
  @c_count = Comment.count
  erb :view
end

get '/all.json' do
  content_type :json
  Subreddit.all.to_json
end