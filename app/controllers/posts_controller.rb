class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    @posts = Post.where(visible: true)
  end

 
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    if params[:submit] == "draft"
      added_attr = {user_id: current_user.id, state: "draft", visible: false}
      @post = Post.new(post_params.merge(added_attr))
      message = "Post was saved as draft"
    else
      added_attr = {user_id: current_user.id}
      @post = Post.new(post_params.merge(added_attr))
      message = "Post was successfully created"
    end
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: message }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    set_post
    if params[:submit] == "published"
      added_attr = {state: "published", visible: true}
    else
      added_attr = {}
    end
    respond_to do |format|
      if @post.update(post_params.merge(added_attr))
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    set_post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def likes
    post = Post.find_by(params[:post])   
    @likes = post.likes.create(value: true)   unless post.like.present?
    respond_to do |format|
      if @like.save
        format.html { redirect_to posts_url, notice: "like was successfully added." }
        format.json { head :no_content }
    else
        format.html { redirect_to posts_url, notice: "already have been liked." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share
    def set_post
      @post = Post.find(params[:id])
    end

    # trusted parameters through
    def post_params
      params.require(:post).permit(:attachment, :content)
    end
end
