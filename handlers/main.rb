get '/' do
  erb :index
end

get '/menu' do
  @s_count = Subreddit.count
  @p_count = Post.count
  @c_count = Comment.count
  erb :menu
end

get '/subreddits' do
  @all = Subreddit.all
  @all.sort_by! {|subreddit| subreddit.posts.count}.reverse!
  erb :subreddits
end

get '/posts' do
  @all = Post.all(:order => :title.asc)
  @all.sort_by! {|post| post.comments.count}.reverse!
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
  redirect '/menu'
end

get '/words' do
  all = Comment.all
  word_count = Hash.new(0)
  all.each do |comment|
    words = comment.body.split
    words.each {|word| word_count[word.downcase] += 1}
  end
  long = word_count.select {|word, count| word.length > 6}
  words = long.sort_by {|word, count| count}.reverse!
  @words = words.first(500)
  erb :words
end