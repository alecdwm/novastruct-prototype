phony:
	@echo -ne "\033[0;33mAvailable commands:\033[0m\n\n\
make run\t- runs the game\n\
make pack-win\t- packages the game for windows\n\
make pack-osx\t- packages the game for osx\n"

run:
	@love .

pack-win:
	@echo "Building..."
	@zip prototype.love *
	@echo "Packing..."
	@wget -q https://bitbucket.org/rude/love/downloads/love-0.10.1-win64.zip
	@unzip -q love-0.10.1-win64.zip
	@mv love-0.10.1-win64 prototype-win
	@cat prototype-win/love.exe prototype.love > prototype-win/prototype.exe
	@rm prototype-win/changes.txt
	@rm prototype-win/game.ico
	@rm prototype-win/license.txt
	@rm prototype-win/love.exe
	@rm prototype-win/love.ico
	@rm prototype-win/readme.txt
	@zip -qr prototype-win.zip prototype-win
	@echo "Cleaning up..."
	@rm -r prototype-win
	@rm love-0.10.1-win64.zip
	@rm prototype.love

pack-osx:
	@echo "Building..."
	@zip prototype.love *
	@echo "Packing..."
	@wget -q https://bitbucket.org/rude/love/downloads/love-0.10.1-macosx-x64.zip
	@unzip -q love-0.10.1-macosx-x64.zip
	@mv love.app prototype.app
	@mv prototype.love prototype.app/Contents/Resources/
	@sed -i 's#<string>org.love2d.love</string>#<string>au.com.bytestack.prototype</string>#g' prototype.app/Contents/Info.plist
	@sed -i 's#<string>LÖVE</string>#<string>prototype</string>#g' prototype.app/Contents/Info.plist
	@sed -i '92,119d' prototype.app/Contents/Info.plist
	@zip -qr prototype-mac.zip prototype.app
	@echo "Cleaning up..."
	@rm -r prototype.app
	@rm love-0.10.1-macosx-x64.zip
