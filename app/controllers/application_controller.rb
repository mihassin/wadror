class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:"you should be signed in" if current_user.nil?
  end

  def ensure_that_admin
    ensure_that_signed_in
    redirect_to :back, notice:'only admins are allowed' unless current_user.admin?
  end

  def create_item(item, msg)
    respond_to do |format|
      if item.save
        format.html { redirect_to item, notice: msg+' was successfully created.' }
        format.json { render action: 'show', status: :created, location: item }
      else
        format.html { render action: 'new' }
        format.json { render json: item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_item(item, item_params, msg)
    respond_to do |format|
      if item.update(membership_params)
        format.html { redirect_to item, notice: msg+' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_item(item, url)
    item.destroy
    respond_to do |format|
      format.html { redirect_to url }
      format.json { head :no_content }
    end
  end
end
