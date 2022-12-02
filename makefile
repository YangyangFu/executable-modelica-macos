USER_NAME = passivelogic
IMA_NAME = benchmark
TAG_JMODELICA = jmodelica 
TAG_DYMOLA = dymola
TAG_OMC = omc 

# build for M1 arm64 chip
build_jmodelica:
	docker build --platform linux/arm64 -f DockerfileJmodelica --no-cache --rm -t ${USER_NAME}/${IMA_NAME}:${TAG_JMODELICA} .

build_dymola:
	docker build -f DockerfileDymola --no-cache --rm -t ${USER_NAME}/${IMA_NAME}:${TAG_DYMOLA} .

build_omc:
	docker build -f DockerfileOMC --no-cache --rm -t ${USER_NAME}/${IMA_NAME}:${TAG_OMC} .
