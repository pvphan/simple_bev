SHELL:=/bin/bash

WORKDIR_PATH=/simple_bev
REPO_PATH:=$(dir $(abspath $(firstword $(MAKEFILE_LIST))))
IMAGE_TAG?=pvphan/simplebev:0.1

ifneq ($(shell lshw -C display 2> /dev/null | grep NVIDIA | wc -l), 0)
	GPU_FLAG:=--gpus=all
endif

RUN_FLAGS = \
	--rm -it \
	${GPU_FLAG} \
	--ipc=host \
	--user="$(id -u):$(id -g)" \
	--volume=${REPO_PATH}:${WORKDIR_PATH}:ro \
	--volume=/tmp/simple_bev/output:/tmp/output \
	${IMAGE_TAG}

shell:
	docker run ${RUN_FLAGS} bash

image:
	docker build --tag ${IMAGE_TAG} .

train:
	docker run ${RUN_FLAGS} \
		python train_nuscenes.py \
		       --exp_name="rgb_mine" \
		       --max_iters=25000 \
		       --log_freq=1000 \
		       --dset='trainval' \
		       --batch_size=8 \
		       --grad_acc=5 \
		       --use_scheduler=True \
		       --data_dir='./nuscenes' \
		       --log_dir='/tmp/output/logs_nuscenes' \
		       --ckpt_dir='checkpoints' \
		       --res_scale=2 \
		       --ncams=6 \
		       --encoder_type='res101' \
		       --do_rgbcompress=True \
		       --device_ids=[0,1,2,3]
