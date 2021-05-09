class DraftsController < ApplicationController

    def index
        @drafts = Post.where(user_id: current_user.id, state: "draft")
    end

    def edit
        set_draft
    end

    def update
        if @draft.update(params)
            format.html { redirect_to @draft, notice: "draft was successfully updated." }
            format.json { render :show, status: :ok, location: @draft }
        else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @drafts.errors, status: :unprocessable_entity }
        end
    end

    def destroy
        set_draft 
        @draft.destroy
        respond_to do |format|
          format.html { redirect_to drafts_url, notice: "Draft was successfully destroyed." }
          format.json { head :no_content }
        end
    end

    private

    def set_draft
       @draft = Post.find(params[:id])
    end

end
