NIMVERS=2.0.0
URL=https://nim-lang.org/download/nim-${NIMVERS}_linux_x64.tar.xz
INSTALL_DIR=$HOME/nim
mkdir -p "$INSTDIR"
curl -L "$URL" -o nim.tar.xz
tar -xf nim.tar.xz -C "$INSTDIR"
rm nim.tar.xz
echo "export PATH=\$PATH:$INSTDIR/nim-$NIMVERS/bin" >> $HOME/.bashrc
