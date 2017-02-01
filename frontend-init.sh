#!/usr/bin/env bash

set -e

red() {
  echo -e "\033[31m $1\033[0m"
}

green() {
  echo -e "\033[0;32m$1\033[0m"
}

white() {
  echo -e "\033[0;37m$1\033[0m"
}


if [[ -z "$1" ]]; then
  red "Usage: front-init APP_PATH."
  exit 1
else
  app_path="$1"
fi

echo "Creating the front-end structure..."

# Create all the structure directories.
for dir in \
  stylesheets \
  javascripts \
  images \
  bin \
  scss \
  scss/config \
  scss/components \
  scss/vendor \
  scss/mixins
do
  green "Creating $app_path/$dir"
  mkdir -p "$app_path/$dir"
done

green "Cloning files from https://gist.github.com/andrielfn/4c54e1b527768298e1ec0e20a9a95314"
git clone --quiet https://gist.github.com/andrielfn/4c54e1b527768298e1ec0e20a9a95314 "$app_path/tmp"

declare -A files
files=(
    [".scss-lint.yml"]=""
    ["index.html"]=""
    ["scss-watch"]="bin"
    ["server"]="bin"
    ["application.scss"]="scss"
    ["base.scss"]="scss/config"
    ["variables.scss"]="scss/config"
    ["media.scss"]="scss/mixins"
)

for i in "${!files[@]}"
do
    file=$i
    dir=${files[$i]}
    green "Placing $file into $app_path/$dir"
    mv "$app_path/tmp/$file" "$app_path/$dir"
done

rm -rf "$app_path/tmp"

chmod -R +x "$app_path/bin"

curl -s -o "$app_path/scss/vendor/normalize.scss" https://raw.githubusercontent.com/necolas/normalize.css/master/normalize.css
