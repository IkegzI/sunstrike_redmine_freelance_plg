class SsrFreelanceController < ApplicationController
  require_relative '../helpers/ssr_freelance_helper.rb'
  include SsrFreelanceHelper

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
    check = freelance_find_data(params)
    respond_to do |format|
      format.html {
        render text: check.nil? ? 'false' : 'true'
      }
    end
  end

  def user_pay_freelance
    custom_field_wallet = UserCustomField.find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_wallet_user_field_id'].to_i)
    custom_field_type = UserCustomField.find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_user_field_id'].to_i)
    custom_field_wallet_issue = IssueCustomField.find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_wallet_issue_field_id'].to_i)
    custom_field_type_issue = IssueCustomField.find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_issue_field_id'].to_i)
    a = []
    if freelance_find_data(params)
      if params['check_user_id']
        user = User.find(params['check_user_id'])
        user_pay_wallet = user.custom_values.find_by(custom_field_id: custom_field_wallet.id) || ''
        user_pay_type = user.custom_values.find_by(custom_field_id: custom_field_type.id) || ''
        a << {number: custom_field_wallet_issue.id, value: user_pay_wallet == '' ? '' : user_pay_wallet.value}
        a << {number: custom_field_type_issue.id, value: user_pay_type == '' ? '' : user_pay_type.value}
      else
        a << {number: custom_field_wallet_issue.id, value: ''}
        a << {number: custom_field_type_issue.id, value: ''}
      end
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
