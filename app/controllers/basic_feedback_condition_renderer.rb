# http://amberbit.com/blog/render-views-partials-outside-controllers-rails-3
# http://stackoverflow.com/a/6061215
# http://stackoverflow.com/questions/4713571/view-helper-link-to-in-model-class

class BasicFeedbackConditionRenderer < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor
  include Rails.application.routes.url_helpers

  cattr_accessor :controller
  def controller; self.class.controller; end
  def request; FakeRequest.new; end
  def env; {}; end
  
  BasicFeedbackConditionRenderer.controller = self

  # Uncomment if you want to use helpers defined in ApplicationHelper in your views
  helper ApplicationHelper

  # Make sure your controller can find views
  self.view_paths = "app/views"

  # You can define custom helper methods to be used in views here
  # helper_method :current_admin
  # def current_admin; nil; end

  def feedback_availability_message(basic_feedback_condition, student_exercise, feedback_closes_at)
    render :partial => 'basic_feedback_conditions/feedback_notification',
           :locals => { :basic_feedback_condition => basic_feedback_condition,
                        :student_exercise => student_exercise,
                        :feedback_closes_at => feedback_closes_at }
  end

  class FakeRequest
     def host
       Rails.application.config.action_controller.default_url_options[:host]
     end
     def optional_port
       Rails.application.config.action_controller.default_url_options[:port]
     end
     def protocol
       "http"
     end
     def symbolized_path_parameters
       {}
     end
   end
end