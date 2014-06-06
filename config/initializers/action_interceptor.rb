ActionInterceptor.configure do
  # intercepted_url_key(key)
  # Type: Method
  # Arguments: key (Symbol)
  # The parameter/session variable that will hold the intercepted URL.
  # Default: :r
  intercepted_url_key :r

  # override_url_options(bool)
  # Type: Method
  # Arguments: bool (Boolean)
  # If true, the url_options method will be overriden for any controller that
  # `acts_as_interceptor`. This option causes all links and redirects from any
  # such controller to include a parameter containing the intercepted_url_key
  # and the intercepted url. Set to false to disable for all controllers.
  # If set to false, you must use the interceptor_url_options method to obtain
  # the hash and pass it to any links or redirects that need to use it.
  # Default: true
  override_url_options true

  # interceptor(interceptor_name, &block)
  # Type: Method
  # Arguments: interceptor name (Symbol or String),
  #            &block (Proc)
  # Defines an interceptor.
  # Default: none
  # Example: interceptor :my_name do
  #            redirect_to my_action_users_url if some_condition
  #          end
  #
  #          (Conditionally redirects to :my_action in UsersController)

  interceptor :terp_authenticate_user do
    return if user_signed_in?
    redirect_to terp_sign_in_path
  end
end
