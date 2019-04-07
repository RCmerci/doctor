local:
	dune build bin/main.exe
linux: build
	docker run --rm -ti \
	-v $(shell pwd)/linux_build/doctor:/home/opam/doctor \
	doctor-build sh -c "cd /home/opam/doctor && dune build bin/main.exe"


linux-shell: build
	docker run --rm -ti \
	-v $(shell pwd)/linux_build/doctor:/home/opam/doctor \
	doctor-build sh -c "cd /home/opam/doctor && dune build bin/main.exe && bash"
build:
	docker build -t doctor-build .
	rsync -a $(shell pwd) linux_build --exclude linux_build --exclude _build
