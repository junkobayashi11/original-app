class CommentsController < ApplicationController
  
  def create
    room = Room.find(params[:room_id])
    @comment = room.comments.new(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    comment = Comment.find(params[:room_id])
    text = comment.user.id
    if comment.user_id == current_user.id
      comment.destroy
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, room_id: params[:room_id])
  end
end
