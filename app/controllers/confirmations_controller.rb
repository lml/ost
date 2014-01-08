class ConfirmationsController < Devise::ConfirmationsController
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy
end