module KaminariHelper

  def selected_page
    params[:page] || 1
  end

end