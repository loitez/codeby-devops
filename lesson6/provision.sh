#!/bin/bash

ROLE=$1

if [ "$ROLE" = "client" ]; then

  sudo -u vagrant ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa

  cp /home/vagrant/.ssh/id_rsa.pub /vagrant/client_key.pub
  chmod 644 /vagrant/client_key.pub

fi


if [ "$ROLE" = "server" ]; then

  mkdir -p /home/vagrant/.ssh
  chmod 700 /home/vagrant/.ssh

  while [ ! -f /vagrant/client_key.pub ]; do
    sleep 2
  done

  cat /vagrant/client_key.pub >> /home/vagrant/.ssh/authorized_keys

  chmod 600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant:vagrant /home/vagrant/.ssh

fi