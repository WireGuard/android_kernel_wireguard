#!/bin/sh
set -e

if [ ! -d android_external_bash-cm-14.1 ]; then
	curl -L -o bash.zip https://github.com/LineageOS/android_external_bash/archive/cm-14.1.zip
	unzip bash.zip
	rm bash.zip
fi

if [ ! -d android_external_libncurses-cm-14.1 ]; then
	curl -L -o ncurses.zip https://github.com/LineageOS/android_external_libncurses/archive/cm-14.1.zip
	unzip ncurses.zip
	rm ncurses.zip
fi
