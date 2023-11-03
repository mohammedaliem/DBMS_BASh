#!/bin/bash

. ./function.sh

export LC_COLLATE=C
shopt -s extglob






listtables $1
