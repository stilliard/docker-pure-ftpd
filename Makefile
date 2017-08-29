.PHONY: build run kill enter setup-bob test-bob push pull

build:
	sudo docker build --rm -t pure-ftp-demo .

run: kill
	sudo docker run -d --name ftpd_server -p 21:21 -p 30000-30009:30000-30009 -e "PUBLICHOST=localhost" -e "ADDED_FLAGS=-d -d" pure-ftp-demo

kill:
	-sudo docker kill ftpd_server
	-sudo docker rm ftpd_server

enter:
	sudo docker exec -it ftpd_server sh -c "export TERM=xterm && bash"

# Setup test "bob" user with "test" as password
setup-bob:
	sudo docker exec -it ftpd_server sh -c "(echo test; echo test) | pure-pw useradd bob -f /etc/pure-ftpd/passwd/pureftpd.passwd -m -u ftpuser -d /home/ftpusers/bob"
	@echo "User bob setup with password: test"

# simple test to list files, upload a file, download it to a new name, delete it via ftp and read the new local one to make sure it's in tact
test-bob:
	echo "Test file was read successfully!" > test-orig-file.txt
	echo "user bob test\n\
	ls -alh\n\
	put test-orig-file.txt\n\
	ls -alh\n\
	get test-orig-file.txt test-new-file.txt\n\
	delete test-orig-file.txt\n\
	ls -alh" | ftp -n -v -p localhost 21
	cat test-new-file.txt
	rm test-orig-file.txt test-new-file.txt


# git commands for quick chaining of make commands
push:
	git push --all
	git push --tags

pull:
	git pull
