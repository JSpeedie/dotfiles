export XDG_CONFIG_HOME="$HOME/.config"
export SHELL=/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-9-openjdk/
export PATH=/usr/lib/jvm/java-9-openjdk/bin/:$PATH
if [ -t 1 ]; then exec $SHELL; fi
. "$HOME/.cargo/env"
