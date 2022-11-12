class BooksController < ApplicationController

  before_action :correct_user, only: [:edit, :update]

  def index
    # 過去一週間でいいねの多い順に投稿を表示
    # 下記２つの記述で一週間分のデータを取得
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    # includesは、無駄にSQL文（データベースへ指示を出す言語）が実行されるのを防ぐ
    @books = Book.includes(:favorited_users).
      # a <=> b で昇順（少ない順）、b <=> a で降順（多い順）
      sort {|a, b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @book_comment = BookComment.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    unless @user == current_user
      redirect_to books_path
    end
  end

end
