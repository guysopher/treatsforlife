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

  def treat
    pet_name = params[:pet_name]
    treat_name = params[:treat_name]
    send_sms(pet_name, treat_name)
  end
end
