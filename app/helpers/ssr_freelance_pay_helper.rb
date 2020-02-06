module SsrFreelancePayHelper


  def select_mark_pay_freelance
    IssueCustomField.all.map { |item| [item.name, item.id] }
  end
  
  
  

  def self.check_field_on_pay
    field = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_field_id'].to_i
    if Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_field_id'].to_i != 0
      if field_issue = IssueCustomField.find(field)
        unless UserCustomField.find_by(name: field_issue.name)
          ucf_pay = UserCustomField.new
          ucf_pay << field_issue
          ucf_pay.type = "UserCustomField"
          if ucf_pay.save
          end
        end
        unless UserCustomField.find_by(name: "Номер карты/кошелька/телефона")
          ucf_wallet = UserCustomField.new(name: "Номер карты/кошелька/телефона",
                                           field_format: "string",
                                           possible_values: nil,
                                           regexp: "",
                                           min_length: nil,
                                           max_length: 40,
                                           is_required: false,
                                           is_for_all: false,
                                           is_filter: false,
                                           position: 7,
                                           searchable: false,
                                           default_value: "",
                                           editable: true,
                                           visible: true,
                                           multiple: false,
                                           format_store: {"text_formatting" => "",
                                                          "url_pattern" => ""},
                                           description: "",
                                           formula: nil,
                                           is_computed: false)
          ucf_wallet.save
          ucf_wallet = IssueCustomField.new(name: "Номер карты/кошелька/телефона",
                                            field_format: "string",
                                            possible_values: nil,
                                            regexp: "",
                                            min_length: nil,
                                            max_length: 40,
                                            is_required: false,
                                            is_for_all: false,
                                            is_filter: false,
                                            position: 7,
                                            searchable: false,
                                            default_value: "",
                                            editable: true,
                                            visible: true,
                                            multiple: false,
                                            format_store: {"text_formatting" => "",
                                                           "url_pattern" => ""},
                                            description: "",
                                            formula: nil,
                                            is_computed: false)
          ucf_wallet.save
        end
    end
  end
end
end