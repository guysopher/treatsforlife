require 'open-uri'

class PetsController < ApplicationController
  # GET /pets
  # GET /pets.json
  def index
    @pets = []
    pets = Pet.all
    pets.each do |pet|
      @pets << Hash[pet.attributes] unless pet.owner_id
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

    respond_to do |format|
      format.html {render 'show.html.erb'}
      format.json { render json: @pet }
    end

  end
  # GET /pets/1
  # GET /pets/1.json
  def show pet=nil

    id = pet ? pet.id : params[:id]
    @pet = Pet.find(id.to_s)

    if (params[:auth] and params[:treat] and current_user)
      save_action(current_user.id, current_user.name.to_s, 'g', 'gave', @pet.id.to_s, @pet.name.to_s, params[:treat], params[:treat])
      send_sms(@pet.name.to_s, params[:treat])
    end


    open("https://api.instagram.com/v1/tags/TreatsForTheLifeOf#{@pet.name.capitalize.gsub(' ','')}/media/recent?client_id=d9c1142d0ac14d1ea5a45bc8478006a4", 'r') {|f|
      data = JSON.parse f.read
      data['data'].each do |d|
        next unless d['videos']
        @pet.videos ||= []
        @pet.videos << d['videos']['standard_resolution']['url']
      end

      @pet = Hash[@pet.attributes]

      @user = User.find(@pet['owner_id']) if @pet['owner_id']
      last_action = Action.where({'uid'=>@pet['owner_id']}).last.t if @pet['owner_id']
      @health = last_action ? 1-[(Time.now-last_action)/5.days,1].min : 0.3

      respond_to do |format|
        format.html {render 'show.html.erb'}
        format.json { render json: @pet }
      end
    }

  end

  def shop

  end

  def my
    pet = Pet.where({:owner_id=>current_user._id.to_s}).limit(1)
    show(pet)
    return
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
