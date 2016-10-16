require "redis"

plain_redis = Redis.new

$redis = Redis::Namespace.new(Rails.env, redis: plain_redis)
