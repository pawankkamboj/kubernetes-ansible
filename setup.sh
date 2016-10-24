#!/bin/bash


inventory=${INVENTORY:-inventory}

ansible-playbook -i ${inventory} cluster.yml $@
