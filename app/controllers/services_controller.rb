class ServicesController < ApplicationController

  def goto
    send params[:name]
  end

  def adopt
    puts current_user
    current_user.current_pet = params[:pet_id]
    current_user.save!

    pet = Pet.find(params[:pet_id])
    pet.owner_id = current_user.id

  end

end
