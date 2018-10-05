class Login::Admin::GroupsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  layout  'admin/cms'

  def pre_dispatch
    @content = Login::Content::User.find(params[:content])
    return error_auth unless Core.user.has_priv?(:read, item: @content.concept)
  end

  def index
    @items = @content.groups
    if params[:csv]
      return export_csv(@items)
    else
      @items = @items.paginate(page: params[:page], per_page: 30).order(updated_at: :desc)
    end
  end

  def show
    @item = @content.groups.find(params[:id])
    _show @item
  end

  def new
    @item = @content.groups.new({state: 'enabled'})
  end

  def create
    @item = @content.groups.new(group_params)
    _create(@item)
  end

  def update
    @item = @content.groups.find(params[:id])
    @item.attributes = group_params
    _update(@item)
  end

  def destroy
    @item = @content.groups.find(params[:id])
    _destroy(@item)
  end


  private

  def group_params
    params.require(:item).permit(:state, :title, :creator_attributes => [:id, :group_id, :user_id])
  end

end