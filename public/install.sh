#/usr/bin/env bash

TENDERLOIN_TARGET="$HOME/tenderloin"

if [ -d "$TENDERLOIN_TARGET" ]; then
  echo "Tenderloin is already installed in $TENDERLOIN_TARGET \n"
  exit
fi

git clone git://github.com/patrickod/tenderloin.git $TENDERLOIN_TARGET

cd $TENDERLOIN_TARGET

echo -n "Enter a heroku project name: "
read -e HEROKU_TARGET

until heroku apps:create $HEROKU_TARGET
do
  echo -n "Enter a heroku project name: "
  read -e HEROKU_TARGET
done

DOMAIN_URL="http://$HEROKU_TARGET.herokuapp.com"

echo -n "Will you host this on a custom domain? [y/n] "
read -e CUSTOM_DOMAIN

if [ "$CUSTOM_DOMAIN" == "y" ]; then
  echo -n "Enter the domain you will use with Tenderloin: "
  read -e DOMAIN_URL
  heroku domains:add $DOMAIN_URL
  heroku config:set DOMAIN_URL=$DOMAIN_URL
fi

heroku addons:add redistogo:nano
heroku addons:add mongohq:sandbox
heroku config:set CABOOSE_ENV=production

git push heroku master
