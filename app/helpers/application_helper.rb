module ApplicationHelper

  def app_url
    return 'http://treatsforlife.org'
    #if Rails.env.isProduction?
    #  return 'http://treatsforlife.org'
    #else
    #  return 'http://localhost:3000'
    #end
  end

end
