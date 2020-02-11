module SsrFreelanceHelper

  def freelance_find_data(params)
    if params['project'] == 'new'
      project_id = params['project_select'].to_i
    elsif params["project_id"] != ""
      project_id = params['project_id'].to_i
    end
    user_id = params['check_user_id']
    if project = Project.find(project_id)
      role_ids = project.users.find(user_id).roles.ids
    end
    SsrFreelanceSetting.all.map { |item| true if role_ids.include?(item.role_id) }.compact.pop
  end

  def url_correct_path
    url.request.split('/')
  end

  def select_mark_freelance_user
    CustomField.where(type: 'UserCustomField').map { |item| [item.name, item.id] }
  end

  def select_mark_freelance_issue
    CustomField.where(type: 'IssueCustomField').map { |item| [item.name, item.id] }
  end


  def select_mark_freelance
    CustomField.where(type: 'IssueCustomField').map { |item| [item.name, item.id] } << ['<отсутствует>', -10]
  end

  def select_mark_field_freelance
    CustomField.where(type: 'IssueCustomField').map { |item| [item.name, item.id] }
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

  def field_add_freelance_filtered
    arr = CustomField.where(type: 'IssueCustomField').map { |item| [item.name, item.id] }
    arr = arr - SsrFreelanceHelper.mark_custom_field_freelance
    arr << ['<отсутствует>', -10]

  end

  def self.mark_custom_field_freelance
    a = []
    if Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued'].to_i != -10 and
        Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued'].to_i > 0
      a << CustomField.where(type: 'IssueCustomField').find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued'].to_i)
    end
    if Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_paid'].to_i != -10 and
        Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_paid'].to_i > 0
      a << CustomField.where(type: 'IssueCustomField').find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_paid'].to_i)
    end
    if Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status'].to_i != -10 and
        Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status'].to_i > 0
      a << CustomField.where(type: 'IssueCustomField').find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status'].to_i)
    end
    a.map!{|item| [item.name, item.id]}
    a.compact
  end

  def self.mark_custom_field_freelance_js
    SsrFreelanceHelper.mark_custom_field_freelance.map{|item| [item.name, item.id] if item.name != '<отсутствует>'}
  end

end


