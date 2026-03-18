.DEFAULT_GOAL := install
export PATH := /opt/homebrew/bin:/opt/homebrew/sbin:$(PATH)
BREW := $(shell command -v brew || echo /opt/homebrew/bin/brew)

dotfiles = .asdfrc \
				.fzf.zsh \
				.aliases \
				.secrets \
				.gitconfig \
				.tmux.conf \
				.tmate.conf \
				.tool-versions \
				.zshrc

install: shell symlink packages vim languages other

cyan = "\\033[1\;96m"
off  = "\\033[0m"
echo.%:
	@echo "\n$(cyan)Building $*$(off)"

packages: echo.packages
	$(BREW) bundle

shell: echo.shell
	bin/shell

symlink: echo.symlink
	@for file in $(dotfiles); do \
		rm -rf ~/$$file ;\
		ln -s $(shell pwd)/$$file ~/$$file ;\
	done

vim: echo.vim
	mkdir -p ~/.config/nvim ;\
	rm -rf ~/.config/nvim/init.vim ;\
	ln -s $(shell pwd)/.init.vim ~/.config/nvim/init.vim ;\
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;\
	nvim --headless +PlugInstall +qa

languages: echo.languages
	bin/languages

other: echo.other
	defaults write com.apple.screencapture location ~/Downloads;killall SystemUIServer ;\
  defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder ;\
	python3 -m pip install --user --upgrade --break-system-packages pynvim;\
	rm -rf ~/.config/karabiner/karabiner.json ;\
	ln -s $(shell pwd)/karabiner.json ~/.config/karabiner/karabiner.json 
