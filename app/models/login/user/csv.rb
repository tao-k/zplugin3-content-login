class Login::User::Csv < Login::Csv
  default_scope { where(:csv_type => self.name) }

  def parse_line(row, i)

    line = csv_lines.build(:line_no => i+2, :data => row.fields, :data_type => 'Webdb::Entry')

    user = content.users.where(id: row['No.']).first || content.users.new
    user_attributes = {}

    user_attributes['id']       = row['No.']
    user_attributes['state']    = state_to_status(user, row['状態'])
    user_attributes['account']  = row['ID']
    user_attributes['password'] = row['パスワード']

    user_attributes.each do |key , value|
      next if key == :id
      user[key] = value
    end

    user.validate
    line.data_attributes = {
      user_attributes: user_attributes,
      creator_attributes: {user_id: Core.user.id, group_id: Core.user_group.id}
    }
    line.data_invalid = user.errors.blank? ? 0 : 1
    line.data_errors = user.errors.full_messages.to_a if user.errors.present?
    line
  end

  def state_to_status(user, state_str)
    user.states.each{|a| return a[1] if a[0] == state_str }
    return nil
  end

  def register(line)
    user_attributes    = line.csv_data_attributes['user_attributes']
    target_item = content.users.where(id: user_attributes['id'])
    if !Core.user.has_auth?(:manager)
      target_item = target_item.organized_into(Core.user_group.id)
    end
    user = target_item.first || content.users.new
    user_attributes.each do |key , value|
      next if key == 'id'
      user[key] = value
    end
    user.save
    user
  end
end
