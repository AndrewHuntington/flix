class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email_or_username]) || 
           User.find_by(username: params[:email_or_username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session[:intended_url] || user,
                   notice: "Welcome back, #{user.name}!"
      # session[:intended_url] = nil # DOES NOT EXECUTE
      # raise session[:intended_url].inspect
    else
      flash.now[:alert] = 'Invalid email/password combination!'
      render :new # see line 11 in routes.rb for guard against 404
    end
  end

  def destroy
    session[:user_id] = nil
    session[:intended_url] = nil # Moved from line 14
    redirect_to movies_url, notice: "You've signed out!"
  end
end
