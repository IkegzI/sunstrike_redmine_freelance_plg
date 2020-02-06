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
    param = request.url.split('/').last.split('?').first.to_i
    if param > 0
      user = User.find(request.url.split('/').last.split('?').first.to_i).id
      a = SsDefaultUserRole.find_by(user_id: user)
      unless a.nil?
        a = SsrFreelanceSetting.find_by(role_id: a.role_id)
      end
    end
    respond_to do |format|
      format.html {
        render text: a.nil? ? 'false' : 'true'
      }
    end
  end

  def user_pay_freelance
    param = request.url.split('/').last.split('?').first.to_i
    custom_field_wallet = UserCustomField.find_by(name: "Номер карты/кошелька/телефона")
    custom_field_type = UserCustomField.find_by(name: "Способ оплаты фрилансеру")
    custom_field_wallet_issue = IssueCustomField.find_by(name: "Номер карты/кошелька/телефона")
    custom_field_type_issue = IssueCustomField.find_by(name: "Способ оплаты фрилансеру")
    begin
      if param > 0
        user = User.find(param)
        # binding.pry
        user_pay_wallet = user.custom_values.find_by(custom_field_id: custom_field_wallet.id).value
        user_pay_type = user.custom_values.find_by(custom_field_id: custom_field_type.id).value || ''
        a = {number: custom_field_wallet_issue.id, value:  user_pay_wallet}, {number: custom_field_type_issue.id, value: user_pay_type.to_s}
      end
    rescue
      a = {number: custom_field_wallet_issue.id, value: user_pay_wallet}, {number: custom_field_type_issue.id, value: user_pay_type.to_s}
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
