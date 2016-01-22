class Coursemology::Evaluator::Models::Base < Flexirest::Base
  class << self
    attr_accessor :api_user_email
    attr_accessor :api_token

    def initialize
      Flexirest::Base.perform_caching = false
      default_config = Flexirest::Base.faraday_config
      Flexirest::Base.faraday_config do |faraday|
        # +follow_redirects+ must be added before declaring the adapter. See faraday_middleware#32,
        # last comment.
        faraday.response :follow_redirects

        default_config.call(faraday)
      end
    end
  end

  verbose!
  before_request :add_authentication

  private

  # Adds the authentication email and token to the request.
  def add_authentication(_, request)
    request.headers['X-User-Email'] = self.class.api_user_email
    request.headers['X-User-Token'] = self.class.api_token
  end
end
