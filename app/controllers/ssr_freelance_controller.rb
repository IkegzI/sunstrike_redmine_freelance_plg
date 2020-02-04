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
    user = User.find(request.url.split('/').last.split('?').first.to_i).id
    a = SsDefaultUserRole.find_by(user_id: user)
    unless a.nil?
      a = SsrFreelanceSetting.find_by(role_id: a.role_id)
    end
    respond_to do |format|
      format.html {
        render text: a.nil? ? 'false' : 'true'
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
