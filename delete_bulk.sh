while read -r package; do
  brew uninstall "$package"
done < packages.txt
