class APILogIn
  ACTIVITY_PERIOD = 30.day

  attr_reader :token, :resource_id, :resource_class

  def initialize(resource_id, resource_class)
    @resource_id = resource_id
    @resource_class = resource_class
  end

  def process
    redis_token = nil
    loop do
      @token = SecureRandom.urlsafe_base64
      redis_token = token_key(@token)
      break if $redis.get(redis_token).blank?
    end
    $redis.set redis_token, {'resource_id' => resource_id}.to_json
    $redis.expire token, ACTIVITY_PERIOD
    true
  end

  private

  def token_key(secure_string)
    "#{resource_class.to_s}:#{secure_string}"
  end

end
