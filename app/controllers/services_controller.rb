require 'httparty'

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

  def gcm
    post_data = {
        :registration_ids => ['APA91bEv-X7uOePTbwPAMNcZ3aXSJZles-RWrSex8HaoRE0oq0ekyF-Yf-BYrhjQz7Auem6w3JrkBM_u_g0Mzn9vjBEk-CXjHJHPpOCu8Y9mOwV_FMJS0hBi3pRIDQWDLqgpbq2tFP--Wjt4YkU7uQHrpKUa7Fy3fA'],
         :payload => { :message => 'Hey, I\'m hungry, would you like to give me a treat?', :amount => 5 }
    }
    response = HTTParty.post('https://android.googleapis.com/gcm/send',
        headers: {
            'Authorization' => 'key=AIzaSyDmf2Uw2YNz_TrandI25yoTkr5iiy1SqvE',
            'Content-Type' => 'application/json'
        },
        body: post_data.to_json
    )
    test = 1
    render :nothing => true
    return
  end
end
