class OwnersController < ApplicationController
  # GET /owners
  # GET /owners.json
  def index
    @owners = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @owners }
    end
  end

  # GET /owners/1
  # GET /owners/1.json
  def show
    #@owner = Owner.find({'_id'=>params[:id]})
    @owner = Owner.find(params[:id])
    @owner = Hash[@owner.attributes]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @owner }
    end
  end

  def unadopt
    @owner = Owner.find(current_user.id)
    @owner.current_pet = nil
    @owner.save!

    @pets = Pet.where({'owner_id' => current_user.id})
    @pets.each do |p|
      p.owner_id = nil
      p.save!
    end

    params[:id] =  current_user.id
    show()
    return
  end

  ## GET /owners/new
  ## GET /owners/new.json
  #def new
  #  @owner = Owner.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @owner }
  #  end
  #end
  #
  ## GET /owners/1/edit
  #def edit
  #  @owner = Owner.find(params[:id])
  #end
  #
  ## POST /owners
  ## POST /owners.json
  #def create
  #  @owner = Owner.new(params[:owner])
  #
  #  respond_to do |format|
  #    if @owner.save
  #      format.html { redirect_to @owner, notice: 'Owner was successfully created.' }
  #      format.json { render json: @owner, status: :created, location: @owner }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @owner.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## PUT /owners/1
  ## PUT /owners/1.json
  #def update
  #  @owner = Owner.find(params[:id])
  #
  #  respond_to do |format|
  #    if @owner.update_attributes(params[:owner])
  #      format.html { redirect_to @owner, notice: 'Owner was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @owner.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## DELETE /owners/1
  ## DELETE /owners/1.json
  #def destroy
  #  @owner = Owner.find(params[:id])
  #  @owner.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to owners_url }
  #    format.json { head :no_content }
  #  end
  #end
end
