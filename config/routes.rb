# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
post '/ssrfreelance/delete/(:id)' => 'ssr_freelance#delete'
post '/ssrfreelance/add/(:id)' => 'ssr_freelance#add'
post '/ssrfreelance/addfields/(:id)' => 'ssr_freelance#addfield'
post '/ssrfreelance/deletefield/(:id)' => 'ssr_freelance#deletefield'
post '/ssrfreelance/check_pay' => 'ssr_freelance#user_role_freelance?'
post '/ssrfreelance/check_pay_wallet' => 'ssr_freelance#user_pay_freelance'

