# in order for us the avoid uploading the json file manually
# and require us to declare the needed values as environment variable
# this initializer creates the .json required by the GCloud Authenticator

file_path = "#{File.expand_path('../gcloud.json', File.dirname(__FILE__))}"

gcloud_credentials = {
  type: 'service-account',
  project_id: ENV['GLCOUD_PROJECT_ID'],
  private_key_id: ENV['GCLOUD_PRIVATE_KEY_ID'],
  private_key: ENV['GCLOUD_PRIVATE_KEY'],
  client_email: ENV['GCLOUD_CLIENT_EMAIL'],
  client_id: ENV['GCLOUD_CLIENT_ID'],
  auth_uri: ENV['GCLOUD_AUTH_URI'],
  token_uri: ENV['GCLOUD_TOKEN_URI'],
  auth_provider_x509_cert_url: ENV['GCLOUD_AUTH_PROVIDER_X509'],
  client_x509_cert_url: ENV['GCLOUD_CLIENT_X509']
}

File.delete(file_path) if File.exist?(file_path)

File.open(file_path, 'a') do |file|
  file.write JSON.generate(gcloud_credentials)
end