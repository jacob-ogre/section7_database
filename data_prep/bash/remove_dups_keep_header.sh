#!/usr/bin/env bash

(head -1 $1 && tail -n +2 $1 | sort | uniq) > $2

