install:
	rm -f ~/.vimrc
	ln -s ~/.vim/vimrc ~/.vimrc
	./build-docs.sh
