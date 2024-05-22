service postgresql start

sudo -u postgres psql -f /home/conf/database-setup.sql

domain="$domain"
echo "도메인: $domain"
prefix="$prefix"
echo "prefix: $prefix"

git clone https://github.com/LightSwitch-S202/LightSwitch.git
cd /LightSwitch

echo frontend build
cd ./frontend
if [ -n "$prefix" ]; then
  echo "VITE_SERVER_BASEURL=$domain"$'\n'"VITE_BASE_URL=$prefix" > .env
else
  echo "VITE_SERVER_BASEURL=$domain" > .env
fi
yarn install
yarn build
cd /var/www/html
if [ -n "$prefix" ]; then
  mkdir /var/www/html$prefix
fi
cp -r /LightSwitch/frontend/dist/* /var/www/html$prefix

nginx_config="/etc/nginx/sites-enabled/default"
sed -i "s|\$prefix|${prefix:-}|g" $nginx_config
service nginx start

cd /LightSwitch

echo backend build
cd ./backend/core-service
chmod +x ./gradlew
./gradlew clean assemble
cd ./build/libs
jar_file=$(ls *.jar)
echo "실행할 .jar 파일: $jar_file"
java -jar -Dspring.cors.domain=$domain -Dserver.servlet.context-path=$prefix/api $jar_file
