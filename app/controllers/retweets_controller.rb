class RetweetsController < ApplicationController

  def create
    micropost = Micropost.find(params[:micropost_id])
    micropost.retweet(current_user)

    if micropost.update_attribute(:updated_at, Time.now)
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    Retweet.find(params[:id]).destroy
    redirect_back(fallback_location: root_path)
  end

end
