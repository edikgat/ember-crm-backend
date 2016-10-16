class APIAuthenticator
  ADDITIONAL_ACTIVITY_PERIOD = 30.day

  attr_reader :token, :resource_class

  def initialize(token, resource_class)
    @token = token
    @resource_class = resource_class
  end

  def process
    json_str = $redis.get redis_token
    return false unless json_str
    redis_hash = JSON.parse(json_str)
    @resource_id = redis_hash['resource_id']
    $redis.expire redis_token, ADDITIONAL_ACTIVITY_PERIOD
    true
  end

  def destroy
    json_str = $redis.get redis_token
    return false unless json_str
    $redis.del redis_token
    true
  end

  def resource
    @resource ||= resource_class.find(@resource_id)
  end

  private

  def token_prefix
    resource_class.to_s
  end

  def redis_token
    "#{token_prefix}:#{token}"
  end

end
