class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]


  def index
    @comments = Comment.where(post_id: params[:post])
  end

  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    added_attr = {user_id: current_user.id, post_id: params[:post]}
    @comment = Comment.new(comment_params.merge(added_attr))
    respond_to do |format|
      if @comment.save!
        format.html { redirect_to @comment, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:text, :description)
    end
end
