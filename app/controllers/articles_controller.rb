# Public: Controller layer for Article

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # Public: Lookup and also search article following article title
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all.order("updated_at DESC")
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    if params[:term]
      @articles = Article.search(params[:term]).order("updated_at DESC")
    end
  end

  # Public: Lookup and also search article following article title
  # GET /articles/1
  # GET /articles/1.json
  def show
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  # GET /articles/details/1
  # GET /articles/details/1.json
  def details
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    # Increase 1 unit for view
    @article = Article.find(params[:id])
    @article.increment!(:view)

    @comment_list = Comment.where(:article_id => params[:id]).order("updated_at DESC")
    @number_of_comment = @comment_list.count

  end

  # Public: Lookup and also search article following article title
  # GET /search
  def search
    @articles = Article.all
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    if params[:term]
      @articles = Article.search(params[:term])
    end
  end

  def search_post
    redirect_to search_articles_path(params[:q])
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # Public: Create new article
  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.view = 0
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # Public: Create new comment following article id number
  # POST /articles/1/comment
  def comment
    @comment = Comment.new(comment_params)
    @comment.article_id = params[:id]
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @article = Article.find(@comment.article_id)
    @article.view -= 1
    Article.update(params[:id], view: @article.view)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to action: 'details' }
        format.json { render :details, status: :ok, location: @article }
      else
        format.html { redirect_to action: 'details' }
        format.json { render json: @comment.errors, status: :unprocessable_entity, location: @article }
      end
    end
  end

  # Public: Modify article
  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # Public: Delete article
  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :body)
    end

    def comment_params
      params.require(:comments).permit(:message)
    end
end
