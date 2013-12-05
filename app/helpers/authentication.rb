module Authentication
  
  def public_key
    
  end
  
  def private_key
  end
  
  def decrypt_user_key!
    params[:user_key] = decrypt(params[:user_key])
  end
  
  def user_valid?
    User.has_key?(params[:user_key])
  end
  
  def authenticate!
    return true #if user_valid?
    respond_to do |format|
      format.json { render :status => 401 }
    end
  end
  
  def decrypt(s)
    s
  end
end
