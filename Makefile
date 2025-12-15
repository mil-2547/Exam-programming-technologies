
all:
	docker build -t artiprice/my-gcc-ccache:latest .
	docker login
	docker push artiprice/my-gcc-ccache

check:
	docker run --rm my-gcc-ccache:latest ccache --version