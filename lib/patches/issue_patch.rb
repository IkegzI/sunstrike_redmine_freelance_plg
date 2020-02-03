# require_dependency 'issue'
# module CustomFieldCheck
#   module Patches
#     module CustomFieldsPatch
#
#       include Redmine::I18n
#
#       def self.included(base)
#         base.send(:include, InstanceMethods)
#         base.class_eval do
#           alias_method :validate_custom_field_values, :validate_custom_field_values_ext
#           alias_method :validate_issue, :validate_issue_ext
#         end
#       end
#
#       # improvements_disable_custom_fields_check: 0
#       # improvements_disable_id_custom_fields_check: 0
#       module InstanceMethods
#
#
#         def validate_custom_field_values_ext
#
#           def check_error_field(arg, setting)
#             if Setting.plugin_custom_improvements[setting] == '0' and arg.value == '1'
#               if arg.custom_field.id == Setting.plugin_custom_improvements['improvements_disable_id_custom_fields_check'].to_i
#                 return true if estimated_hours.nil? or estimated_hours.to_i <= 0
#               end
#             end
#           end
#
#           user = new_record? ? author : current_journal.try(:user)
#           a = editable_custom_field_values(user).each(&:validate_value)
#           if new_record? || custom_field_values_changed?
#             if Setting.plugin_custom_improvements['improvements_disable_custom_fields_check'] == '0'
#               a.each do |item|
#                 errors.add :base, :error_estimate if check_error_field(item, 'improvements_disable_custom_fields_check')
#               end
#             end
#
#             editable_custom_field_values(user).each(&:validate_value)
#           end
#         end
#
#
#         def validate_issue_ext
#           if Setting.plugin_custom_improvements['improvements_disable_project_add_task'] == '0'
#             id_field = ProjectCustomField.find_by(name: "Запрещать создание тикетов").id
#             unless project.custom_values.find_by(custom_field_id: id_field).nil?
#               field = project.custom_values.find_by(custom_field_id: id_field).value
#             else
#               field = ' '
#             end
#
#             if field == '1'
#               errors.add :base, :permission_project
#             end
#           end
#
#
#           if due_date && start_date && (start_date_changed? || due_date_changed?) && due_date < start_date
#             errors.add :due_date, :greater_than_start_date
#           end
#
#           if start_date && start_date_changed? && soonest_start && start_date < soonest_start
#             errors.add :start_date, :earlier_than_minimum_start_date, :date => format_date(soonest_start)
#           end
#
#           if fixed_version
#             if !assignable_versions.include?(fixed_version)
#               errors.add :fixed_version_id, :inclusion
#             elsif reopening? && fixed_version.closed?
#               errors.add :base, I18n.t(:error_can_not_reopen_issue_on_closed_version)
#             end
#           end
#
#           # Checks that the issue can not be added/moved to a disabled tracker
#           if project && (tracker_id_changed? || project_id_changed?)
#             if tracker && !project.trackers.include?(tracker)
#               errors.add :tracker_id, :inclusion
#             end
#           end
#
#           if assigned_to_id_changed? && assigned_to_id.present?
#             unless assignable_users.include?(assigned_to)
#               errors.add :assigned_to_id, :invalid
#             end
#           end
#
#           # Checks parent issue assignment
#           if @invalid_parent_issue_id.present?
#             errors.add :parent_issue_id, :invalid
#           elsif @parent_issue
#             if !valid_parent_project?(@parent_issue)
#               errors.add :parent_issue_id, :invalid
#             elsif (@parent_issue != parent) && (
#             self.would_reschedule?(@parent_issue) ||
#                 @parent_issue.self_and_ancestors.any? { |a| a.relations_from.any? { |r| r.relation_type == IssueRelation::TYPE_PRECEDES && r.issue_to.would_reschedule?(self) } }
#             )
#               errors.add :parent_issue_id, :invalid
#             elsif !closed? && @parent_issue.closed?
#               # cannot attach an open issue to a closed parent
#               errors.add :base, :open_issue_with_closed_parent
#             elsif !new_record?
#               # moving an existing issue
#               if move_possible?(@parent_issue)
#                 # move accepted
#               else
#                 errors.add :parent_issue_id, :invalid
#               end
#             end
#           end
#         end
#
#
#       end
#     end
#   end
# end