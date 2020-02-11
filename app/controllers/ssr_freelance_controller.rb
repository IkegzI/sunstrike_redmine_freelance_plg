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
    if check.nil?
      user = User.find(params['check_user_id'].to_i)
      project = Project.find(params['project_id'].to_i) if params['project_id']
      role_ids_custom = SsrFreelanceSetting.all.map { |item| item.role_id }.compact
      check = (Member.where(user_id: user_id).find_by(project_id: project.id).role_ids.map { |item| true if role_ids_custom.include?(item) }).compact
    end

    respond_to do |format|
      format.html {
        render text: check == [] ? 'false' : 'true'
      }
    end
  end

  def user_pay_freelance
    custom_field_wallet = CustomField.where(type: 'UserCustomField').find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_wallet_user_field_id'].to_i)
    custom_field_type = CustomField.where(type: 'UserCustomField').find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_user_field_id'].to_i)
    custom_field_wallet_issue = CustomField.where(type: 'IssueCustomField').find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_wallet_issue_field_id'].to_i)
    custom_field_type_issue = CustomField.where(type: 'IssueCustomField').find(Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_issue_field_id'].to_i)
    a = []
    if params['check_user_id']
      user = User.find(params['check_user_id'].to_i)
      if params['project'] == 'new'
        project = Project.find(params['project_select'].to_i)
      else
        project = Project.find(params['project_id'].to_i)
      end
      user_pay_wallet = user.custom_values.find_by(custom_field_id: custom_field_wallet.id) || ''
      user_pay_type = user.custom_values.find_by(custom_field_id: custom_field_type.id) || ''
    end

    if project
      role_ids_custom = SsrFreelanceSetting.all.map { |item| item.role_id }.compact
      check = (Member.where(user_id: user_id).find_by(project_id: project.id).role_ids.map { |item| true if role_ids_custom.include?(item) }).compact
    end
    if check != []
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
