class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]

  DOGS_PER_PAGE = 5.freeze

  # GET /dogs
  # GET /dogs.json
  def index
    # not entirely scalable basic pagination, could possibly use will_paginate gem
    @page = params.fetch(:page, 0).to_i
    @dogs = Dog.offset(@page * DOGS_PER_PAGE).limit(DOGS_PER_PAGE)
    @total_pages = (Dog.count / DOGS_PER_PAGE.to_f).ceil
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.assign_owner(current_user.id)

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:images]) if params[:dog][:images].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      format.html { redirect_to @dog, notice: "Only the owner can update, dog was not updated" } unless current_user && current_user.is_dogs_owner?(@dog)
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :description, :images)
  end
end