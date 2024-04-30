# kill at port 
# Shout out TrashDev - https://github.com/bautistaaa/dotfiles/blob/master/zsh-custom/functions.zsh
killAtPort() {
  lsof -i TCP:$1 | grep LISTEN | awk '{print $2}' | xargs kill -9
  echo "Port" $1 "found and killed."
}

function setAwsProfile() {
  export AWS_PROFILE="$1"
  # Attempt to use the credentials to perform a lightweight AWS operation.
  if aws sts get-caller-identity --profile "$AWS_PROFILE" > /dev/null 2>&1; then
    echo "Already logged in as $AWS_PROFILE"
  else
    echo "Logging in as $AWS_PROFILE"
    aws sso login --profile "$AWS_PROFILE"
  fi
  # After ensuring the login, export the necessary credentials and region.
  eval "$(aws configure export-credentials --profile $AWS_PROFILE --format env)"
  export AWS_REGION="eu-west-1"
  echo "Now using $AWS_PROFILE"
  echo "Credentials expire in $AWS_CREDENTIAL_EXPIRATION"
}
