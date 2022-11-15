class UsersController < ApplicationController


  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])

    # DM機能
    # 現在ログインしているユーザーと、相手のユーザーの両方をEntryテーブルに記録する必要があるので、whereメソッドでそのユーザーを探している
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    # 現在ログインしているユーザーではないという条件
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          # 既にroomが作成されている場合と作成されていない場合に条件分岐
          if cu.room_id == u.room_id then
            @isRoom = true  # falseの時、roomを作成する時の条件を記述するため
            @roomId = cu.room_id
          end
        end
      end
      # 新しくインスタンスを作成
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end

    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
