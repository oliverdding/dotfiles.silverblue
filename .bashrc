#
# ~/.bashrc
#

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    set -a
    . /dev/fd/0 <<EOF
$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
EOF
    set +a
fi

export KUBECONFIG=$(echo $(ls ~/.kube/config.d/* 2>/dev/null) | sed 's/ /:/g')

[[ -f /etc/bashrc ]] && . /etc/bashrc

eval "$(starship init bash)"

