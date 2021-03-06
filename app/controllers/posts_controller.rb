class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  VIDEO = 'video_type'
  IMAGE = 'image_type'
  TEXT = "text"
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
      added_attr = added_attr.merge({state: "draft", visible: false})
      @post = current_user.posts.new(post_params.merge(added_attr))
      message = "Post was saved as draft"
    else
      added_attr = {state: "published"}
      @post = current_user.posts.new(post_params.merge(added_attr))
      message = "Post was successfully created"
    end
    if content_type == IMAGE
      attachment = Attachment.create(file:decode_base64(params[:file_content],params[:file_content_type],params[:file_name]),attachable_type:"post",attachable_id: @post.id)
      @post.update(image: attachemt.id)
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
    post = Post.find_by_id(params[:post])   
    @likes = post.likes.create(value: true, user_id: current_user.id)   unless post.likes.where(user_id: current_user.id).present?
    respond_to do |format|
      if @like.nil?
        format.html { redirect_to posts_url, notice: "already have been liked." }
        format.json { head :no_content }
    else
      format.html { redirect_to posts_url, notice: "like was successfully added." }
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

    def content_type
      if param[:content_type] == VIDEO
        content_type = VIDEO
      elsif
        content_type = IMAGE
      else
        content_type = TEXT
    end
end
