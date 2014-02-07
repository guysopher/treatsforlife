require 'open-uri'

class PetsController < ApplicationController
  # GET /pets
  # GET /pets.json
  def index
    @pets = Pet.all
    @pets.each do |pet|
      @user = pet.owner_id
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pets }
    end
  end

  def do

    @pet = Pet.find(params[:id])

    if (params[:adopt])
      current_user.current_pet = params[:id]
      current_user.save!
      @pet.owner_id = current_user.id.to_s
      @pet.save!
      save_action(@pet.owner_id, current_user.name.to_s, 'a', 'adopted', @pet.id.to_s, @pet.name.to_s)
    end

    if (params[:treat])
      save_action(current_user.id, current_user.name.to_s, 'g', 'gave', @pet.id.to_s, @pet.name.to_s, params[:fid], params[:fname])
      send_sms(@pet.name.to_s, params[:fname])
    end



    respond_to do |format|
      format.html {render 'show.html.erb'}
      format.json { render json: @pet }
    end

  end
  # GET /pets/1
  # GET /pets/1.json
  def show
    @pet = Pet.find(params[:id])

    open("https://api.instagram.com/v1/tags/TreatsForTheLifeOf#{@pet.name.capitalize.gsub(' ','')}/media/recent?client_id=d9c1142d0ac14d1ea5a45bc8478006a4", 'r') {|f|
      data = JSON.parse f.read
      data['data'].each do |d|
        next unless d['videos']
        @pet.videos ||= []
        @pet.videos << d['videos']['standard_resolution']['url']
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: data }
      end
    }

  end

  def shop

  end

  # GET /pets/new
  # GET /pets/new.json
  def new
    @pet = Pet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pet }
    end
  end

  # GET /pets/1/edit
  def edit
    @pet = Pet.find(params[:id])
  end

  # POST /pets
  # POST /pets.json
  def create
    @pet = Pet.new(params[:pet])

    respond_to do |format|
      if @pet.save
        format.html { redirect_to @pet, notice: 'Pet was successfully created.' }
        format.json { render json: @pet, status: :created, location: @pet }
      else
        format.html { render action: "new" }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pets/1
  # PUT /pets/1.json
  def update
    @pet = Pet.find(params[:id])

    respond_to do |format|
      if @pet.update_attributes(params[:pet])
        format.html { redirect_to @pet, notice: 'Pet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1
  # DELETE /pets/1.json
  def destroy
    @pet = Pet.find(params[:id])
    @pet.destroy

    respond_to do |format|
      format.html { redirect_to pets_url }
      format.json { head :no_content }
    end
  end
end
