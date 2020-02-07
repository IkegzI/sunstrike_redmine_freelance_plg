require_dependency 'issue'

module Patches
  module IssuePatch
    include Redmine::I18n
    include CustomImprovements

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method :validate_issue, :validate_issue_patch
      end
    end

    module InstanceMethods

      def validate_issue_patch
        def validation_custom_freelance
          frelance_ids = SsrFreelanceFields.ids
          a = false
          custom_field_values.each do |item|
            if frelance_ids.include?(custom_field_values.first.custom_field.id)
              return true if item.value != ""
            end
          end
        end
        if assigned_to.nil?
          errors.add :base, :assigned_to_id_nil if validation_custom_freelance
        end


        if due_date && start_date && (start_date_changed? || due_date_changed?) && due_date < start_date
          errors.add :due_date, :greater_than_start_date
        end

        if start_date && start_date_changed? && soonest_start && start_date < soonest_start
          errors.add :start_date, :earlier_than_minimum_start_date, :date => format_date(soonest_start)
        end

        if fixed_version
          if !assignable_versions.include?(fixed_version)
            errors.add :fixed_version_id, :inclusion
          elsif reopening? && fixed_version.closed?
            errors.add :base, I18n.t(:error_can_not_reopen_issue_on_closed_version)
          end
        end

        # Checks that the issue can not be added/moved to a disabled tracker
        if project && (tracker_id_changed? || project_id_changed?)
          if tracker && !project.trackers.include?(tracker)
            errors.add :tracker_id, :inclusion
          end
        end

        if assigned_to_id_changed? && assigned_to_id.present?
          unless assignable_users.include?(assigned_to)
            errors.add :assigned_to_id, :invalid
          end
        end

        # Checks parent issue assignment
        if @invalid_parent_issue_id.present?
          errors.add :parent_issue_id, :invalid
        elsif @parent_issue
          if !valid_parent_project?(@parent_issue)
            errors.add :parent_issue_id, :invalid
          elsif (@parent_issue != parent) && (
          self.would_reschedule?(@parent_issue) ||
              @parent_issue.self_and_ancestors.any? { |a| a.relations_from.any? { |r| r.relation_type == IssueRelation::TYPE_PRECEDES && r.issue_to.would_reschedule?(self) } }
          )
            errors.add :parent_issue_id, :invalid
          elsif !closed? && @parent_issue.closed?
            # cannot attach an open issue to a closed parent
            errors.add :base, :open_issue_with_closed_parent
          elsif !new_record?
            # moving an existing issue
            if move_possible?(@parent_issue)
              # move accepted
            else
              errors.add :parent_issue_id, :invalid
            end
          end
        end
      end
    end
  end
end