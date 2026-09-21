if [ -e ~/.bashrc.d/_import.sh ]; then
	source ~/.bashrc.d/_import.sh;
else
	echo "bashrc.d not found, skipping..."
fi
