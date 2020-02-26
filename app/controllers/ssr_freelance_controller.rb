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
    check = true if params
    if check
      user = User.find(params['check_user_id'].to_i)
      if params['project'] == 'new'
        project = Project.find(params['project_select'].to_i) if params['project_select']
      else
        project = Project.find(params['project_id'].to_i) if params['project_id']
      end
      param_issue = params[:issue_id].to_i
      if param_issue > 0
        issue = Issue.find(param_issue)
      end
      if project
        begin
          role_user_ids = Member.where(user_id: user.id).find_by(project_id: project.id).role_ids
        rescue
          role_user_ids = []
        end
      end

      role_ids_custom = SsrFreelanceSetting.all.map { |item| item.role_id }.compact
      check = (role_user_ids.map { |item| 1 if role_ids_custom.include?(item) }).compact.pop || 2
      if issue
        if check == 2
          if project.issues.find(issue).custom_values.find_by(custom_field_id: Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i).value.to_i == 1 and project.issues.find(issue).assigned_to.id == user.id
            check = 3
          else
            check = 2
          end
        end
      end
    end
    respond_to do |format|
      format.html {
        render text: check
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
      check = (Member.where(user_id: user.id).find_by(project_id: project.id).role_ids.map { |item| true if role_ids_custom.include?(item) }).compact
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

  def pay_cash
    value_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status'].to_i
    value_50 = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status_50']
    value_100 = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status_100']
    value = 'non'
    value_issue = 'non'
    arr = status_select
    index = (0..arr.size).find_all { |item| arr[item] == params['value_status'] }.first
    issue = Issue.find(params[:issue_id])
    id_field = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued'].to_i
    issue.custom_field_values.each do |item|
      if value_id == item.custom_field.id
        if item.value == arr[index - 1]
          issue.custom_field_values.each do |item|
            if item.custom_field.id == id_field
              if params['value_status'] == value_50
                value = item.value.to_f * 0.5
              elsif params['value_status'] == value_100
                value = item.value.to_f
              end
            end
          end
        end
      end
    end

    respond_to do |format|
      format.html {
        if value != 'non'
          if value > 0 and value != value.to_i
            render json: value.round(2).to_json, status: 200
          else
            render json: value.to_i.to_json, status: 200
          end
        else
          render json: value.to_i.to_json, status: 404
        end
      }
    end
  end


end
