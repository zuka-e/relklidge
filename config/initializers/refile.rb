if Rails.env.production?
  require "refile/s3"

  aws = {
    access_key_id: ENV['S3_ACCESS_KEY'],
    secret_access_key: ENV['S3_SECRET_KEY'],
    region: ENV['S3_REGION'],
    bucket: ENV['S3_BUCKET'],
  }
  Refile.cache = Refile::S3.new(prefix: "cache", **aws)
  Refile.store = Refile::S3.new(prefix: "store", **aws)
end
