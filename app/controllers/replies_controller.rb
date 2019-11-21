class RepliesController < ApplicationController

  def create
    @micropost = Micropost.find(micropost_params)
    if @micropost.reply(current_user, reply_params[:content])
      respond_to do |format|
        format.html {redirect_back(fallback_location: root_path)}
        format.js
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  # Strong Parameter対策
  def reply_params
    params.require(:reply).permit(:content)
  end

  # Strong Parameter対策
  def micropost_params
    params.require(:micropost_id)
  end

end
