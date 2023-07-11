class PlaysController < ApplicationController
  before_action :set_play, only: [:show, :edit, :update, :destroy]
  def index
    if params[:category].blank?
      @plays = Play.all.order("created_at DESC")
    else
      @category_id = Category.find_by_name(params[:category]).id
      @plays = Play.where(category_id: @category_id).order("created_at DESC")
    end
  end

  def show
  end
  
  def new
    @play = current_user.plays.build
    @categories = Category.all.map { |c| [c.name, c.id]}
  end

  def create
    @play = current_user.plays.build(play_params)
    @play.category_id = params[:category_id]
    if @play.save
      redirect_to @play
    else
      render :new
    end
  end

  def edit
    @categories = Category.all.map { |c| [c.name, c.id]}
  end

  def update
    @play.category_id = params[:category_id]
    if @play.update(play_params)
      redirect_to @play
    else
      render :edit
    end
  end

  def destroy
    @play.destroy
    redirect_to plays_path
  end

  private
  def play_params
    params.require(:play).permit(:title, :description, :director, :category_id)
  end

  def set_play
    @play = Play.find(params[:id])
  end
end