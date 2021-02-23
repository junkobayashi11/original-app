class RoomsController < ApplicationController

  def index
    @rooms = Room.all.order(created_at: "DESC")
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    redirect_to action: :index
  end

  def edit
    @room = Room.find(params[:id])
  end

  def show
    @room = Room.find(params[:id])
    @comment = Comment.new
    @comments = @room.comments.includes(:user)
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(room_params)
      redirect_to action: :index
    else
      reder :edit
    end
  end

  private
  def room_params
    params.require(:room).permit(:room_name, :prefecture_id, :host_date, :municipalities).merge(user_id: current_user.id)
  end
end
