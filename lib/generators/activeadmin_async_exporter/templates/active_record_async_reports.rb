ActiveadminAsyncExporter.configure do |config|
  # FUTURE @horacio:
  # Configure your preferred uploader (S3, Dropbox or Google Drive):
  # config.report_uploader = ActiveadminAsyncExporter::Uploaders::AmazonS3

  # Configure with your AWS S3 credentials to upload your CSV reports.
  config.aws_s3_upload = true
  config.aws_s3_configuration = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
end
