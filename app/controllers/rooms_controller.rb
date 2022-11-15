class RoomsController < ApplicationController

  before_action :authenticate_user!

  def create
    @room = Room.create
    # 現在ログインしているユーザーに対して
    # EntryテーブルにRoom.createで作成された@roomに紐づくidと、現在ログインしているユーザーのidを保存する記述
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    # 相手側の情報をEntryテーブルに保存するため
    # users/show の fields_for @entry で保存したparamsの情報を許可し、現在ログインしているユーザーと同じく@roomに紐づくidを保存する記述
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    # Entryテーブルに、現在ログインしているユーザーのidとそれに紐づいたチャットルームのidをwhereメソッドで探し、そのレコードがあるか確認
    if Entry.where(user_id: current_user.id,room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      # falseだった時に、前のページに戻るための記述
      redirect_back(fallback_location: root_path)
    end
  end

end