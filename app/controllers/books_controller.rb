class BooksController < ApplicationController
  
  require 'amazon/ecs'
  
  # GET /books
  # GET /books.json
  def index
    #@books = Book.order(:name)
    @books = Book.order(:name).page params[:page]
=begin
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
=end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    # FIXME ダミーisbn。ユーザ入力を受け付けられるようにする
    isbn = "4122024137"
    book_info = fetch_amz_info(isbn)
    @book = Book.new(
      :name => book_info["tile"],
      :price => book_info["price"],
      :author => book_info["author"],
      :publisher => book_info["publisher"],
      :pub_date => book_info["pub_date"],
      :img_url => book_info["img_url"],
      :amz_url => book_info["amz_url"],
      :isbn => isbn
    )

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
  
  def fetch_amz_info(isbn)
    item_hash = {}
    Amazon::Ecs.options = {
      :associate_tag => ENV['AMZ_ASSOC_TAG'],
      :AWS_access_key_id => ENV['AMZ_ACCESS_KEY'],       
      :AWS_secret_key => ENV['AMZ_SECET_KEY'] 
      }

    res = Amazon::Ecs.item_search(
      isbn, {
        :country => 'jp',
        :search_index => 'Books',
        :response_group => 'Medium'
      }
    )

    res.is_valid_request?
    p res.has_error?
    p res.error

    res.items.each do |item|
      item_hash = {
        "tile" => item.get('ItemAttributes/Title'),
        "author" => item.get('ItemAttributes/Author'),
        "price" => item.get('ItemAttributes/ListPrice/FormattedPrice'),
        "publisher" => item.get('ItemAttributes/Publisher'),
        "pub_date" => item.get('ItemAttributes/PublicationDate'),
        "img_url" => item.get('MediumImage/URL'),
        "amz_url" => item.get('DetailPageURL')
      }
    end
    item_hash
  end
end
