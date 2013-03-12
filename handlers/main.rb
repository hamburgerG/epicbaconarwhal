get '/' do
  @s_count = Subreddit.count
  @p_count = Post.count
  @c_count = Comment.count
  erb :index
end

get '/subreddits' do
  @all = Subreddit.all(:order => :title.asc)

  erb :subreddits
end

get '/posts' do
  @all = Post.all(:order => :title.asc)

  erb :posts
end

get '/comments' do
  @all = Comment.all(:order => :author.asc)

  erb :comments
end

get '/r/:subreddit_id' do
  @subreddit = Subreddit.first(:rid => params[:subreddit_id])
  @posts = @subreddit.posts
  erb :one_subreddit
end

get '/p/:post_id' do
  @post = Post.first(:rid => params[:post_id])
  @comments = @post.comments
  erb :one_post
end

get '/populate' do
  reddit = Snooby::Client.new('adam\'s comment grabber')
  reddit.authorize!('adamtest', '123qwe')
  comments = reddit.subreddit('all').comments(500)
  comments.each do |comment|
    s = Subreddit.new
    s.rid = comment.subreddit_id
    s.title = comment.subreddit
    s.save

    p = Post.new
    p.subreddit_id = Subreddit.first(:rid => comment.subreddit_id)._id
    p.rid = comment.link_id
    p.title = comment.link_title
    p.save

    c = Comment.new
    c.post_id = Post.first(:rid => comment.link_id)._id
    c.rid = comment.id
    c.author = comment.author
    c.body = comment.body
    c.created_utc = comment.created_utc
    c.downs = comment.downs
    c.ups = comment.ups
    c.save
  end
  redirect '/'
end

# get '/all.json' do
#   content_type :json
#   Subreddit.all.to_json
# end