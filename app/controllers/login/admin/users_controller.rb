class Login::Admin::UsersController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  layout  'admin/cms'

  def pre_dispatch
    @content = Login::Content::User.find(params[:content])
    return error_auth unless Core.user.has_priv?(:read, item: @content.concept)
  end

  def index
    @items = @content.users
    if params[:csv]
      return export_csv(@items)
    else
      @items = @items.paginate(page: params[:page], per_page: 30).order(updated_at: :desc)
    end
  end

  def show
    @item = @content.users.find(params[:id])
    _show @item
  end

  def new
    @item = @content.users.new({state: 'enabled'})
  end

  def create
    @item = @content.users.new(user_params)
    _create(@item)
  end

  def update
    @item = @content.users.find(params[:id])
    @item.attributes = user_params
    _update(@item)
  end

  def destroy
    @item = @content.users.find(params[:id])
    _destroy(@item)
  end

  def import
    if params.dig(:item, :file)
      item = Login::User::Csv.new
      item.file = params[:item][:file]
      item.content_id = @content.id
      if item.save
        flash[:notice] = "CSVの登録を完了しました。"
        Login::ImportUserJob.perform_now(item.id)
        return redirect_to url_for({:action=>:import})
      else
        flash[:notice] = "CSVの解析に失敗しました。"
        return redirect_to url_for({:action=>:import})
      end
    end
  end

  private

  def user_params
    params.require(:item).permit(:state, :account, :password)
  end

  def export_csv(users)
    require 'csv'
    bom = %w(EF BB BF).map { |e| e.hex.chr }.join
    data = CSV.generate(bom, force_quotes: true) do |csv|
      columns = [ "No.", "状態", "ID", "パスワード" ]
      csv << columns
      users.each do |user|
        csv << [user.id, user.state_text, user.account, user.password]
      end
    end
    send_data data, type: 'text/csv', filename: "#{@content.name}_データ一覧_#{Time.now.to_i}.csv"
  end

end