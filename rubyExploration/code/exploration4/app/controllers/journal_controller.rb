class JournalController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "wergel", except: [:index, :show]
  def new
	  @title = 'New Entry';
  end
  def create
	@journal = Journal.new(params.require(:journal).permit(:title, :date, :content))
	if @journal.save
		redirect_to @journal
	else
		render 'new'
	end	
  end
  def index
	@journals = Journal.all
  end
  def show
	  @journal = Journal.find(params[:id])
  end
  def edit
	  @journal = Journal.find(params[:id])
  end
  def update
	  @journal = Journal.find(params[:id])
	  if @journal.update(params.require(:journal).permit(:title, :date, :content))
		  redirect_to @journal
	  else
		  render 'edit'
	  end
  end
  def destroy
	  @journal = Journal.find(params[:id])
	  @journal.destroy
	  redirect_to journal_index_path
  end
end
