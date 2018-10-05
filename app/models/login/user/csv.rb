class Login::User::Csv < Login::Csv
  default_scope { where(:csv_type => self.name) }

  def parse_line(row, i)

    line = csv_lines.build(:line_no => i+2, :data => row.fields, :data_type => 'Webdb::Entry')

    user = content.users.where(id: row['No.']).first || content.users.new
    user_attributes = {}
    delete_attributes = {}
    group_attributes  = {}

    user_attributes['id']          = row['No.']
    user_attributes['state']       = state_to_status(user, row['状態'])
    user_attributes['account']     = row['ID']
    user_attributes['password']    = row['パスワード']
    group_attributes['id']         = group_name_to_id(row['グループ'])
    delete_attributes['delete'] = row['削除']

    user_attributes.each do |key , value|
      next if key == :id
      user[key] = value
    end

    user.validate
    line.data_attributes = {
      user_attributes: user_attributes,
      delete_attributes: delete_attributes,
      group_attributes:  group_attributes
    }
    line.data_invalid = user.errors.blank? ? 0 : 1
    line.data_errors = user.errors.full_messages.to_a if user.errors.present?
    line
  end

  def state_to_status(user, state_str)
    user.states.each{|a| return a[1] if a[0] == state_str }
    return nil
  end

  def group_name_to_id(group)
    content.groups.find_by(title: group).try(:id)
  end

  def register(line)
    user_attributes    = line.csv_data_attributes['user_attributes']
    delete_attributes  = line.csv_data_attributes['delete_attributes']
    group_attributes   = line.csv_data_attributes['group_attributes']
    user = content.users.where(id: user_attributes['id']).first || content.users.new
    if user_attributes['id'].present? && user.present? &&  delete_attributes['delete'].present?
      user.destroy if delete_attributes['delete'] == '削除'
    else
      user_attributes.each do |key , value|
        next if key == 'id'
        user[key] = value
      end
      user.in_group_id = group_attributes['id']
      user.save
    end
    user
  end
end
