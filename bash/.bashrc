if [ -e ~/.bashrc.d/_import.sh ]; then
	source ~/.bashrc.d/_import.sh;
else
	echo "bashrc.d not found, skipping..."
fi

# pnpm
export PNPM_HOME="/home/mojtaba/.local/share/pnpm:/home/mojtaba/.local/share/pnpm/bin"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# kilo
export PATH=/home/mojtaba/.kilo/bin:$PATH

# mimocode
export PATH=/home/mojtaba/.mimocode/bin:$PATH
