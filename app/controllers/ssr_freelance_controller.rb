class SsrFreelanceController < ApplicationController


  def delete
    a = SsrFreelanceSetting.find_by(role_id: request.url.split("/").last.to_i)
    if a
      a.destroy
    end
    redirect_to plugin_settings_path('sunstrike_redmine_freelance_plg')
  end

  def add
    SsrFreelanceSetting.create(role_id: request.url.split("/").last.to_i, freelance_role: true)
    redirect_to plugin_settings_path('sunstrike_redmine_freelance_plg')
  end

  def user_role_freelance?
    if params['project'] == 'new'
      project_id = params['project_select'].to_i
    elsif params["project_id"] != ""
      project_id = params['project_id'].to_i
    end
    user_id = params['check_user_id']
     if project = Project.find(project_id)
       # query for roles current project
       role_ids = project.users.find(user_id).roles.ids
     end

    check = SsrFreelanceSetting.all.map{ |item| true if role_ids.include?(item.role_id)}.compact.pop
    respond_to do |format|
      format.html {
        render text: check.nil? ? 'false' : 'true'
      }
    end
  end

  def user_pay_freelance
    custom_field_wallet = UserCustomField.find_by(name: "Номер карты/кошелька/телефона")
    custom_field_type = UserCustomField.find_by(name: "Способ оплаты фрилансеру")
    custom_field_wallet_issue = IssueCustomField.find_by(name: "Номер карты/кошелька/телефона")
    custom_field_type_issue = IssueCustomField.find_by(name: "Способ оплаты фрилансеру")
    a = []
    if params['chek_user_id']
      user = User.find(params['chek_user_id'])
      user_pay_wallet = user.custom_values.find_by(custom_field_id: custom_field_wallet.id) || ''
      user_pay_type = user.custom_values.find_by(custom_field_id: custom_field_type.id) || ''
      a << {number: custom_field_wallet_issue.id, value: user_pay_wallet == '' ? '' : user_pay_wallet.value}
      a << {number: custom_field_type_issue.id, value: user_pay_type == '' ? '' : user_pay_type.value}
    else
      a << {number: custom_field_wallet_issue.id, value: ''}
      a << {number: custom_field_type_issue.id, value: ''}
    end

    respond_to do |format|
      format.html {
        render json: a.to_json
      }
    end
  end

  def addfield
    SsrFreelanceFields.create(field_id: request.url.split("/").last.to_i)
    redirect_to plugin_settings_path('sunstrike_redmine_freelance_plg')
  end

  def deletefield
    a = SsrFreelanceFields.find_by(field_id: request.url.split("/").last.to_i)
    if a
      a.destroy
    end
    redirect_to plugin_settings_path('sunstrike_redmine_freelance_plg')
  end


end
