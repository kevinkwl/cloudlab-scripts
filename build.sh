source ./config.sh

make -j`nproc` && make INSTALL_MOD_PATH=${MOD_PATH}
