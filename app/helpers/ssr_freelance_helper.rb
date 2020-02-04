module SsrFreelanceHelper

  def select_mark_freelance
    IssueCustomField.all.map { |item| [item.name, item.id] }
  end

  def select_mark_field_freelance
    IssueCustomField.all.map { |item| [item.name, item.id] }
  end

  def role_user_work_add
    arr = Role.all.map { |item| [item.name, item.id] }
    arr - role_adds
  end

  def role_adds
    SsrFreelanceSetting.all.map do |item|
      a = Role.find(item.role_id)
      [a.name, a.id]
    end
  end


  def mark_custom_field_freelance
    a = []
    SsrFreelanceFields.all.each do |fild|
      unless fild.field_id.nil?
        item = IssueCustomField.find(fild.field_id)
        a << [item.name, item.id]
      end
    end
    a.compact
  end

  def field_add_freelance_filtered
    arr = IssueCustomField.all.map { |item| [item.name, item.id] }
    arr - mark_custom_field_freelance
  end


  def setting_role_users_size
  end

end


