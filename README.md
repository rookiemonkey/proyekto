## Proyekto (SaaS App)

An app allowing organization to manage their projects by creating projects (depending on their plan) and adding their staffs on their account 

Consider checking the repo's issues, all of my todos are in there :smile:

## Setup Locally

* Environment Variables
  * Rails (```config/application.yml```)
    * PAYMONGO_PK
    * PAYMONGO_SK
    * GLCOUD_BUCKET_NAME
    * GCLOUD_PROJECT_ID
    * GCLOUD_PRIVATE_KEY_ID
    * GCLOUD_PRIVATE_KEY
    * GCLOUD_CLIENT_EMAIL
    * GCLOUD_CLIENT_ID
    * GCLOUD_AUTH_URI
    * GCLOUD_TOKEN_URI
    * GCLOUD_AUTH_PROVIDER_X509
    * GCLOUD_CLIENT_X509
    * MAILTRAP_USERNAME
    * MAILTRAP_PASSWORD
    * MAILTRAP_ADDRESS
    * MAILTRAP_DOMAIN
    * MAILTRAP_PORT
  * Webpacker (```config/webpack/.env```)
    * PAYMONGO_PK

* Paymongo
  * Sign up and get API Keys https://dashboard.paymongo.com/signup
  * Set paymongo environment variables (pattern, 'PAYMONGO_*')

* Google Cloud
  * Sign up and get API Keys (Follow 'create a service account' instructions)
    * https://googleapis.dev/ruby/google-cloud-storage/latest/file.AUTHENTICATION.html
  * Once service account is created, you'll need to create and download the key
    * https://cloud.google.com/iam/docs/creating-managing-service-account-keys
  * Set the google cloud environment variables (pattern, 'GCLOUD_*') in strings. Values for this keys will come from the downloaded json file
  * An initializer file will be the one to create the .json automatically so we don't have to include the .json file on the source code and all we need is to define the keys as environment variables

* Mailtrap
  * SIgn up and get the needed environment variable values here  https://mailtrap.io/

## Notes
- As of the moment, this app uses the ```guro-app``` google cloud project to have an access to a cloud storage container. This is because i've reached the maximum amount of projects that I can apply my current billing account number (Cloud Storage requires a billing account number)

## Author: <i>Kevin Roi R. Basina</i>
<a href="https://github.com/rookiemonkey">
	<img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" />
</a>
<a href="https://ph.linkedin.com/in/kevin-roi-rigor-basina-668136185">
	<img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white">
</a>
<a href="https://www.facebook.com/kevinroibasina">
	<img src="https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white" />
<a>
<a href="https://www.instagram.com/timemachineni_roi/">
	<img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white">
</a>
<a href="https://twitter.com/tymmchineni_roi">
	<img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white">
</a>
<a href="mailto: kevinroirigorbasina@protonmail.com">
	<img src="https://img.shields.io/badge/ProtonMail-8B89CC?style=for-the-badge&logo=protonmail&logoColor=white">
</a>
<a href="mailto: kevinroirigorbasina@gmail.com">
	<img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white">
</a>