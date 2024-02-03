#!/bin/bash
set -e

# Load NVM, if available
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Execute the command passed to the docker run command
exec "$@"

