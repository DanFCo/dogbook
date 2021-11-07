class LikesController < ApplicationController
  before_action :find_dog, :find_like, only: [:create, :destroy]

  # likes could be improved on "like" and "unlike" not having page reload.
  # front end logic (javascript) could improve on this.

  def create
    # possibly split into their own conditionals with their own notices
    if user_liked_dog? || current_user.is_dogs_owner?(@dog)
      flash[:notice] = "Oops! You can't like a dog more than once or like your own dog"
    else
      @dog.likes.create(user_id: current_user.id)
    end
    redirect_to dog_path(@dog)
  end

  def destroy
    if !user_liked_dog?
      flash[:notice] = "Cannot unlike, no previous like"
    else
      @like.first.destroy
    end
    redirect_to dog_path(@dog)
  end

  private

  def find_dog
    @dog = Dog.find(params[:dog_id])
  end

  # maybe could be moved into a model
  def user_liked_dog?
    @like.exists?
  end

  def find_like
    @like = @dog.likes.where(user_id: current_user.id)
  end
end
