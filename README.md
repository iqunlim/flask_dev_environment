cp ./.env_default .env -> add in your own information to .env
Register/have a domain name ready.
run ./start.sh prod to get the server set up in regular http mode for certbot validation
then run: 
docker-compose -f docker-compose-prod.yml run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d [DOMAIN-NAME] to test, remove --dry-run whenever you are ready to
edit [DOMAIN-NAME] occurences nginx.conf-prod to your domain and run rm ./nginx/nginx.conf && mv ./nginx/nginx.conf-prod ./nginx/nginx.conf
Any time you need to renew your certificate (letsencrypt enforces a 3 month policy)
docker-compose -f docker-compose-prod.yml run --rm certbot renew