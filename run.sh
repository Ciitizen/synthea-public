#!/usr/bin/env sh

##############################################################################
##
##  Synthea launcher for *NIX
##
##############################################################################

SERVICE=synthea
if [ $# -eq 0 ]; then
  # run synthea with no args
  docker run -v $PWD/output:/home/gradle/output $SERVICE

else
  # Running Synthea with arguments
  # For simplicity, do nothing and just pass the args to gradle
  SYNTHEA_ARGS=

  for arg in "$@"
  do
      SYNTHEA_ARGS=$SYNTHEA_ARGS\'$arg\',
      # Trailing comma ok, don't need to remove it
  done
  docker run -v $PWD/output:/home/gradle/output $SERVICE run -Params="[$SYNTHEA_ARGS]"
fi
