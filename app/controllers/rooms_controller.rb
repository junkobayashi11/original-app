class RoomsController < ApplicationController
  before_action :set_one, only: %i[edit show update]

  def index
    @rooms = Room.all.order(created_at: 'DESC')
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

  def edit; end

  def show
    @comment = Comment.new
    @comments = @room.comments.includes(:user)
  end

  def search
    @rooms = Room.search(params[:keyword])
  end

  def update
    if @room.update(room_params)
      redirect_to action: :index
    else
      reder :edit
    end
  end

  private

  def room_params
    params.require(:room).permit(:room_name, :prefecture_id, :host_date,
                                 :municipalities).merge(user_id: current_user.id)
  end

  def set_one
    @room = Room.find(params[:id])
  end
end
