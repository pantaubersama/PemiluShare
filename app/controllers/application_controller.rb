class ApplicationController < ActionController::Base
  def render_404
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def default_image
    "https://pantaubersama.com/wp-content/uploads/2019/02/no-alpha.jpg"
  end
end
