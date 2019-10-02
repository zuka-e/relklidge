if Rails.env.production?
  require "refile/s3"

  aws = {
    access_key_id: Rails.application.credentials.s3[:access_key],
    secret_access_key: Rails.application.credentials.s3[:secret_access_key],
    region:  Rails.application.credentials.s3[:region],
    bucket:  Rails.application.credentials.s3[:bucket],
  }
  Refile.cache = Refile::S3.new(prefix: "cache", **aws)
  Refile.store = Refile::S3.new(prefix: "store", **aws)
end
