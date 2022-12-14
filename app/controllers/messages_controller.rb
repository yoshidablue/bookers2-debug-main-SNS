class MessagesController < ApplicationController

  def create
    # form_withで送られてきたcontentを含むすべてのメッセージの情報の[:message][:room_id]のキーが入っているかということを条件で確認
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(user_id: current_user.id))
      redirect_to "/rooms/#{@message.room_id}"
    end
  end

end
